class ClassFileComponentDiscoverer extends FileComponentDiscovererBase {
    DiscoverComponent(fileName, filePath) {
        componentName := this.GetComponentName(fileName, filePath)
       
        if (!this.results.Has(componentName)) {
            this.results[componentName] := this.PopulateComponentInfo(fileName, filePath)
        }
    }

    PopulateComponentInfo(fileName, filePath) {
        return Map(
            "class", this.GetComponentClassName(fileName, filePath),
            "file", filePath
        )
    }

    GetComponentName(fileName, filePath) {
        parts := StrSplit(fileName, ".", " \t", 2)
        return parts[1]
    }

    GetComponentClassName(fileName, filePath) {
        return this.GetComponent(fileName, filePath)
    }
}
