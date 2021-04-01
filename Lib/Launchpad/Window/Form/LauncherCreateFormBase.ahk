class LauncherCreateFormBase extends FormGuiBase {
    knownGames := ""
    knownPlatforms := ""
    dataSource := ""

    __New(app, themeObj, windowKey, title, owner := "", parent := "") {
        this.dataSource := app.DataSources.GetItem()
        super.__New(app, themeObj, windowKey, title, this.GetTextDefinition(), owner, parent, this.GetButtonsDefinition())
    }

    GetTextDefinition() {
        return "Use this form to create a new Launchpad launcher."
    }

    GetButtonsDefinition() {
        return "*&Save|&Cancel"
    }

    Create() {
        super.Create()
        this.knownGames := this.dataSource.ReadListing("game-keys")
        this.knownPlatforms := this.dataSource.ReadListing("platforms")
    }

    ProcessResult(result, submittedData := "") {
        entity := ""

        if (result == "Save") {
            entity := LauncherEntity.new(this.app, this.GetLauncherKey(), this.GetLauncherConfig())
        }

        return entity
    }

    GetLauncherKey() {
        throw MethodNotImplementedException.new("LauncherCreateFormBase", "GetLauncherKey")
    }

    GetLauncherConfig() {
        throw MethodNotImplementedException.new("LauncherCreateFormBase", "GetLauncherConfig")
    }

    AddLocationBlock(heading, field, location, extraButton := "", showOpen := true, helpText := "") {
        this.AddHeading(heading)
        btnWidth := 20
        btnHeight := 20
        ctl := this.AddLocationText(location, field, "xs y+m", this.windowSettings["contentWidth"] - btnWidth - (this.margin/2))

        if (helpText) {
            ctl.ToolTip := helpText
        }
    
        menuItems := []
        menuItems.Push(Map("label", "Change", "name", "Change" . field))

        if (showOpen) {
            menuItems.Push(Map("label", "Open", "name", "Open" . field))
        }

        if (extraButton) {
            menuItems.Push(Map("label", extraButton, "name", StrReplace(extraButton, " ", "") . field))
        }

        btn := this.AddButton("w" . btnWidth . " h" . btnHeight . " x+" (this.margin/2) . " yp", "arrowDown", "OnLocationOptions", "symbol")
        btn.MenuItems := menuItems
        btn.Tooltip := "Change options"
    }

    OnLocationOptions(btn, info) {
        this.app.GuiManager.Menu("MenuGui", btn.MenuItems, this, this.windowKey, "", btn)
    }

    AddLocationText(locationText, ctlName, position := "xs y+m", width := "") {
        if (!width) {
            width := this.windowSettings["contentWidth"]
        }

        ;this.guiObj.SetFont("Bold")
        ctl := this.guiObj.AddText("v" . ctlName . " " . position . " w" . width . " +0x200 c" . this.themeObj.GetColor("linkText"), locationText)
        ;this.guiObj.SetFont()
        return ctl
    }
}
