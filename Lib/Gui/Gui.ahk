class Gui {
    app := {}
    title := ""
    owner := 0
    label := "GuiWindow"
    windowOptions := ""
    windowSize := ""
    margin := 10
    contentWidth := 320
    hToolbar := ""
    positionAtMouseCursor := false

    __New(app, title, owner := 0) {
        this.app := app
        this.title := title
        this.owner := owner
    }

    GetTitle() {
        return this.title . " - Launchpad"
    }

    Show() {
        global hToolbar
        this.Create()

        this.hToolbar := this.AddToolbar()
        hToolbar := this.hToolbar
        posY := hToolbar ? 20 + this.margin : this.margin

        posY := this.Start(posY)
        posY := this.Controls(posY)
        this.AddButtons(posY)
        return this.End()
    }

    Create() {
        options := this.windowOptions
        guiLabel := this.label
        margin := this.margin

        Gui %guiLabel%:New, %options% +Label%guiLabel%, % this.GetTitle()
        Gui %guiLabel%:Color, ffffff
        Gui %guiLabel%:Margin, %margin%, %margin%
    }

    AddToolbar() {
        ; Define a callback and call CreateToolbar from this function if needed
        return false
    }

    CreateToolbar(callback, imageList, buttons) {
        return ToolbarCreate(callback, buttons, imageList, "Flat List Tooltips")
    }

    Start(posY) {
        options := this.windowOptions
        guiLabel := this.label

        if (this.owner <> 0 ) {
            owner := this.owner
            Gui %owner%:+Disabled
            Gui %guiLabel%:+Owner%owner%
	    }

        return posY
    }

    Controls(posY) {
        return posY
    }

    AddButtons(posY) {

    }

    End() {
        guiLabel := this.label

        windowSize := this.windowSize

        if (this.positionAtMouseCursor) {
            width := this.contentWidth + (this.margin * 2)

            CoordMode, Mouse, Screen
            MouseGetPos, windowX, windowY
            CoordMode, Mouse, Window

            windowX -= width/2

            windowSize .= " x" . windowX . " y" . windowY
        }

        Gui %guiLabel%:Show, %windowSize%

        return true
    }

    Close(cancel := false) {
        owner := this.owner
        guiLabel := this.label

        if (owner <> 0) {
            Gui %owner%:-Disabled
        }

        if (cancel) {
            Gui, SettingsWindow:Cancel
        } else {
            Gui, %guiLabel%:Submit, Hide
        }
    }

    Destroy() {
        guiLabel := this.label

        this.Cleanup()

        Gui %guiLabel%:Destroy
    }

    Cleanup() {
        ; Extend to clear any global variables used
    }

    ButtonWidth(numberOfButtons, availableWidth := 0) {
        if (availableWidth == 0) {
            availableWidth := this.contentWidth
        }

        marginWidth := (numberOfButtons <= 1) ? 0 : (this.margin * (numberOfButtons - 1))
        return (availableWidth - marginWidth) / numberOfButtons
    }
}
