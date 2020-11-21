class IniConfig extends FileConfig {
    __New(app, configPath := "") {
        super.__New(app, configPath, ".ini", false)
    }

    GetIniValue(key, section := "General") {
        return IniRead(this.ConfigPath, section, key, A_Space)
    }

    SetIniValue(key, value, section := "General") {
        IniWrite(value, this.ConfigPath, section, key)
        return value
    }
}
