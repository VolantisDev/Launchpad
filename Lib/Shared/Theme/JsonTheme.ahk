class JsonTheme extends ThemeBase {
    GetThemeMap(themeName) {
        themeFile := ""
        basePath := this.themesDir . "\" . themeName

        if (FileExist(basePath . ".json")) {
            themeFile := basePath . ".json"
        } else if (FileExist(basePath . "\" . themeName . ".json")) {
            themeFile := basePath . "\" . themeName . ".json"
        }

        themeMap := Map()

        if (themeFile != "") {
            data := JsonData.new()
            jsonMap := data.FromFile(themeFile)
            
            if (jsonMap.Has("theme")) {
                themeMap := jsonMap["theme"]
            }
        }

        return themeMap
    }
}
