#!/usr/bin/env php
<?php

$DB_HOST=getenv('DB_HOST');
$DB_NAME=getenv('DB_NAME');
$DB_USER=getenv('DB_USER');
$DB_PASSWORD=getenv('DB_PASSWORD');

if (empty(array_filter([$DB_HOST, $DB_NAME, $DB_USER, $DB_PASSWORD])) && getenv('DATABASE_URL')) {
    ['host' => $DB_HOST, 'path' => $DB_NAME, 'user' => $DB_USER, 'pass' => $DB_PASSWORD] = parse_url(getenv('DATABASE_URL'));
    $DB_NAME=ltrim($DB_NAME, '/');
}

try {
    $mysqli = mysqli_connect($DB_HOST, $DB_USER, $DB_PASSWORD, $DB_NAME);
} catch (Exception $e){
    return $e->getCode();
}

if ($code = mysqli_connect_errno()) {
    return $code;
}

$mysqli->query('SELECT 1');
if ($mysqli->errno) {
    return $mysqli->errno;
}

return 0;