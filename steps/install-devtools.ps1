
$ProgressPreference = 'SilentlyContinue'

#region DOWNLOAD & INSTALL GIT
if ($StepsQuestions["GIT"].Answer -eq "yes") {
    try {
        Write-Host "`nDownloading and installing Git..."
        choco install git.install -y > $null 2>&1
        $WhatWasDoneMessages = Set-Success-Message -message "Git was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages

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

        git config --global alias.alias "! git config --get-regexp ^alias\. | sed -e s/^alias\.// -e s/\ /\ =\ /"
        git config --global alias.log-pretty  "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty2 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%cs) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.log-pretty3 "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cgreen(%ch) %C(bold blue)<%an>%Creset' --abbrev-commit"
        git config --global alias.nah "!f(){ git reset --hard; git clean -df; if [ -d .git/rebase-apply ] || [ -d .git/rebase-merge ]; then git rebase --abort; fi; }; f"
        $WhatWasDoneMessages = Set-Success-Message -message "Git aliases are set" -WhatWasDoneMessages $WhatWasDoneMessages

        $deltaGitConfig =  Get-Content "$PWD\data\delta-git-config.txt" -Raw
        Copy-Item -Path "$PWD\config\themes.gitconfig" -Destination "~/themes.gitconfig"
        Add-Content -Path $gitConfigFile -Value $deltaGitConfig

        $WhatWasDoneMessages = Set-Success-Message -message "Delta was added to ~/.gitconfig successfully" -WhatWasDoneMessages $WhatWasDoneMessages
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

#region DOWNLOAD & INSTALL PVM
if ($StepsQuestions["PVM"].Answer -eq "yes") {
    try {
        Write-Host "`nDownloading and installing PVM..."
        git clone "https://github.com/drissboumlik/pvm" "$downloadPath\env\tools\pvm" > $null 2>&1
        Copy-Item -Path "$downloadPath\env\tools\pvm\.env.example" -Destination "$downloadPath\env\tools\pvm\.env"
        
        Update-Path-Env-Variable -variableName "$downloadPath\env\tools\pvm" -isVarName 0
        
        $WhatWasDoneMessages = Set-Success-Message -message "PVM was installed successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "PVM failed to install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion