#Warn

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

GenerateIncludeFile(libDir) {
    global appDir

    filePath := libDir . "\Includes.ahk"
    testsPath := libDir . "\Includes.test.ahk"

    if (FileExist(filePath)) {
        FileDelete(filePath)
    }

    if (FileExist(testsPath)) {
        FileDelete(testsPath)
    }
    
    FileAppend("; Automatically-generated file, do not edit manually.`n", filePath)
    FileAppend("; Automatically-generated testing file, do not edit manually.`n", testsPath)

    Loop Files libDir . "\*.ahk", "R"
    {
        if (A_LoopFileFullPath != filePath && A_LoopFileFullPath != testsPath) {
            appendTo := (StrLower(SubStr(A_LoopFileName, -9)) == ".test.ahk") ? testsPath : filePath
            FileAppend("#Include " . StrReplace(A_LoopFileFullPath, libDir . "\", "") . "`n", appendTo)
        }
    }

    FileAppend("; End of auto-generated includes.`n", filePath)
    FileAppend("; End of auto-generated test includes.`n", testsPath)
}

Loop Files appDir . "\Lib\*", "D" {
    GenerateIncludeFile(A_LoopFileFullPath)
}
