class DiscoveryEntityDefinitionLoader extends EntityDefinitionLoaderBase {
    LoadServiceDefinitions() {
        return this.factoryObj.DetectServiceDefinitions()
    }
}