class LaunchpadIniMigrator {
    app := ""
    guiMgr := ""

    __New(app, guiMgr) {
        this.app := app
        this.guiMgr := guiMgr
    }

    Migrate(previousFile, configObj) {
        section := IniRead(previousFile, "General")
        lines := StrSplit(section, "`n", " `t")

        imported := Map()

        for index, line in lines {
            pair := StrSplit(line, "=", " `t")

            if (pair.Length == 2 && pair[1] && pair[2]) {
                value := pair[2]
                key := ""

                for index, char in StrSplit(pair[1]) {
                    if (index != 1 && IsUpper(char)) {
                        key .= "_"
                    }

                    key .= StrLower(char)
                }

                if (configObj.Has(key)) {
                    configObj[key] := value
                    imported[key] := value
                }
            }
        }

        message := ""

        if (imported.Count) {
            configObj.SetValues(imported)
            configObj.SaveConfig()

            debuggerObj := Debugger()
            message := "Your previous configuration has been migrated!`n`nThe following " . imported.Count . " values were imported:"

            for key, value in imported {
                message .= "`n" . key . " = " . debuggerObj.ToString(value)
            }

            message .= "`n`nLaunchpad must restart now to reload the configuration."
        } else {
            message := "No importable configuration values were found."
        }

        FileDelete(previousFile)
        this.guiMgr.Dialog(Map(
            "title", "Migration Complete",
            "text", message,
            "buttons", "*&OK"
        ))
        this.app.RestartApp()
    }
}
