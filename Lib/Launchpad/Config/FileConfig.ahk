class FileConfig extends ConfigBase {
    configPathValue := ""

    ConfigPath[] {
        get => this.configPathValue
        set => this.configPathValue := value
    }

    __New(app, configPath := "", extension := ".conf", autoLoad := true) {
        InvalidParameterException.CheckTypes("ValidateLaunchersOp", "configPath", configPath, "", "extension", extension, "")
        this.ConfigPath := configPath != "" ? configPath : app.appDir . "\" . app.appName . extension
        super.__New(app)

        if (autoLoad && this.ConfigPath != "") {
            this.LoadConfig()
        }
    }

    LoadConfig() {
        configPath := this.configPath

        if (configPath == "") {
            this.app.Notifications.Error("Config file path not provided.")
            return this
        }

        if (FileExist(configPath)) {
            this.LoadConfigFile(configPath)
        } else {
            this.config := Map()
        }

        return super.LoadConfig()
    }

    LoadConfigFile() {
        throw MethodNotImplementedException.new("FileConfig", "LoadConfigFile")
    }

    SaveConfig() {
        configPath := this.ConfigPath

        if (configPath == "") {
            this.AskForPath()
        }

        if (configPath == "") {
            this.app.Notifications.Error("Config file path not provided.")
            return this
        }

        if (FileExist(configPath)) {
            if (this.app.Config.AutoBackupConfigFiles) {
                this.BackupConfigFile()
            }

            FileDelete(configPath)
        }

        this.SaveConfigFile(configPath)

        if (!FileExist(configPath)) {
            this.RestoreConfigFile()
        }

        super.SaveConfig()
    }

    SaveConfigFile(configPath) {
        throw MethodNotImplementedException.new("FileConfig", "SaveConfigFile")
    }

    BackupConfigFile() {
        if (this.ConfigPath) {
            if (!this.app.Backups.Entities.Has(this.configKey)) {
                backupConfig := Map()
                backupConfig["IsEditable"] := false
                backupConfig["IconSrc"] := A_ScriptDir . "\Resources\Graphics\Config.ico"
                backupConfig["Source"] := this.ConfigPath
                backupConfig["BackupClass"] := "FileBackup"
                this.app.Backups.CreateBackupEntity(this.configKey, backupConfig)
            }

            this.app.Backups.Entities[this.configKey].CreateBackup()
        }
    }

    RestoreConfigFile(backupNumber := 1) {
        if (this.ConfigPath && this.app.Backups.Entities.Has(this.configKey)) {
            this.app.Backups.Entities[this.configKey].RestoreBackup()
            this.LoadConfig()
        }
    }
}
