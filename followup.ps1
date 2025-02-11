
. ./functions.ps1

$ProgressPreference = 'SilentlyContinue'

$Global:ENV_FILE = "$PWD\.env"
$Global:USER_ENV = Get-Env

#region ANSWER QUESTIONS FOR WHICH STEPS TO EXECUTE
$StepsQuestions = [ordered]@{
    GIT = [PSCustomObject]@{ Question = "- Did you already install git ? "; Answer = "no" }
    CMDER = [PSCustomObject]@{ Question = "- Did you already start cmder ? "; Answer = "no" }
    COMPOSER = [PSCustomObject]@{ Question = "- Did you already install Composer ? "; Answer = "no" }
}
 
foreach ($key in $StepsQuestions.Keys) {
     $q = $StepsQuestions[$key]
     $q.Answer = Prompt-YesOrNoWithDefault -message $q.Question -defaultOption "no"
}
#endregion

$downloadPath = $USER_ENV["USER_ENV_PATH"]

$WhatWasDoneMessages = @()
#region ADD DELTA TO GIT CONFIG
if ($StepsQuestions["GIT"].Answer -eq "yes") {
    $gitConfigFile = "~/.gitconfig"
    if (-not (Test-Path $gitConfigFile)) {
        New-Item -Path $gitConfigFile -ItemType "File"
    }

    $backupFile = "~/.gitconfig.bak"
    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination $gitConfigFile
    } else {
        Copy-Item -Path $gitConfigFile -Destination $backupFile
    }

    try {
        git config --global alias.alias "! git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /"
        git config --global alias.log-pretty  "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty2 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%cs) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty3 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%ch) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.nah "!f(){ git reset --hard; git clean -df; if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then git rebase --abort; fi; }; f"
        $WhatWasDoneMessages = Set-Success-Message -message "Git aliases are set" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Warning-Message -message "Make sure you installed Git first !" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    
    try {
        $deltaGitConfig =  Get-Content "$PWD\data\delta-git-config.txt" -Raw
        Copy-Item -Path "$PWD\config\themes.gitconfig" -Destination "~/themes.gitconfig"
        Add-Content -Path $gitConfigFile -Value $deltaGitConfig

        $WhatWasDoneMessages = Set-Success-Message -message "Delta was added to ~/.gitconfig successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Warning-Message -message "Issue with ~/.gitconfig !" -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion

#region COPY CMDER CONFIG & ALIASES
if ($StepsQuestions["CMDER"].Answer -eq "yes") {

    $backupFile = "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml.bak"
    if (-not (Test-Path $backupFile)) {
        Copy-Item -Path "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml" -Destination $backupFile
    }
    Copy-Item -Path "$PWD\config\ConEmu.xml" -Destination "$downloadPath\Cmder\vendor\conemu-maximus5\ConEmu.xml"
    
    Copy-Item -Path "$PWD\config\zoxide.lua" -Destination "$downloadPath\Cmder\config\zoxide.lua"
    
    $backupFile = "$downloadPath\Cmder\config\user_aliases.cmd.bak"
    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_aliases.cmd"
    } else {
        Copy-Item -Path "$downloadPath\Cmder\config\user_aliases.cmd" -Destination $backupFile
    }
    Get-Content -Path "$PWD\config\user_aliases.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_aliases.cmd"

    $backupFile = "$downloadPath\Cmder\config\user_profile.cmd.bak"
    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination "$downloadPath\Cmder\config\user_profile.cmd"
    } else {
        Copy-Item -Path "$downloadPath\Cmder\config\user_profile.cmd" -Destination $backupFile
    }
    Get-Content -Path "$PWD\config\user_profile.cmd" | Add-Content -Path "$downloadPath\Cmder\config\user_profile.cmd"

    Make-Directory "$downloadPath\env\tools"
    Make-Directory "$downloadPath\env\tools\scripts"
    Copy-Item -Path "$PWD\tools\scripts\set-env.ps1" -Destination "$downloadPath\env\tools\scripts\set-env.ps1"
    Add-Alias-To-Cmder -downloadPath $downloadPath -alias "setvar=powershell -ExecutionPolicy Bypass -File ""$downloadPath\env\tools\scripts\set-env.ps1"" -variableName ""`$1"" -variableValue ""``%`$2``%"" && RefreshEnv.cmd $*"

    $WhatWasDoneMessages = Set-Success-Message -message "ConEmu.xml & user_aliases.cmd were added to Cmder successfully" -WhatWasDoneMessages $WhatWasDoneMessages
}
#endregion

#region ADD PHP ENVIRONMENT VARIABLE TO THE PATH
if ($StepsQuestions["COMPOSER"].Answer -eq "yes") {

    # Copy composer version 1 to the composer path
    Copy-Item -Path "$PWD\tools\composer-v1" -Destination "C:\composer\v1" -Recurse
    Update-Path-Env-Variable -variableName "C:\composer\v1" -isVarName 0
    
    $WhatWasDoneMessages = Set-Success-Message -message "composer1 was successfully added to the PATH" -WhatWasDoneMessages $WhatWasDoneMessages
}
#endregion

What-ToDo-Next -WhatWasDoneMessages $WhatWasDoneMessages
