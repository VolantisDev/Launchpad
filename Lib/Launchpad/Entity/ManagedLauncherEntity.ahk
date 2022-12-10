class ManagedLauncherEntity extends ManagedEntityBase {
    configPrefix := "Launcher"
    defaultType := "Default"
    defaultClass := "SimpleLauncher"
    dataSourcePath := "launcher-types"

    BaseFieldDefinitions() {
        definitions := super.BaseFieldDefinitions()

        definitions["ManagedGame"] := Map(
            "type", "entity_reference",
            "required", true,
            "entityType", "managed_game",
            "child", false,
            "formField", false,
            "editable", false
        )

        definitions["CloseBeforeRun"] := Map(
            "type", "boolean",
            "storageKey", this.configPrefix . "CloseBeforeRun",
            "default", false,
            "description", "whether or not the launcher should be closed (if it is running) before starting the game"
        )

        definitions["CloseAfterRun"] := Map(
            "type", "boolean",
            "storageKey", this.configPrefix . "CloseAfterRun",
            "default", false,
            "description", "Indicates whether the launcher should be closed after the game stops"
        )

        definitions["ClosePreDelay"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "min", 0,
            "storageKey", this.configPrefix . "ClosePreDelay",
            "default", 0,
            "required", true,
            "group", "advanced",
            "description", "How many seconds to wait before closing the launcher",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["ClosePostDelay"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "min", 0,
            "storageKey", this.configPrefix . "ClosePostDelay",
            "default", 0,
            "required", true,
            "group", "advanced",
            "description", "How many seconds to wait after closing the launcher",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        ; How to attempt to close the launcher if running. Can be one of:
        ; - "Prompt" - Show a prompt to the user that they can click Continue to trigger a recheck or Cancel to stop trying to close the launcher.
        ; - "Wait" - Waits up to WaitTimeout seconds for the launcher to close on its own and fails if not
        ; - "Auto" - Make one polite attempt, wait a defined number of seconds, and kill the process if it is still running
        ; - "AutoPolite" - Automatically attempt to politely close the launcher, or fail if it can't be closed politely
        ; - "AutoKill" - Automatically attempts to end the launcher process, forcefully if needed
        definitions["CloseMethod"] := Map(
            "storageKey", this.configPrefix . "CloseMethod",
            "default", "Prompt",
            "description", "How to attempt to close the launcher if running",
            "widget", "select",
            "required", true,
            "selectOptionsCallback", ObjBindMethod(this, "ListCloseMethods")
        )

        definitions["RecheckDelay"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "min", 0,
            "storageKey", this.configPrefix . "RecheckDelay",
            "default", 10,
            "required", true,
            "group", "advanced",
            "description", "The amount of time to wait between checks if the launcher is running, if applicable.",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["WaitTimeout"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "min", 0,
            "storageKey", this.configPrefix . "WaitTimeout",
            "default", 30,
            "required", true,
            "group", "advanced",
            "description", "Set how long the launcher will attempt to wait before giving up.",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["KillPreDelay"] := Map(
            "type", "time_offset",
            "timeUnits", "ms",
            "min", 0,
            "storageKey", this.configPrefix . "KillPreDelay",
            "default", 10,
            "required", true,
            "group", "advanced",
            "description", "If killing a managed launcher forcefully, ending the process will be delayed by this number of seconds.",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["KillPostDelay"] := Map(
            "type", "time_offset",
            "timeUnits", "ms",
            "min", 0,
            "storageKey", this.configPrefix . "KillPostDelay",
            "default", 5,
            "required", true,
            "group", "advanced",
            "description", "If killing a managed launcher forcefully, the launcher will wait this number of seconds after trying to end the process before reporting success.",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        definitions["PoliteCloseWait"] := Map(
            "type", "time_offset",
            "timeUnits", "s",
            "min", 0,
            "storageKey", this.configPrefix . "PoliteCloseWait",
            "required", true,
            "default", 10,
            "group", "advanced",
            "description", "How many seconds to give the launcher to close after asking politely before forcefully killing it (if applicable).",
            "modes", Map(
                "simple", Map("formField", false)
            )
        )

        return definitions
    }

    ListCloseMethods() {
        return [
            "Prompt",
            "Wait",
            "Auto",
            "AutoPolite",
            "AutoKill"
        ]
    }
}
