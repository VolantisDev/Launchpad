#Warn

appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

GenerateIncludeFile(file, glob) {
    if (FileExist(file)) {
        FileDelete(file)
    }
    
    FileAppend("; Automatically-generated file, do not edit manually.`n", file)

    Loop Files glob, "R"
    {
        if (A_LoopFileFullPath != file) {
            FileAppend("#Include " . A_LoopFileFullPath . "`n", file)
        }
    }

    FileAppend("; End of auto-generated includes.`n", file)
}

GenerateIncludeFile(appDir . "\Lib\Includes.ahk", appDir . "\Lib\*.ahk")
GenerateIncludeFile(appDir . "\LauncherLib\Includes.ahk", appDir . "\LauncherLib\*.ahk")
