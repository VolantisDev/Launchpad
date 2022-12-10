class FilesystemTestLoader extends TestLoaderBase {
    baseDir := A_ScriptDir
    testExt := ".test.ahk"
    classAppend := "Test"
    classPrepend := ""
    excludeFilenames := [
        "Includes.ahk",
        "Includes.test.ahk"
    ]

    __New(baseDir := "", testExt := "", classAppend := "", classPrepend := "") {
        if (baseDir) {
            this.baseDir := baseDir
        }

        if (testExt) {
            this.testExt := testExt
        }

        if (classAppend) {
            this.classAppend := classAppend
        }

        if (classPrepend) {
            this.classPrepend := classPrepend
        }
    }

    LoadTests() {
        tests := []
        extLen := StrLen(this.testExt)

        Loop Files, this.baseDir . "\*" . this.testExt, "R" {
            for excludeFilename in this.excludeFilenames {
                if (A_LoopFileName == excludeFilename) {
                    continue 2
                }
            }

            testClass := this.classPrepend . SubStr(A_LoopFileName, 1, -extLen) . this.classAppend

            if (%testClass% ?? false) {
                tests.Push(%testClass%())
            } else {
                ; Error out?
            }
        }

        this.tests := tests
    }
}
