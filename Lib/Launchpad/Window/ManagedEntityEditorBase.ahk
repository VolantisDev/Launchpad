/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    __New(app, entityObj, title, mode := "config", windowKey := "", owner := "", parent := "") {
        if (windowKey == "") {
            windowKey := "ManagedEntityEditor"
        }

        if (owner == "") {
            owner := "LauncherEditor"
        }

        super.__New(app, entityObj, title, mode, windowKey, owner, parent)
    }

    Controls() {
        super.Controls()
        prefix := this.entityObj.configPrefix
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)
        this.AddEntityTypeSelect(prefix . " Type", prefix . "Type", this.entityObj.EntityType, this.entityObj.ListEntityTypes(), "", "You can select from the available entity types if the default doesn't work for your use case.")
        
        tabs.UseTab("Sources", true)
        this.AddLocationBlock(prefix . " Executable", prefix . "Exe", "Clear", true, true)
        this.AddHelpText("Select the launcher's main .exe file. The default is to use auto-detection.")

        this.AddLocationBlock(prefix . " Install Directory", prefix . "InstallDir", "Clear", true, true)
        this.AddHelpText("Select the launcher's installation folder, or use default for auto-detection.")

        tabs.UseTab("Advanced", true)
        
        tabs.UseTab()
    }
}
