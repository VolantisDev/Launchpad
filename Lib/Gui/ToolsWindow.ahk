#Include GuiBase.ahk

class ToolsWindow extends GuiBase {
    windowOptions := "+AlwaysOnTop -Caption Border"
    windowSize := "w220"
    contentWidth := 200
    positionAtMouseCursor := true

    __New(app, owner := "") {
        super.__New(app, "Tools", owner)
    }

    Controls(posY) {
        posY := super.Controls(posY)
        controlWidth := this.contentWidth

        btn := this.guiObj.AddButton("x" . this.margin . " y" . posY . " w" . controlWidth . " h40", "&Reload Launcher File")
        btn.OnEvent("Click", "OnReloadLauncherFile")
        posY += 40 + this.margin

        btn := this.guiObj.AddButton("x" . this.margin . " y" . posY . " w" . controlWidth . " h40", "&Clean Launchers")
        btn.OnEvent("Click", "OnCleanLaunchers")
        posY += 40 + this.margin

        btn := this.guiObj.AddButton("x" . this.margin . " y" . posY . " w" . controlWidth . " h40", "&Update Dependencies")
        btn.OnEvent("Click", "OnUpdateDependencies")
        posY += 40 + this.margin

        btn := this.guiObj.AddButton("x" . this.margin . " y" . posY . " w" . controlWidth . " h40", "&Flush Cache")
        btn.OnEvent("Click", "OnFlushCache")
        posY += 40 + this.margin

        return posY
    }

    OnReloadLauncherFile(btn, info) {
        this.Close()
        this.app.ReloadLauncherFile()
    }

    OnCleanLaunchers(btn, info) {
        this.Close()
        this.app.Cleanup()
    }

    OnFlushCache(btn, info) {
        this.Close()
        this.app.FlushCache()
    }

    OnUpdateDependencies(btn, info) {
        this.Close()
        this.app.UpdateDependencies(true)
    }

    OnClose(guiObj) {
        this.Close()
        super.OnClose(guiObj)
    }

    OnEscape(guiObj) {
        this.Close()
        super.OnEscape(guiObj)
    }
}
