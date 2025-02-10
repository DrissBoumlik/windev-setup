$url = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.8/npp.8.6.8.Installer.x64.exe"
$WhatWasDoneMessages = Download-App -name "Notepad++" -url $url -output "npp.8.6.8.Installer.x64.exe"

$url = "https://app.prntscr.com/build/setup-lightshot.exe"
$WhatWasDoneMessages = Download-App -name "Lightshot" -url $url -output "setup-lightshot.exe"

$url = "https://github.com/sabrogden/Ditto/releases/download/3.24.246.0/DittoSetup_64bit_3_24_246_0.exe"
$WhatWasDoneMessages = Download-App -name "Ditto clipboard" -url $url -output "DittoSetup_64bit_3_24_246_0.exe"

$url = "https://github.com/Wox-launcher/Wox/releases/download/v1.4.1196/Wox-Full-Installer.1.4.1196.exe"
$WhatWasDoneMessages = Download-App -name "Wox launcher" -url $url -output "Wox-Full-Installer.1.4.1196.exe"

$WhatToDoNext = Set-Todo-Message -message "After installing WOX, Copy theme files tools\wox to '%USERPROFILE%\AppData\Local\Wox\[APP_WERSION]\Themes'" -WhatToDoNext $WhatToDoNext