#!/bin/sh
set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

if [ "$1" = 'php-fpm' ] || [ "$1" = 'php' ]; then
	# Install the project the first time PHP is started
	# After the installation, the following block can be deleted
	if [ ! -f composer.json ]; then

                cp -n .env.example .env

		rm -Rf tmp/
		composer create-project "roots/bedrock:$BEDROCK_VERSION" tmp --prefer-dist --no-progress --no-interaction --no-install

                cd tmp

                rm .env .env.example README.* LICENSE.* .gitignore

		cp -Rp . ..

		composer require "php:>=$PHP_VERSION"
		composer require --dev deployer/deployer

                cd -
		rm -Rf tmp/

                echo "To finish the installation please press Ctrl+C to stop Docker Compose and run: docker compose up --build"
                sleep infinity
	fi

	if [ "$WP_ENV" != 'production' ]; then
		composer install --prefer-dist --no-progress --no-interaction

		if [ -f vendor/bin/dep ] && [ ! -f bin/dep ]; then
			mkdir -p bin /etc/bash_completion.d

			ln -sf ../vendor/bin/dep bin/dep

			# Uncomment when deployer will be fixed
			# bin/dep completion bash > /etc/bash_completion.d/dep'
		fi
  	fi

        echo "Waiting for db to be ready..."
        ATTEMPTS_LEFT_TO_REACH_DATABASE=60
        until [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ] || DATABASE_ERROR=$(docker-mysqltest 2>&1); do
                sleep 1
                ATTEMPTS_LEFT_TO_REACH_DATABASE=$((ATTEMPTS_LEFT_TO_REACH_DATABASE - 1))
                echo "Still waiting for db to be ready... Or maybe the db is not reachable. $ATTEMPTS_LEFT_TO_REACH_DATABASE attempts left"
        done

        if [ $ATTEMPTS_LEFT_TO_REACH_DATABASE -eq 0 ]; then
                echo "The database is not up or not reachable:"
                echo "$DATABASE_ERROR"
                exit 1
        else
                echo "The db is now ready and reachable"
        fi

	setfacl -R -m u:www-data:rwX -m u:"$(whoami)":rwX web/app
	setfacl -dR -m u:www-data:rwX -m u:"$(whoami)":rwX web/app

fi

exec docker-php-entrypoint "$@"
