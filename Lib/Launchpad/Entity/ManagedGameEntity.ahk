class ManagedGameEntity extends ManagedEntityBase {
    configPrefix := "Game"
    defaultType := "Default"
    defaultClass := "SimpleGame"
    dataSourcePath := "Types/Games"

    ; If the game is known to its launcher by a specific ID, it should be stored here.
    LauncherSpecificId {
        get => this.GetConfigValue("LauncherSpecificId", false)
        set => this.SetConfigValue("LauncherSpecificId", value, false)
    }
}
