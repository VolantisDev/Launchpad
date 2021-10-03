#Warn
#Include ..\Lib\Shared\BaseLib\Exception\ExceptionBase.ahk
#Include ..\Lib\Shared\AppLib\Exception\AppException.ahk
#Include ..\Lib\Shared\UtilityLib\IncludeBuilder\AhkIncludeBuilder.ahk
#Include ..\Lib\Shared\UtilityLib\IncludeBuilder\IncludeBuilderBase.ahk
#Include ..\Lib\Shared\UtilityLib\IncludeWriter\AhkIncludeWriter.ahk
#Include ..\Lib\Shared\UtilityLib\IncludeWriter\IncludeWriterBase.ahk

appVersion := "{{VERSION}}"
appDir := RegExReplace(A_ScriptDir, "\\[^\\]+$")

GenerateIncludeFile(libDir) {
    global appDir

    

    filePath := libDir . "\Includes.ahk"
    testsPath := libDir . "\Includes.test.ahk"

    includeBuilder := AhkIncludeBuilder(libDir, "", true, true, [".test.ahk", filePath])
    includeWriter := AhkIncludeWriter(filePath)
    updated := includeWriter.WriteIncludes(includeBuilder.BuildIncludes())

    testBuilder := AhkIncludeBuilder(libDir, "*.test.ahk", true, true, [testsPath])
    testWriter := AhkIncludeWriter(testsPath)
    testsUpdated := testWriter.WriteIncludes(testBuilder.BuildIncludes())

    if (testsUpdated && !updated) {
        updated := true
    }

    return updated
}

libsUpdated := false

Loop Files appDir . "\Lib\*", "D" {
    libUpdated := GenerateIncludeFile(A_LoopFileFullPath)

    if (libUpdated && !libsUpdated) {
        libsUpdated := true
    }
}

if (libsUpdated) {
    MsgBox("Libraries have changed. Please restart or rebuild the application.")
}
