
$ProgressPreference = 'SilentlyContinue'

function Set-Todo-Message {
    param ( [string]$message, [PSCustomObject[]]$WhatToDoNext = @() )
    
    $WhatToDoNext += [PSCustomObject]@{
        Message = "    - $message "
        ForegroundColor = "Black"
        BackgroundColor = "Gray"
    }
    
    return $WhatToDoNext
}

function Set-Success-Message {
    param ( [string]$message, [PSCustomObject[]]$WhatWasDoneMessages = @() )
    
    $WhatWasDoneMessages += [PSCustomObject]@{
        Message = "    - $message :) "
        ForegroundColor = "Black"
        BackgroundColor = "Green"
    }
    
    return $WhatWasDoneMessages
}
function Set-Error-Message {
    param ( [string]$message, $exceptionMessage = $null, [PSCustomObject[]]$WhatWasDoneMessages = @() )

    $WhatWasDoneMessages += [PSCustomObject]@{
        Message = "    - $message :( "
        ForegroundColor = "Black"
        BackgroundColor = "Red"
    }
    if ($exceptionMessage) {
        $WhatWasDoneMessages += [PSCustomObject]@{
            Message = "    --> $exceptionMessage "
            ForegroundColor = "Black"
            BackgroundColor = "Red"
        }
    }

    return $WhatWasDoneMessages
}

function Set-Warning-Message {
    param ( [string]$message, [PSCustomObject[]]$WhatWasDoneMessages = @() )

    $WhatWasDoneMessages += [PSCustomObject]@{
        Message = "    - $message :( "
        ForegroundColor = "Black"
        BackgroundColor = "Yellow"
    }

    return $WhatWasDoneMessages
}

function Setup-Cmder {
    param ( [string]$downloadPath, [PSCustomObject[]]$WhatWasDoneMessages = @(), $overrideExistingEnvVars = "no" )
    #region DOWNLOAD CMDER
    Write-Host "`nDownloading & Extracting Cmder..."
    $cmderUrl = "https://github.com/cmderdev/cmder/releases/download/v1.3.25/cmder.zip"
    # $cmderUrl = "https://github.com/cmderdev/cmder/releases/download/v1.3.20/cmder_mini.zip" # TESTING
    Download-File -url $cmderUrl -output "$downloadPath\Cmder.zip"

    Extract-Zip -zipPath "$downloadPath\Cmder.zip" -extractPath "$downloadPath\Cmder"
    Remove-Item "$downloadPath\Cmder.zip"

    $cmderStuff = @(
        "$downloadPath\Cmder\vendor\git-for-windows\usr\bin",
        "$downloadPath\Cmder\vendor\bin",
        "$downloadPath\Cmder\vendor",
        "$downloadPath\Cmder\bin",
        "$downloadPath\Cmder"
    )
    $cmderStuff = $cmderStuff -join ";"
    Add-Env-Variable -newVariableName "cmder_stuff" -newVariableValue $cmderStuff -updatePath 1 -overrideExistingEnvVars $overrideExistingEnvVars
    #endregion

    #region DOWNLOAD & SETUP FLEXPROMPT
    Write-Host "`nDownloading & Extracting FlexPrompt..."
    # $flexPromptUrl = "https://github.com/AmrEldib/cmder-powerline-prompt/archive/master.zip"
    $flexPromptUrl = "https://github.com/chrisant996/clink-flex-prompt/releases/download/v0.17/clink-flex-prompt-0.17.zip"
    Download-File -url $flexPromptUrl -output "$downloadPath\flexprompt.zip"

    Extract-Zip -zipPath "$downloadPath\flexprompt.zip" -extractPath "$downloadPath\Cmder\config"
    Copy-Item -Path "$PWD\config\flexprompt_autoconfig.lua" -Destination "$downloadPath\Cmder\config"
    Remove-Item "$downloadPath\flexprompt.zip"
    #endregion


    $WhatWasDoneMessages = Set-Success-Message -message "Cmder paths were added to the PATH variable" -WhatWasDoneMessages $WhatWasDoneMessages
    $WhatWasDoneMessages = Set-Success-Message -message "Cmder was successfully setup with (flexprompt)" -WhatWasDoneMessages $WhatWasDoneMessages

    return $WhatWasDoneMessages
}

function Add-Alias-To-Cmder {
    param ( [string]$alias, [string]$downloadPath )
    $aliasFilePath = "$downloadPath\Cmder\config\user_aliases.cmd"
    Add-Content $alias -Path $aliasFilePath
}

function Download-File {
    param ( [string]$url, [string]$output )
    Invoke-WebRequest -Uri $url -OutFile $output
}

