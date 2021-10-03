class JsonDefinitionLoader extends StructuredFileDefinitionLoader {
    LoadStructuredData(filePath) {
        if (!FileExist(filePath)) {
            throw ContainerException("Definition file " . filePath . " not found")
        }

        return JsonData().FromFile(filePath)
    }
}
