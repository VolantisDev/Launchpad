class LauncherManager extends Gui {
    windowOptions := "+Resize MinSize330x330"
    windowSize := "w500 h330"
    contentWidth := 510
    label := "LauncherManager"

    __New(app, owner := 0) {
        base.__New(app, app.AppConfig.LauncherFile, owner)
    }

    AddToolbar() {
        ImageList := IL_Create(9)
        IL_Add(ImageList, "shell32.dll", 1)
        IL_Add(ImageList, "shell32.dll", 4)
        IL_Add(ImageList, "shell32.dll", 296)
        IL_Add(ImageList, "shell32.dll", 133)
        IL_Add(ImageList, "shell32.dll", 298)
        IL_Add(ImageList, "shell32.dll", 297)
        IL_Add(ImageList, "shell32.dll", 320)

        Buttons = 
        (LTrim
            New
            Open
            Save
            Save As
            Reload From Disk
            -
            Activate in Launchpad,, DISABLED
            -
            Flush Cache
        )

        return this.CreateToolbar("OnLauncherManagerToolbar", ImageList, Buttons)
    }

    Controls(posY) {
        static
        global hToolbar

        posY := base.Controls(posY)

        margin := this.margin

        sidebarWidth := 85
        lvWidth := this.contentWidth - sidebarWidth - this.margin
        lvHeight := 300

        Gui Add, ListView, hWndhLVItems x%margin% y%posY% w%lvWidth% h%lvHeight% +Report -Multi +LV0x4000 +NoSortHdr, ListView

        sidebarX := lvWidth + this.margin
        buttonX := sidebarX + 10
        buttonWidth := sidebarWidth - (this.margin * 2)

        Gui Add, GroupBox, hWndhGrpLauncher x%sidebarX% y%posY% w%sidebarWidth% h175, Launcher
        posY += 5 + this.margin
        Gui Add, Button, hWndhBtnAdd x%buttonX% y%posY% w%buttonWidth% h25, Add
        posY += 25 + this.margin
        Gui Add, Button, hWndhBtnEdit Disabled x%buttonX% y%posY% w%buttonWidth% h25, Edit
        posY += 25 + this.margin
        Gui Add, Button, hWndhBtnRemove Disabled x%buttonX% y%posY% w%buttonWidth% h25, Remove
        posY += 25 + (this.margin * 2)
        Gui Add, Button, hWndhBtnMoveUp Disabled x%buttonX% y%posY% w%buttonWidth% h25, Move Up
        posY += 25 + this.margin
        Gui Add, Button, hWndhBtnMoveDown Disabled x%buttonX% y%posY% w%buttonWidth% h25, Move Down
        posY += 25 + this.margin + this.margin
        
        Gui Add, GroupBox, hWndhGrpSortAll x%sidebarX% y%posY% w85 h75, Sort All
        posY += 5 + this.margin
        Gui Add, Button, hWndhBtnByName x%buttonX% y%posY% w%buttonWidth% h25, By Name
        posY += 25 + this.margin
        Gui Add, Button, hWndhBtnByType x%buttonX% y%posY% w%buttonWidth% h25, By Type
        posY += 25 + this.margin + this.margin

        Gui Add, Button, hWndhBtnExit x%sidebarX% y%posY% w%sidebarWidth% h30, E&xit
        posY += 30 + this.margin

        return posY

        LauncherManagerSize:
            If (A_EventInfo == 1) {
                Return
            }

            AutoXYWH("wh", hLVItems)
            AutoXYWH("x*", hGrpLauncher)
            AutoXYWH("x*", hBtnAdd)
            AutoXYWH("x*", hBtnEdit)
            AutoXYWH("x*", hBtnRemove)
            AutoXYWH("x*", hBtnMoveUp)
            AutoXYWH("x*", hBtnMoveDown)
            AutoXYWH("x*", hGrpSortAll)
            AutoXYWH("x*", hBtnByName)
            AutoXYWH("x*", hBtnByType)
            AutoXYWH("xy*", hBtnExit)

            GuiControl Move, %hToolbar%, w%A_GuiWidth%
            Return

        LauncherManagerEscape:
        LauncherManagerClose:
        {
            Gui LauncherManager:Cancel
            Return
        }

        ; ReloadLauncherFile:
        ; {
        ;     app.ReloadLauncherFile()
        ;     Return
        ; }

        ; ChangeLauncherFile:
        ; {
        ;     app.ChangeLauncherFile()
        ;     GuiControl, Launchpad:Text, TxtLauncherFile, % app.AppConfig.LauncherFile
        ;     Return
        ; }

        ; FlushCache:
        ; {
        ;     app.FlushCache()
        ;     Return
        ; }
    }
}

OnLauncherManagerToolbar(hWnd, Event, Text, Pos, Id) {
    If (Event != "Click") {
        Return
    }

    If (Text == "New") {

    } Else If (Text == "Open") {

    } Else If (Text == "Save") {

    } Else If (Text == "Save As") {

    } Else If (Text == "Reload From Disk") {

    } Else If (Text == "Activate in Launchpad") {

    } Else If (Text == "Flush Cache") {

    }
}
