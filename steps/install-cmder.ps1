
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