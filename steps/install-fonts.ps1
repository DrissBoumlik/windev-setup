#region DOWNLOAD FONTS
if ($StepsQuestions["FONTS"].Answer -eq "yes") {

    try {
        Write-Host "`nDownloading Font..."
        $nfUrls = Get-Content "$PWD\data\fonts.txt" | Where-Object { $_ -ne "" }
        Make-Directory -path "$downloadPath\fonts"
        foreach ($url in $nfUrls) {
            $fileName = Split-Path $url -Leaf
            try { Download-File -url $url -output "$downloadPath\fonts\$fileName" }
            catch { $WhatWasDoneMessages = Set-Error-Message -message "Fonts : Issue with $fileName" -WhatWasDoneMessages $WhatWasDoneMessages }
        }
        $WhatWasDoneMessages = Set-Success-Message -message "Fonts downloaded successfully" -WhatWasDoneMessages $WhatWasDoneMessages
        $WhatToDoNext = Set-Todo-Message -message "Install downloaded font and Add it to cmder settings." -WhatToDoNext $WhatToDoNext
    }
    catch {
        $WhatWasDoneMessages = Set-Error-Message -message "Fonts failed to download" -exceptionMessage $_.InvocationInfo.PositionMessage -WhatWasDoneMessages $WhatWasDoneMessages
    }

}
#endregion