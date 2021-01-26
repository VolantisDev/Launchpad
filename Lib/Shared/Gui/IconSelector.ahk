; @todo WIP, need to finish
class IconSelector extends DialogBox {
    iconSrc := ""
    iconItem := ""
    listPath := ""

    __New(title, themeObj, iconSrc := "", iconItem := "", windowKey := "", owner := "", parent := "") {
        InvalidParameterException.CheckTypes("IconSelector", "iconSrc", iconSrc, "")
        this.iconSrc := iconSrc
        this.iconItem := iconItem
        
        this.ParseIconSrc()

        super.__New(title, themeObj, this.GetTextDefinition(), windowKey, owner, parent, "*&OK|&Cancel")
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


        ; Show listview in icon format
    }

    ProcessResult(result) {
        value := "" ; Get the selected icon path
        result := (result == "OK") ? value : ""
        return super.ProcessResult(result)
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

    OnSelectFileLocation(ctl, info) {

    }

    OnSelectDirLocation(ctl, info) {

    }
}
