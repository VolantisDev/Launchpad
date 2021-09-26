class SimpleComponentLoader extends ComponentLoaderBase {
    LoadComponent(key, componentInfo) {
        isEnabled := true

        if (componentInfo && Type(componentInfo) == "Map" && componentInfo.Has("enabled")) {
            isEnabled := componentInfo["enabled"]
        }

        if (isEnabled) {
            this.results[key] := componentInfo
            super.LoadComponent(key, componentInfo)
        }
    }
}
