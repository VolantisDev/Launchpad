class ComboBoxEntityFieldWidget extends SelectEntityFieldWidget {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := "ComboBoxControl"
        return defaults
    }
}
