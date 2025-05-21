#region DOWNLOAD AND SETUP EZA, DELTA, BAT, FZF, ZOXIDE, TLDR
if ($StepsQuestions["TOOLS"].Answer -eq "yes") {

    try {
        Make-Directory -path "$downloadPath\env\tools"
        $tools = @()
        #region DOWNLOAD & SETUP EZA
        Write-Host "`nInstalling EZA (better ls)..."
        $ezaUrl = "https://github.com/eza-community/eza/releases/download/v0.18.21/eza.exe_x86_64-pc-windows-gnu.zip"
        Download-File -url $ezaUrl -output "$downloadPath\eza.zip"
        Extract-Zip -zipPath "$downloadPath\eza.zip" -extractPath "$downloadPath\env\tools\eza"
        $tools += "$downloadPath\env\tools\eza"
        Remove-Item "$downloadPath\eza.zip"
        #endregion

        #region DOWNLOAD & SETUP DELTA
        Write-Host "`nInstalling DELTA (better git diff)..."
        choco install delta -y > $null 2>&1
        #endregion

        #region DOWNLOAD & SETUP BAT
        Write-Host "`nInstalling BAT (better cat)..."
        choco install bat -y > $null 2>&1
        #endregion

        #region DOWNLOAD & SETUP FZF
        Write-Host "`nInstalling FZF (Fuzzy finder)..."
        choco install fzf -y > $null 2>&1
        #endregion
        
        #region DOWNLOAD & SETUP Z / ZOXIDE
        Write-Host "`nInstalling ZOXIDE/Z (better cd)..."
        choco install zoxide -y > $null 2>&1
        #endregion

        #region DOWNLOAD & SETUP TLDR
        Write-Host "`nInstalling TLDR (simplified man pages)..."
        choco install tldr -y > $null 2>&1
        #endregion

        $tools = $tools -join ";"
        Update-Path-Env-Variable -variableName $tool -isVarName 0

        $WhatWasDoneMessages = Set-Success-Message -message "Tools (eza, delta, bat, fzf, zoxide, tldr) downloaded/installed & configured successfully" -WhatWasDoneMessages $WhatWasDoneMessages
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "One of the tools (eza, delta, bat, fzf, zoxide) failed to download/install, try again" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }
}
#endregion