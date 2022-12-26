class TextEntityFieldWidget extends EntityFieldWidgetBase {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := "EditControl"
        defaults["rows"] := 1
        defaults["lineSeparator"] := ""
        defaults["controlParams"] := [
            "{{param.rows}}",
            "{{param.lineSeparator}}",
            "{{param.help}}"
        ]
        return defaults
    }
}
