class ClassFileComponentDiscoverer extends FileComponentDiscovererBase {
    DiscoverComponent(fileName, filePath) {
        componentName := this.GetComponentName(fileName, filePath)
        
        if (!this.results.Has(componentName)) {
            this.results[componentName] := this.GetComponentClass(fileName, filePath)
        }
    }

    GetComponentName(fileName, filePath) {
        parts := StrSplit(fileName, ".", " \t", 2)
        return parts[1]
    }

    GetComponentClassName(fileName, filePath) {
        return this.GetComponent(fileName, filePath)
    }
}
