
. $PWD\functions.ps1

$ProgressPreference = 'SilentlyContinue'

$Global:ENV_FILE = "$PSScriptRoot\.env"      
$Global:USER_ENV = Get-Env

Write-Host "`nThis will setup your env with (Git, Xampp, Composer, NVM, Chocolatey, Some enhanced tools, Cmder, PHP, XDebug)`n"

#region ANSWER QUESTIONS FOR WHICH STEPS TO EXECUTE
$StepsQuestions = [ordered]@{
   APPS = [PSCustomObject]@{ Question = "- Download Notepad++, Lightshot, Ditto, Wox ?"; Answer = "no" }
   XAMPP_COMPOSER = [PSCustomObject]@{ Question = "- Download Xampp, Composer ?"; Answer = "no" }
   GIT = [PSCustomObject]@{ Question = "- Download Git ?"; Answer = "no" }
   NVM = [PSCustomObject]@{ Question = "- Download Nvm ?"; Answer = "no" }
   CHOCO = [PSCustomObject]@{ Question = "- Download Chocolatey ?"; Answer = "no" }
   REDIS = [PSCustomObject]@{ Question = "- Download Redis ?"; Answer = "no" }
   TOOLS = [PSCustomObject]@{ Question = "- Download TOOLS (eza, delta, bat, fzf, zoxide, tldr) ?"; Answer = "no" }
   CMDER = [PSCustomObject]@{ Question = "- Download & Configure Cmder ?"; Answer = "no" }
   FONTS = [PSCustomObject]@{ Question = "- Download Nerd Fonts "; Answer = "no" }
   PHP = [PSCustomObject]@{ Question = "- Download PHP versions "; Answer = "no" }
   XDEBUG = [PSCustomObject]@{ Question = "- Download XDebug "; Answer = "no" }
}

foreach ($key in $StepsQuestions.Keys) {
    $q = $StepsQuestions[$key]
    $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "yes"
}
#endregion

$WhatWasDoneMessages = @()
$WhatToDoNext = @()

#region SETUP THE CONTAINER DIRECTORY
$downloadPath = Setup-Container-Directory
Write-Host "`n- Your working directory is $downloadPath :) " -BackgroundColor Green -ForegroundColor Black
$WhatToDoNext = Set-Todo-Message -message "Your container path is '$downloadPath'" -WhatToDoNext $WhatToDoNext

$overrideExistingEnvVars = Prompt-YesOrNoWithDefault -message "`nWould you like to override the existing environment variables"


#region DOWNLOAD NOTEPADD++, LIGHTSHOT, DITTO, WOX
if ($StepsQuestions["APPS"].Answer -eq "yes") {
    . $PWD\steps\install-apps.ps1
}
#endregion

#region DOWNLOAD XAMPP, COMPOSER
if ($StepsQuestions["XAMPP_COMPOSER"].Answer -eq "yes") {
    . $PWD\steps\install-xampp.ps1
}
#endregion

#region DOWNLOAD AND INSTALL CHOCOLATEY
if ($StepsQuestions["CHOCO"].Answer -eq "yes") {
    try {
        Write-Host "`nDownloading and installing Chocolatey..."
        # Set-ExecutionPolicy Bypass -Scope Process -Force
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
        $WhatWasDoneMessages = Set-Success-Message -message "Chocolatey was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Chocolatey failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion

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

#region DOWNLOAD AND SETUP EZA, DELTA, BAT, FZF, ZOXIDE, TLDR
if ($StepsQuestions["TOOLS"].Answer -eq "yes") {
    . $PWD\steps\install-tools.ps1
}
#endregion

#region SETUP CMDER
if ($StepsQuestions["CMDER"].Answer -eq "yes") {
    try {
        $WhatWasDoneMessages = Setup-Cmder -downloadPath $downloadPath -WhatWasDoneMessages $WhatWasDoneMessages -overrideExistingEnvVars $overrideExistingEnvVars
        $WhatToDoNext = Set-Todo-Message -message "Start cmder and Run to check for any updates : > clink update" -WhatToDoNext $WhatToDoNext
        $WhatToDoNext = Set-Todo-Message -message "Start cmder and Run 'flexprompt configure' to customize the prompt style." -WhatToDoNext $WhatToDoNext
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Issue with downloading/installing cmder" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion

#region DOWNLOAD FONTS
if ($StepsQuestions["FONTS"].Answer -eq "yes") {
    . $PWD\steps\install-fonts.ps1
}
#endregion

#region DOWNLOAD MULTIPLE PHP VERSIONS
if ($StepsQuestions["PHP"].Answer -eq "yes") {
    . $PWD\steps\install-php.ps1
}
#endregion

#region DOWNLOAD XDEBUG
if ($StepsQuestions["XDEBUG"].Answer -eq "yes") {
    . $PWD\steps\install-xdebug.ps1
}
#endregion


$WhatToDoNext = Set-Todo-Message -message "Run ./followup.ps1 when you're done for additional cmder configuration" -WhatToDoNext $WhatToDoNext

#region WHAT TO DO NEXT
What-ToDo-Next -WhatWasDoneMessages $WhatWasDoneMessages -WhatToDoNext $WhatToDoNext
#endregion
