class IconFileEntityField extends FileEntityFieldBase {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)
        
        defaults["fileMask"] := "*.exe|*.ico"

        return defaults
    }
}
