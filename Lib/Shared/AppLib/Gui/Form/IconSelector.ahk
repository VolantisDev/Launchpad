class IconSelector extends DialogBox {
    iconSrc := ""
    iconItem := ""
    listPath := ""

    __New(app, themeObj, windowKey, title, iconSrc := "", iconItem := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("IconSelector", "iconSrc", iconSrc, "")
        this.iconSrc := iconSrc
        this.iconItem := iconItem
        
        this.ParseIconSrc()

        super.__New(app, themeObj, windowKey, title, this.GetTextDefinition(), owner, parent, "*&Select|&Cancel")
    }

    GetTextDefinition() {
        return "Select the icon you wish to use. The Location can point to an icon file, a directory, or a .exe file."
    }

    ParseIconSrc() {
        listPath := ""

        if (this.iconSrc) {
            SplitPath(this.iconSrc, fileName, iconDir, iconExt)

            if (iconExt == "exe") {
                this.listPath := this.iconSrc
                
                if (!IsInteger(this.iconItem) || this.iconItem <= 0) {
                    this.iconItem := 1
                }
            } else if (iconExt == "ico") {
                this.listPath := iconDir
                this.iconItem := fileName
            } else {
                this.listPath := this.iconSrc

                if (IsInteger(this.iconItem)) {
                    this.iconItem := ""
                }
            }
        }
    }

    Controls() {
        super.Controls()
        this.AddLocationBlock("Location")
        this.AddIconList()


        ; Show listview in icon format
    }

    ProcessResult(result) {
        result := (result == "Select") ? this.iconSrc : ""

        if (result && IsInteger(this.iconItem)) {
            result .= ":" . this.iconItem
        }

        return super.ProcessResult(result)
    }

    GetIconSrc() {
        return this.iconSrc
    }

    GetIconNum() {
        iconNum := ""

        if (IsInteger(this.iconItem)) {
            iconNum := this.iconItem
        }

        return iconNum
    }

    AddLocationBlock(fieldName) {
        location := this.listPath ? this.listPath : "Not selected"
        this.AddLocationText(location, fieldName)
        buttonSize := this.themeObj.GetButtonSize("s", true)
        buttonW := (buttonSize.Has("w") && buttonSize["w"] != "auto") ? buttonSize["w"] : 80
        buttonH := (buttonSize.Has("h") && buttonSize["h"] != "auto") ? buttonSize["h"] : 20
        btn := this.AddButton("xs y+m w" . buttonW . " h" . buttonH . " vSelectFile" . fieldName, "Select File")
        btn := this.AddButton("x+m yp w" . buttonW . " h" . buttonH . " vSelectDir" . fieldName, "Select Dir")
    }

    AddLocationText(locationText, fieldName) {
        position := "xs y+m"
        this.SetFont("", "Bold")
        ctl := this.guiObj.AddText("v" . fieldName . " " . position . " w" . this.windowSettings["contentWidth"] . " +0x200 +0x100 c" . this.themeObj.GetColor("linkText"), locationText)
        ctl.ToolTip := locationText
        this.SetFont()
    }

    AddIconList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"]
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " +Icon " . styling . " Count" . this.platformManager.CountEntities() . " Section +Report -Multi " . lvStyles, this.listViewColumns)
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.PopulateListView()
    }

    PopulateListView() {
        this.guiObj["ListView"].Delete()
        
    }

    OnSelectFileLocation(ctl, info) {

    }

    OnSelectDirLocation(ctl, info) {

    }
}
