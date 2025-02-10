$url = "https://deac-fra.dl.sourceforge.net/project/xampp/XAMPP%20Windows/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe?viasf=1"
$WhatWasDoneMessages = Download-App -name "Xampp" -url $url -output "1-xampp-windows-x64-8.2.12-0-VS16-installer.exe"

$url = "https://getcomposer.org/Composer-Setup.exe"
$WhatWasDoneMessages = Download-App -name "Composer" -url $url -output "2-Composer-Setup.exe"

Make-Directory -path "$downloadPath\env\php_stuff"
$url = "https://getcomposer.org/download/1.10.27/composer.phar"
Download-File -url $url -output "$PWD\tools\composer-v1\composer.phar"