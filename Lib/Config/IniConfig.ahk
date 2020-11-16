class IniConfig extends FileConfig {
    __New(app, configPath := "") {
        base.__New(app, configPath, ".ini", false)
    }

    GetIniValue(key, section := "General") {
        IniRead, value, % this.ConfigPath, %section%, %key%, %A_Space%
        return value
    }

    SetIniValue(key, value, section := "General") {
        IniWrite, %value%, % this.ConfigPath, %section%, %key%
        return value
    }
}
