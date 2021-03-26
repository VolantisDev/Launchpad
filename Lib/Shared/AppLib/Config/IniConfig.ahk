class IniConfig extends FileConfig {
    __New(app, configPath := "") {
        super.__New(app, configPath, ".ini", false)
    }

    GetIniValue(key, section := "General") {
        return IniRead(this.ConfigPath, section, key, A_Space)
    }

    SetIniValue(key, value, section := "General") {
        if (this.app.Config.AutoBackupConfigFiles) {
            this.BackupConfig()
        }

        IniWrite(value, this.ConfigPath, section, key)
        return value
    }

    GetBooleanValue(key, defaultValue) {
        returnVal := this.GetIniValue(key)

        if (returnVal == "") {
            returnVal := !!(defaultValue)
        }

        return returnVal
    }

    SetBooleanValue(key, booleanValue) {
        this.SetIniValue(key, !!(booleanValue))
    }
}
