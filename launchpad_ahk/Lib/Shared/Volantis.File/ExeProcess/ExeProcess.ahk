class ExeProcess {
    exeName := ""
    pid := ""
    static wmi := ComObjGet("winmgmts:")

    __New(exeName) {
        this.exeName := exeName
    }

    GetCimDateTime(dateTimeVal) {
        return FormatTime(dateTimeVal, "yyyyMMddHHmmss") . ".000000+000"
    }

    LookupPid(exeName := "", afterDate := "", timeout := 30) {
        if (exeName == "") {
            exeName := this.exeName
        }

        pid := ""
        startTime := A_Now

        Loop {
            if (DateDiff(A_Now, startTime, "Seconds") >= timeout) {
                break
            }

            scriptPid := ProcessExist()

            query := "SELECT ProcessId, CreationDate FROM Win32_Process WHERE Name LIKE '" . this.exeName . "' AND ProcessId != " . scriptPid

            if (afterDate) {
                query .= " AND CreationDate > '" . this.GetCimDateTime(afterDate) . "'"
            }

            for result in this.SearchForProcesses(query) {
                pid := result.ProcessId
                break
            }

            if (pid) {
                break
            }

            Sleep(100)
        }

        this.pid := pid
        return pid
    }

    ReplaceProcess(after := "", timeout := 30) {
        pid := this.LookupPid("", after, timeout)

        if (pid) {
            startInfo := this.GetStartInfo(pid, timeout)
            this.KillProcessWithChildren(pid)
            pid := this.Start(startInfo)
            this.pid := pid
        }

        return pid
    }

    GetStartInfo(pid := "", timeout := 30) {
        startTime := A_Now

        if (pid == "") {
            pid := this.pid
        }

        if (!ProcessExist(pid)) {
            ProcessWait(pid, timeout)
        }

        startInfo := {}

        done := false
        
        Loop {
            for result in this.SearchForProcesses("SELECT CommandLine, ExecutablePath FROM Win32_Process WHERE ProcessId = " . pid) {
                startInfo.FileName := result.ExecutablePath
                SplitPath(result.ExecutablePath,, &workingDir)
                startInfo.WorkingDirectory := workingDir
                removeChars := StrLen(startInfo.FileName)
                startInfo.CommandLine := result.CommandLine

                if (SubStr(result.CommandLine, 1, 1) == "`"") {
                    removeChars += 2
                }

                startInfo.Arguments := SubStr(result.CommandLine, removeChars + 1)
                done := true
                break
            }

            Sleep(100)

            if (done || DateDiff(A_Now, startTime, "Seconds") >= timeout) {
                break
            }
        }

        if (!done) {
            throw OperationFailedException("Could not get process start info.")
        }

        return startInfo
    }

    KillProcessWithChildren(pid := "") {
        if (pid == "") {
            pid := this.pid
        }

        results := this.SearchForProcesses("SELECT * FROM Win32_Process WHERE ParentProcessId = " . pid)

        for result in results {
            this.KillProcessWithChildren(result.ProcessID)
        }

        if (ProcessExist(pid)) {
            ProcessClose(pid)
        }
    }

    Start(startInfo) {
        Run(startInfo.CommandLine, startInfo.WorkingDirectory,, &pid)
        return this.pid
    }

    ; Returns a ManagementObjectCollection COM object wrapper
    SearchForProcesses(query) {
        return ExeProcess.wmi.ExecQuery(query)
    }
}
