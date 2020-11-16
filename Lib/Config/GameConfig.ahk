; @todo Decide if I still need this
class GameConfig extends ConfigBase {
    keyValue := ""
    nameValue := ""
    gameClassValue := ""
    launcherClassValue := ""
    optionsValue := {}

    Key[] {
        get {
            return this.keyValue
        }
        set {
            return this.keyValue := value
        }
    }

    Name[] {
        get {
            return this.nameValue
        }
        set {
            return this.nameValue := value
        }
    }

    GameClass[] {
        get {
            return this.gameClassValue
        }
        set {
            return this.gameClassValue := value
        }
    }

    LauncherClass[] {
        get {
            return this.launcherClassValue
        }
        set {
            return this.launcherClassValue := value
        }
    }

    Options[] {
        get {
            return this.optionsValue
        }
        set {
            return this.optionsValue := value
        }
    }
}
