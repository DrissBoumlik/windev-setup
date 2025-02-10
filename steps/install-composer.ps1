
$url = "https://getcomposer.org/Composer-Setup.exe"
$WhatWasDoneMessages = Download-App -name "Composer" -url $url -output "2-Composer-Setup.exe"

Make-Directory -path "$downloadPath\env\php_stuff"
$url = "https://getcomposer.org/download/1.10.27/composer.phar"
Download-File -url $url -output "$PWD\tools\composer-v1\composer.phar"