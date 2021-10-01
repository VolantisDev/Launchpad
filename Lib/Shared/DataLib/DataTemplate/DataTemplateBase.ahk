class DataTemplateBase {
    template := ""
    data := Map()
    
    __New(template, data := "") {
        this.template := template
        
        if (data) {
            this.data := data
        }
    }

    GetData() {
        data := Map()

        for key, value in this.data {
            data[key] := this.ProcessTemplateValue(key, value)
        }

        return this.data
    }

    Render() {
        throw MethodNotImplementedException("StringTemplateBase", "Render")
    }

    ProcessTemplateValue(key, value) {
        return value
    }
}
