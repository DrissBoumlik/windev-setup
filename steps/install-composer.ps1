#region DOWNLOAD COMPOSER
if ($StepsQuestions["COMPOSER"].Answer -eq "yes") {
    
    try {
        Write-Host "`nDownloading and installing Composer..."
        choco install composer -a > $null 2>&1
        $WhatWasDoneMessages = Set-Success-Message -message "Composer was installed successfully!" -WhatWasDoneMessages $WhatWasDoneMessages

        $url = "https://getcomposer.org/download/1.10.27/composer.phar"
        Download-File -url $url -output "$PWD\tools\composer-v1\composer.phar"

        # Copy composer version 1 to the composer path
        Copy-Item -Path "$PWD\tools\composer-v1" -Destination "C:\composer\v1" -Recurse
        Update-Path-Env-Variable -variableName "C:\composer\v1" -isVarName 0

        $WhatWasDoneMessages = Set-Success-Message -message "composer1 was successfully added to the PATH" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Composer failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }

}
#endregion