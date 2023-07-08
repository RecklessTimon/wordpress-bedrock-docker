<h1>Installation</h1>

<h2>Create new project</h2>

<ul>
    <li>Fork this repository</li>
    <li>Docker compose up --build</li>
    <li>Open http://localhost in your favorite web browser and complete the wordpress installation</li>
</ul>

<h2>Installing on an Existing Project</h2>

<p>First, download <a href="https://github.com/RecklessTimon/wordpress-bedrock-docker" target="_blank">this skeleton<a>. If you clone the Git repository, be sure to remove the .git directory to prevent conflicts with the .git directory already in your existing project.</p>

<p>Then, copy the Docker-related files from the skeleton to your existing project:</p>

<code>cp -Rp wordpress-bedrock-docker/. my-existing-project/</code>

<p>Double-check the changes, revert the changes that you don't want to keep:>

<code>
    git diff
    ...
</code>

<p>Start and build the Docker:</p>

<code>docker compose up -d --build</code>

<p>Browse https://localhost, your Docker configuration is ready!</p>

<h1>WordPress</h1>

<p>This project use <a href="https://roots.io/bedrock/" target="_blank">Bedrock Wordpress boilerplate</a>.</p>