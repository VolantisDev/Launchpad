class TimeOffsetEntityField extends NumberEntityField {
    DefinitionDefaults(fieldDefinition) {
        defaults := super.DefinitionDefaults(fieldDefinition)

        defaults["type"] := "integer"
        defaults["timeUnits"] := "s"
        defaults["widget"] := "time_offset"
        
        return defaults
    }
}
