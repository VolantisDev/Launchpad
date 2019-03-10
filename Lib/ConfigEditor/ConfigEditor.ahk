class ConfigEditor {
    app := {}
    guiName := ""
    guiTitle := ""
    toolbar := {}

    __New(app, guiName, guiTitle) {
        this.app := app
        this.guiName := guiName
        this.guiTitle := guiTitle
    }

    GetToolbarButtons() {

    }

    GetMainViewElements() {

    }

    ShowGui() {
        Gui, % this.guiName . ":New",, % this.guiTitle
        Gui, Add, Custom, ClassToolbarWindow32 hwndhToolbar 0x0800 0x0100
        Gui, Show
        ShowToolbar()
    }

    ShowToolbar() {
        toolbarButtons := GetToolbarButtons()
        ILA := GetToolbarImageList(toolbarButtons)

        this.toolbar := New Toolbar(hToolbar)
        this.toolbar.SetImageList(ILA)
        this.toolbar.Add("")

        For key, toolbarButton in toolbarButtons
        {
            this.toolbar.Add()
        }
    }

    GetToolbarImageList(toolbarButtons) {
        ILA := IL_Create(buttons.Count(), 2, True)

        For key, toolbarButton in toolbarButtons
        {
            IL_Add(ILA, toolbarButton.iconFile, toolbarButton.iconNumber)
        }

        return ILA
    }
}
