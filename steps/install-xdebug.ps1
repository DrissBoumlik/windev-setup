try {
    Write-Host "`nDownloading XDEBUG..."
    $xdebugUrls = Get-Content "$PWD\data\xdebug.txt" | Where-Object { $_ -ne "" }
    Make-Directory -path "$downloadPath\env\php_stuff\xdebug"
    $phpVersionsWithXdebug = @()
    foreach ($url in $xdebugUrls) {
        $fileName = Split-Path $url -Leaf
        try {
            if ($fileName -match "-(\d+\.\d+)-(vs|vc)") {
                $phpVersion = $matches[1]
                Make-Directory -path "$downloadPath\env\php_stuff\xdebug\$phpVersion"
                $outputPathXdebug = "$downloadPath\env\php_stuff\xdebug\$phpVersion\$fileName"
                Download-File -url $url -output $outputPathXdebug

                $phpPaths = Get-ChildItem -Path "$downloadPath\env\php_stuff\php" -Directory | Select-Object -ExpandProperty Name
                if ($phpPaths.Count -gt 0) {
                    $xDebugConfig = (Get-Content "$PWD\data\config-xdebug-2.txt" -Raw) -replace '\$outputPathXdebug', $outputPathXdebug
                    if ($fileName -match "php_xdebug-([\d\.]+)") {
                        $xDebugVersion = $matches[1]
                        if ($xDebugVersion -like "3.*") {
                            $xDebugConfig = (Get-Content "$PWD\data\config-xdebug-3.txt" -Raw) -replace '\$outputPathXdebug', $outputPathXdebug
                        }
                    }

                    foreach ($phpPath in $phpPaths) {
                        if ($phpPath -like "*$phpVersion*") {
                            if (-not($phpVersionsWithXdebug -contains $phpVersion)) {
                                $phpVersionsWithXdebug += $phpVersion
                                $xDebugConfig = $xDebugConfig -replace "\ +"
                                Add-Content -Path "$downloadPath\env\php_stuff\php\$phpPath\php.ini" -Value $xDebugConfig
                                break
                            }
                        }
                    }
                }
            }
        } catch {
            $WhatWasDoneMessages = Set-Error-Message -message "XDEBUG : Issue with $fileName" -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }
    $WhatWasDoneMessages = Set-Success-Message -message "XDEBUG versions downloaded & setup successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    $WhatToDoNext = Set-Todo-Message -message "Your XDebug path is '$downloadPath\env\php_stuff\xdebug'" -WhatToDoNext $WhatToDoNext
}
catch {
    $WhatWasDoneMessages = Set-Error-Message -message "XDEBUG versions failed to download/setup" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
}