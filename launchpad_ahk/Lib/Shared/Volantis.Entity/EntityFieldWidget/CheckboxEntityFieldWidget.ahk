class CheckboxEntityFieldWidget extends EntityFieldWidgetBase {
    GetDefaultDefinition(definition) {
        defaults := super.GetDefaultDefinition(definition)
        defaults["controlClass"] := "CheckboxControl"
        defaults["controlParams"] := [
            "{{param.title}}",
            "{{param.help}}"
        ]
        return defaults
    }
}