function Download-App {
    param( $name, $url, $output )

    try {
        Write-Host "`nDownloading $name..."
        Make-Directory -path "$downloadPath\apps"
        Download-File -url $url -output "$downloadPath\apps\$output"
        $WhatWasDoneMessages = Set-Success-Message -message "$name was downloaded successfully, you need to install it manually" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "$name failed to download, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
    
    return $WhatWasDoneMessages
}
function Make-Directory {
    param ( [string]$path )

    if (-not (Test-Path -Path $path -PathType Container)) {
        mkdir $path | Out-Null
    }
}

function Extract-Zip {
    param ( [string]$zipPath, [string]$extractPath )
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $extractPath)
}

function Prompt-YesOrNoWithDefault {
    param(
        [string]$message = "Do you want to continue ? (yes/no)",
        [ValidateSet("yes", "no")]
        [string]$defaultOption = "no"
    )

    $promptMessage = "$message (Default: $defaultOption)"
    $response = Read-Host $promptMessage

    if ($response -eq "" -or $response -eq $defaultOption) {
        return $defaultOption
    } elseif ($response -eq "yes" -or $response -eq "y") {
        return "yes"
    } elseif ($response -eq "no" -or $response -eq "n") {
        return "no"
    } else {
        Write-Host "Invalid input. Please enter 'yes' or 'no'."
        return Prompt-YesOrNoWithDefault -message $message -defaultOption $defaultOption
    }
}

function Prompt-Quesiton {
    param( [string]$message )

    $promptMessage = "$message "
    $response = Read-Host $promptMessage
    
    return $response
}

function Add-Env-Variable {
    param( [string]$newVariableName, [string]$newVariableValue,
        [boolean]$updatePath = 0, $overrideExistingEnvVars = "no" )
    
    $existingVariableName = [System.Environment]::GetEnvironmentVariable($newVariableName, [System.EnvironmentVariableTarget]::Machine)
    if ($existingVariableName -eq $null -or $overrideExistingEnvVars -eq "yes") {
        [System.Environment]::SetEnvironmentVariable($newVariableName, $newVariableValue, [System.EnvironmentVariableTarget]::Machine)
    }

    if ($updatePath -eq 1) {
        Update-Path-Env-Variable -variableName $newVariableName
    }
}

function Update-Env-Variable {
    param( [string]$variableName, [string]$variableToUpdate, [boolean]$isVarName = 1, [boolean]$remove = 0 )
    $currentPath = [System.Environment]::GetEnvironmentVariable($variableToUpdate, [System.EnvironmentVariableTarget]::Machine)
    if ($remove -eq 1) {
        $pathArray = $currentPath -split ";"
        if ($isVarName -eq 1) {
            $newPathArray = $pathArray | Where-Object { $_ -ne "%$variableName%" }
        } else {
            $newPathArray = $pathArray | Where-Object { $_ -ne "$variableName" }
        }
        $currentPath = ($newPathArray -join ";")
    } else {
        if ($isVarName -eq 1) {
            $currentPath += ";%$variableName%"
        } else {
            $currentPath += ";$variableName"
        }
    }
    [System.Environment]::SetEnvironmentVariable($variableToUpdate, $currentPath, [System.EnvironmentVariableTarget]::Machine)
}

function Update-Path-Env-Variable {
    param( [string]$variableName, [boolean]$isVarName = 1, [boolean]$remove = 0 )
    Update-Env-Variable -variableName $variableName -variableToUpdate "PATH" -isVarName $isVarName -remove $remove
}

function What-ToDo-Next {
    param( [PSCustomObject[]]$WhatWasDoneMessages = @(), [PSCustomObject[]]$WhatToDoNext = @() )

    if ($WhatWasDoneMessages.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "   # Results :"
        foreach ($msg in $WhatWasDoneMessages) {
            $message = $msg.Message
            Write-Host $message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
        }
    }    
    if ($WhatToDoNext.Count -gt 0) {
        Write-Host "`n==========================================================================================`n"
        Write-Host "   # TODOs :"
        foreach ($msg in $WhatToDoNext) {
            $message = $msg.Message
            Write-Host $message -ForegroundColor $msg.ForegroundColor -BackgroundColor $msg.BackgroundColor
        }
    }
    Write-Host "`n==========================================================================================`n"
    Write-Host "`nAll tasks completed.`n`n"
}

function Get-Env {                                                                                
    $envData = @{}                                                                                
    Get-Content $ENV_FILE | Where-Object { $_ -match "(.+)=(.+)" } | ForEach-Object {             
        $key, $value = $_ -split '=', 2                                                           
        $envData[$key.Trim()] = $value.Trim()                                                     
    }                                                                                             
    return $envData                                                                               
}

function Set-Env {
    param ($key, $value)
    # Read the file into an array of lines
    $envLines = Get-Content $ENV_FILE

    # Modify the line with the key
    $envLines = $envLines | ForEach-Object {
        if ($_ -match "^$key=") { "$key=$value" }
        else { $_ }
    }

    # Write the modified lines back to the .env file
    $envLines | Set-Content $ENV_FILE
}