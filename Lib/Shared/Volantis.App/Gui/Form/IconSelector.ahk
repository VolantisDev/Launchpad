class IconSelector extends DialogBox {
    listPath := ""

    GetDefaultConfig(container, config) {
        defaults := super.GetDefaultConfig(container, config)
        defaults["iconSrc"] := ""
        defaults["iconItem"] := ""
        defaults["text"] := "Select the icon you wish to use. The Location can point to an icon file, a directory, or a .exe file."
        defaults["buttons"] := "*&Select|&Cancel"
        return defaults
    }

    __New(container, themeObj, config) {
        this.ParseIconSrc()
        super.__New(container, themeObj, config)
    }

    ParseIconSrc() {
        listPath := ""

        if (this.config["iconSrc"]) {
            SplitPath(this.config["iconSrc"], &fileName, &iconDir, &iconExt)

            if (iconExt == "exe") {
                this.listPath := this.config["iconSrc"]
                
                if (!IsInteger(this.config["iconItem"]) || this.config["iconItem"] <= 0) {
                    this.config["iconItem"] := 1
                }
            } else if (iconExt == "ico") {
                this.listPath := iconDir
                this.config["iconItem"] := fileName
            } else {
                this.listPath := this.config["iconSrc"]

                if (IsInteger(this.config["iconItem"])) {
                    this.config["iconItem"] := ""
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
        result := (result == "Select") ? this.config["iconSrc"] : ""

        if (result && IsInteger(this.config["iconItem"])) {
            result .= ":" . this.config["iconItem"]
        }

        return super.ProcessResult(result, submittedData)
    }

    GetIconSrc() {
        return this.config["iconSrc"]
    }

    GetIconNum() {
        iconNum := ""

        if (IsInteger(this.config["iconItem"])) {
            iconNum := this.config["iconItem"]
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
