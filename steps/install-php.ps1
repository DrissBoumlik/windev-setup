try {
    Write-Host "`nDownloading PHP versions..."
    $phpBaseUrl = "https://windows.php.net/downloads/releases"
    $phpZipFilesNames = Get-Content "$PWD\data\php.txt" | Where-Object { $_ -ne "" }
    Make-Directory -path "$downloadPath\env\zip"
    Make-Directory -path "$downloadPath\env\php_stuff\php"
    foreach ($fileNameZip in $phpZipFilesNames) {
        # $fileNameZip = Split-Path $url -Leaf
        $fileName = $fileNameZip -replace ".zip", ""
        $url = "$phpBaseUrl/archives/$fileNameZip"
        try {
            try {
                Download-File -url $url -output "$downloadPath\env\zip\$fileNameZip"
            }
            catch {
                $url = "$phpBaseUrl/$fileNameZip"
                Download-File -url $url -output "$downloadPath\env\zip\$fileNameZip"
            }
            Extract-Zip -zipPath "$downloadPath\env\zip\$fileNameZip" -extractPath "$downloadPath\env\php_stuff\php\$fileName"
            Copy-Item -Path "$downloadPath\env\php_stuff\php\$fileName\php.ini-development" -Destination "$downloadPath\env\php_stuff\php\$fileName\php.ini"
            if ($fileName -match "php-(\d+)\.(\d+)\.") {
                $majorVersion = $matches[1]
                $minorVersion = $matches[2]
                if ($minorVersion -eq '0') { $phpEnvVarName = $majorVersion } 
                else { $phpEnvVarName = "$majorVersion$minorVersion" }
                $phpEnvVarName = "php$phpEnvVarName"
                Add-Env-Variable -newVariableName $phpEnvVarName -newVariableValue "$downloadPath\env\php_stuff\php\$fileName" -updatePath 0 -overrideExistingEnvVars $overrideExistingEnvVars
            }
        } catch {
            $WhatWasDoneMessages = Set-Error-Message -message "PHP : Issue with $fileName" -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }

    $VcUrls = @(
        "vcredist_x86.exe",
        "vcredist_x64.exe"
    )
    Make-Directory -path "$downloadPath\apps"
    $vcBaseUrl = "https://download.microsoft.com/download/1/6/B/16B06F60-3B20-4FF2-B699-5E9B7962F9AE/VSU_4"
    foreach ($url in $VcUrls) {
        $url = "$vcBaseUrl/$url"
        $fileName = Split-Path $url -Leaf
        try { Download-File -url $url -output "$downloadPath\apps\$fileName" }
        catch { $WhatWasDoneMessages = Set-Error-Message -message "PHP (VC++) : Issue with $fileName" -WhatWasDoneMessages $WhatWasDoneMessages }
    }
    Remove-Item -Path "$downloadPath\env\zip" -Recurse -Force

    # phpcs, phpcbf, phpmd, phpstan, phpfixer
    $phpTools = @(
        @{ name = "phpcs"; url = "https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar" }
        @{ name = "phpcbf"; url = "https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar" }
        @{ name = "phpmd"; url = "https://github.com/phpmd/phpmd/releases/download/2.15.0/phpmd.phar" }
        @{ name = "phpstan"; url = "https://github.com/phpstan/phpstan/releases/download/1.11.5/phpstan.phar" }
        @{ name = "phpcsfixer"; url = "https://github.com/PHP-CS-Fixer/PHP-CS-Fixer/releases/download/v3.59.3/php-cs-fixer.phar" }
    )
    Make-Directory -path "$downloadPath\env\php_stuff\tools"
    foreach ($phpTool in $phpTools) {
        $url = $phpTool.url 
        $path = "$downloadPath\env\php_stuff\tools" 
        $fileName = $phpTool.name
        try {
            Download-File -url $url -output "$path\$fileName.phar"
            $batString = (Get-Content "$PWD\data\php-tool-phar.txt" -Raw) -replace '\$fileName', $fileName
            $batString = $batString -replace "`t{2}"
            Add-Content -Path "$path\$fileName.bat" -Value $batString
        } catch {
            $WhatWasDoneMessages = Set-Error-Message -message "PHP (TOOLS) : Issue with $fileName" -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }

    $WhatWasDoneMessages = Set-Success-Message -message "PHP versions (& Tools) were downloaded & setup successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    $WhatToDoNext = Set-Todo-Message -message "Your PHP path is '$downloadPath\env\php_stuff\php'" -WhatToDoNext $WhatToDoNext
}
catch {
    $WhatWasDoneMessages = Set-Error-Message -message "PHP versions failed to download/setup" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
}