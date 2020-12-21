/**
    This GUI edits a GameLauncher object.

    Modes:
      - "config" - Launcher configuration is being edited
      - "build" - Launcher is being built and requires information
*/

class ManagedEntityEditorBase extends EntityEditorBase {
    allTypes := Map()

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
        tabs := this.guiObj.Add("Tab3", " x" . this.margin . " w" . this.windowSettings["contentWidth"] . " +0x100", ["General", "Sources", "Advanced"])

        tabs.UseTab("General", true)
        ;this.AddEntityTypeSelect(this.entityObj.configPrefix . " Type", this.entityObj.configPrefix . "Type", this.entityObj.EntityType, this.allTypes, "", "You can select from the available entity types if the default doesn't work for your use case.")
        
        tabs.UseTab("Sources", true)
        

        tabs.UseTab("Advanced", true)
        

        tabs.UseTab()
    }
}
