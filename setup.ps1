
. $PWD\functions.ps1

$ProgressPreference = 'SilentlyContinue'

$Global:ENV_FILE = "$PSScriptRoot\.env"      
$Global:USER_ENV = Get-Env

Write-Host "`nThis will setup your env with (Git, Composer, NVM, Chocolatey, Some terminal utilities, Cmder)`n"

#region ANSWER QUESTIONS FOR WHICH STEPS TO EXECUTE
$StepsQuestions = [ordered]@{
   COMPOSER = [PSCustomObject]@{ Question = "- Download Composer ?"; Answer = "no" }
   GIT = [PSCustomObject]@{ Question = "- Download Git ?"; Answer = "no" }
   NVM = [PSCustomObject]@{ Question = "- Download Nvm ?"; Answer = "no" }
   REDIS = [PSCustomObject]@{ Question = "- Download Redis ?"; Answer = "no" }
   TOOLS = [PSCustomObject]@{ Question = "- Download TOOLS (eza, delta, bat, fzf, zoxide, tldr) ?"; Answer = "no" }
   CMDER = [PSCustomObject]@{ Question = "- Download & Configure Cmder ?"; Answer = "no" }
   FONTS = [PSCustomObject]@{ Question = "- Download Nerd Fonts "; Answer = "no" }
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


#region DOWNLOAD COMPOSER
if ($StepsQuestions["COMPOSER"].Answer -eq "yes") {
    . $PWD\steps\install-composer.ps1
}
#endregion


if (($StepsQuestions["GIT"].Answer -eq "yes") -or ($StepsQuestions["REDIS"].Answer -eq "yes") -or ($StepsQuestions["NVM"].Answer -eq "yes")) {
    
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))

    . $PWD\steps\install-git-nvm.ps1

}

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


$WhatToDoNext = Set-Todo-Message -message "Run ./followup.ps1 when you're done for additional cmder configuration" -WhatToDoNext $WhatToDoNext

#region WHAT TO DO NEXT
What-ToDo-Next -WhatWasDoneMessages $WhatWasDoneMessages -WhatToDoNext $WhatToDoNext
#endregion
