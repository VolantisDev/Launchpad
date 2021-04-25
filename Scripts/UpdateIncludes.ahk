#Warn

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

GenerateIncludeFile(libDir) {
    global appDir

    filePath := libDir . "\Includes.ahk"

    if (FileExist(filePath)) {
        FileDelete(filePath)
    }
    
    FileAppend("; Automatically-generated file, do not edit manually.`n", filePath)

    Loop Files libDir . "\*.ahk", "R"
    {
        if (A_LoopFileFullPath != filePath) {
            FileAppend("#Include " . StrReplace(A_LoopFileFullPath, libDir . "\", "") . "`n", filePath)
        }
    }

    FileAppend("; End of auto-generated includes.`n", filePath)
}

Loop Files appDir . "\Lib\*", "D" {
    GenerateIncludeFile(A_LoopFileFullPath)
}
