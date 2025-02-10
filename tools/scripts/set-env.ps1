
# Parameters:
param(
    [string]$variableName,
    [string]$variableValue
)

$variableValueContent = $variableValue -replace "``%", ""
$variableValue = $variableValue -replace "``", ""


# Check if running as administrator
If (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Relaunch as administrator with hidden window
    $arguments = "-ExecutionPolicy Bypass -File `"$PSCommandPath`" -variableName `"$variableName`" -variableValue `"``%$variableValueContent``%`""
    Start-Process powershell -ArgumentList $arguments -Verb RunAs -WindowStyle Hidden
    exit
}


$variableValueContent = [System.Environment]::GetEnvironmentVariable($variableValueContent, [System.EnvironmentVariableTarget]::Machine)
Write-Host $variableValueContent

if ($variableName -and $variableValue) {
    [System.Environment]::SetEnvironmentVariable($variableName, $variableValueContent, [System.EnvironmentVariableTarget]::Machine)
    Write-Host "Environment variable '$variableName' set to '$variableValue' at the system level."
} else {
    Write-Host "Please provide both a variable name and value."
}

