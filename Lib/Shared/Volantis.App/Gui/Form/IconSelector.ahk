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
            SplitPath(this.iconSrc, &fileName, &iconDir, &iconExt)

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
        ;this.AddIconLocationBlock("Location")
        this.AddIconList()


        ; Show listview in icon format
    }

    ProcessResult(result, submittedData := "") {
        result := (result == "Select") ? this.iconSrc : ""

        if (result && IsInteger(this.iconItem)) {
            result .= ":" . this.iconItem
        }

        return super.ProcessResult(result, submittedData)
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

    AddIconList() {
        styling := "C" . this.themeObj.GetColor("text")
        lvStyles := "+LV" . LVS_EX_LABELTIP . " +LV" . LVS_EX_DOUBLEBUFFER . " +LV" . LVS_EX_FLATSB . " -E0x200"
        lvStyles .= " +LV" . LVS_EX_TRANSPARENTBKGND . " +LV" . LVS_EX_TRANSPARENTSHADOWTEXT
        listViewWidth := this.windowSettings["contentWidth"]
        lv := this.guiObj.AddListView("vListView w" . listViewWidth . " h" . this.windowSettings["listViewHeight"] . " +Icon " . styling . " Count" . this.platformManager.CountEntities() . " Section +Report -Multi " . lvStyles, this.listViewColumns)
        lv.OnEvent("DoubleClick", "OnDoubleClick")
        lv.OnEvent("ItemSelect", "OnItemSelect")
        this.UpdateListView()
    }

    UpdateListView() {
        this.guiObj["ListView"].Delete()
        
    }

    OnSelectFileLocation(ctl, info) {

    }

    OnSelectDirLocation(ctl, info) {

    }
}
