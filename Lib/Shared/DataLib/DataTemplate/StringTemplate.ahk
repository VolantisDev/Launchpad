class StringTemplate extends DataTemplateBase {
    Render() {
        output := this.template
        data := this.GetData()

        for key, value in data {
            token := "{{" . key . "}}"
            output := StrReplace(output, token, value)
        }

        return output
    }
}
