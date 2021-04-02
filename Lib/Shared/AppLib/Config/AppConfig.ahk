class AppConfig extends IniConfig {
    ThemeName {
        get => this.GetIniValue("ThemeName") || "Steampad"
        set => this.SetIniValue("ThemeName", value)
    }

    CacheDir {
        get => this.GetIniValue("CacheDir") || this.app.tmpDir . "\Cache"
        set => this.SetIniValue("CacheDir", value)
    }

    FlushCacheOnExit {
        get => this.GetBooleanValue("FlushCacheOnExit", false)
        set => this.SetBooleanValue("FlushCacheOnExit", value)
    }

    LoggingLevel {
        get => this.GetIniValue("LoggingLevel") || "Warning"
        set => this.SetIniValue("LoggingLevel", value)
    }
}
