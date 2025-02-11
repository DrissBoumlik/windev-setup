
$ProgressPreference = 'SilentlyContinue'

if (($StepsQuestions["GIT"].Answer -eq "yes") -or ($StepsQuestions["REDIS"].Answer -eq "yes") -or ($StepsQuestions["NVM"].Answer -eq "yes")) {
    
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

    #region DOWNLOAD & INSTALL GIT
    if ($StepsQuestions["GIT"].Answer -eq "yes") {
        try {
            Write-Host "`nDownloading and installing Git..."
            choco install git.install -y > $null 2>&1
            $WhatWasDoneMessages = Set-Success-Message -message "Git was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
        }
        catch {
            $WhatWasDoneMessages = Set-Error-Message -message "Git failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }
    #endregion

    #region DOWNLOAD & INSTALL NVM
    if ($StepsQuestions["NVM"].Answer -eq "yes") {
        try {
            Write-Host "`nDownloading and installing NVM..."
            choco install nvm -y > $null 2>&1
            $WhatWasDoneMessages = Set-Success-Message -message "NVM was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
        }
        catch {
            $WhatWasDoneMessages = Set-Error-Message -message "NVM failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }
    #endregion

    #region DOWNLOAD & INSTALL REDIS
    if ($StepsQuestions["REDIS"].Answer -eq "yes") {
        try {
            Write-Host "`nDownloading and installing REDIS..."
            choco install redis-64 --version=3.0.503 -y > $null 2>&1
            $WhatWasDoneMessages = Set-Success-Message -message "REDIS was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
        }
        catch {
            $WhatWasDoneMessages = Set-Error-Message -message "REDIS failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
        }
    }
    #endregion
    
}

#region DOWNLOAD & INSTALL PVM
if ($StepsQuestions["PVM"].Answer -eq "yes") {
    try {
        Write-Host "`nDownloading and installing PVM..."
        $pvmUrl = "https://github.com/drissboumlik/pvm/archive/refs/heads/master.zip"
        Download-File -url $pvmUrl -output "$downloadPath\pvm.zip"
        Extract-Zip -zipPath "$downloadPath\pvm.zip" -extractPath "$downloadPath\env\tools\pvm"
        Remove-Item "$downloadPath\pvm.zip"
        
        Update-Path-Env-Variable -variableName "$downloadPath\env\tools\pvm\pvm-master" -isVarName 0
        
        $WhatWasDoneMessages = Set-Success-Message -message "PVM was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "PVM failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion