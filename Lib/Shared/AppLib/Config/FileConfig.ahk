class FileConfig extends ConfigBase {
    configPathValue := ""

    ConfigPath[] {
        get => this.configPathValue
        set => this.configPathValue := value
    }

    __New(app, configPath := "", extension := ".conf", autoLoad := true) {
        InvalidParameterException.CheckTypes("FileConfig", "configPath", configPath, "", "extension", extension, "")
        this.ConfigPath := configPath != "" ? configPath : app.appDir . "\" . app.appName . extension
        super.__New(app)

        if (autoLoad && this.ConfigPath != "") {
            this.LoadConfig()
        }
    }

    LoadConfig() {
        configPath := this.configPath

        if (configPath == "") {
            throw OperationFailedException.new("Config file path not provided")
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
            throw OperationFailedException.new("Config file path not provided")
        }

        backedUp := false

        if (FileExist(configPath)) {
            if (this.app.Config.AutoBackupConfigFiles) {
                this.BackupConfig()
                backedUp := true
            }

            FileDelete(configPath)
        }

        this.SaveConfigFile(configPath)

        if (!FileExist(configPath) && backedUp) {
            this.RestoreConfig()
        }

        super.SaveConfig()
    }

    SaveConfigFile(configPath) {
        throw MethodNotImplementedException.new("FileConfig", "SaveConfigFile")
    }

    BackupConfig() {
        if (this.ConfigPath && FileExist(this.ConfigPath)) {
            this.BackupConfigFile(this.ConfigPath)
        }
    }

    RestoreConfig(backupNumber := 1) {
        if (this.ConfigPath) {
            success := this.RestoreConfigFile(this.ConfigPath, backupNumber)

            if (success) {
                this.LoadConfig()
            }
        }
    }

    BackupConfigFile(configPath) {
        if (this.ConfigPath && this.app.HasProp("Backups") && this.app.Backups) {
            if (!this.app.Backups.Entities.Has(this.configKey)) {
                backupConfig := Map()
                backupConfig["IsEditable"] := false
                backupConfig["IconSrc"] := A_ScriptDir . "\Resources\Graphics\Config.ico"
                backupConfig["Source"] := this.ConfigPath
                backupConfig["BackupClass"] := "FileBackup"
                this.app.Backups.CreateBackupEntity(this.configKey, backupConfig)
            }

            backup := this.app.Backups.Entities[this.configKey]

            if (backup.Source != this.ConfigPath) {
                backup.Source := this.ConfigPath
                backup.SaveModifiedData()
            }

            this.app.Backups.Entities[this.configKey].CreateBackup()
        }
    }

    RestoreConfigFile(configPath, backupNumber := 1) {
        if (this.ConfigPath && this.app.HasProp(Backups) && this.app.Backups && this.app.Backups.Entities.Has(this.configKey)) {
            this.app.Backups.Entities[this.configKey].RestoreBackup()
            this.LoadConfig()
        }
    }
}
