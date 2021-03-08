class ManagedLauncherEntity extends ManagedEntityBase {
    configPrefix := "Launcher"
    defaultType := "Default"
    defaultClass := "SimpleLauncher"
    dataSourcePath := "launcher-types"

    ManagedGame {
        get => this.children["ManagedGame"]
        set => this.children["ManagedGame"] := value
    }

    ; Indicates whether or not the launcher should be closed (if it is running) before starting the game
    CloseBeforeRun {
        get => this.GetConfigValue("CloseBeforeRun")
        set => this.SetConfigValue("CloseBeforeRun", value)
    }

    ; Indicates whether the launcher should be closed after the game stops
    CloseAfterRun {
        get => this.GetConfigValue("CloseAfterRun")
        set => this.SetConfigValue("CloseAfterRun", value)
    }

    ; How many seconds to wait before closing the launcher
    ClosePreDelay {
        get => this.GetConfigValue("ClosePreDelay")
        set => this.SetConfigValue("ClosePreDelay", value)
    }

    ; How many seconds to wait after closing the launcher
    ClosePostDelay {
        get => this.GetConfigValue("ClosePostDelay")
        set => this.SetConfigValue("ClosePostDelay", value)
    }

    ; How to attempt to close the launcher if running. Can be one of:
    ; - "Prompt" - Show a prompt to the user that they can click Continue to trigger a recheck or Cancel to stop trying to close the launcher.
    ; - "Wait" - Waits up to WaitTimeout seconds for the launcher to close on its own and fails if not
    ; - "Auto" - Make one polite attempt, wait a defined number of seconds, and kill the process if it is still running
    ; - "AutoPolite" - Automatically attempt to politely close the launcher, or fail if it can't be closed politely
    ; - "AutoKill" - Automatically attempts to end the launcher process, forcefully if needed
    CloseMethod {
        get => this.GetConfigValue("CloseMethod")
        set => this.SetConfigValue("CloseMethod", value)
    }

    ; If the CloseMethod requires a loop, this is the delay it will use between checks whether the launcher is running.
    RecheckDelay {
        get => this.GetConfigValue("RecheckDelay")
        set => this.SetConfigValue("RecheckDelay", value)
    }

    ; If CloseMethod is Wait, this is how long the launcher will attempt to wait before giving up
    WaitTimeout {
        get => this.GetConfigValue("WaitTimeout")
        set => this.SetConfigValue("WaitTimeout", value)
    }

    ; If killing a managed launcher forcefully, ending the process will be delayed by this number of seconds.
    KillPreDelay {
        get => this.GetConfigValue("KillPreDelay")
        set => this.SetConfigValue("KillPreDelay", value)
    }

    ; If killing a managed launcher forcefully, the launcher will wait this number of seconds after trying to end the process before reporting success.
    KillPostDelay {
        get => this.GetConfigValue("KillPostDelay")
        set => this.SetConfigValue("KillPostDelay", value)
    }

    PoliteCloseWait {
        get => this.GetConfigValue("PoliteCloseWait")
        set => this.SetConfigValue("PoliteCloseWait", value)
    }

    __New(app, key, config, requiredConfigKeys := "", parentEntity := "") {
        super.__New(app, key, config, requiredConfigKeys, parentEntity)
        this.children["ManagedGame"] := ManagedGameEntity.new(app, key, config, "", this)
    }

    InitializeDefaults() {
        defaults := super.InitializeDefaults()
        defaults[this.configPrefix . "CloseBeforeRun"] := false
        defaults[this.configPrefix . "CloseAfterRun"] := false
        defaults[this.configPrefix . "ClosePreDelay"] := 0
        defaults[this.configPrefix . "ClosePostDelay"] := 0
        defaults[this.configPrefix . "CloseMethod"] := "Prompt"
        defaults[this.configPrefix . "RecheckDelay"] := 10
        defaults[this.configPrefix . "WaitTimeout"] := 30
        defaults[this.configPrefix . "KillPreDelay"] := 10
        defaults[this.configPrefix . "KillPostDelay"] := 5
        defaults[this.configPrefix . "PoliteCloseWait"] := 10
        return defaults
    }

    LaunchEditWindow(mode, owner := "", parent := "") {
        return this.app.Windows.ManagedLauncherEditor(this, mode, owner, parent)
    }
}
