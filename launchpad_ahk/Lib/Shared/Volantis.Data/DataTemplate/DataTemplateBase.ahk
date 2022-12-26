class DataTemplateBase {
    template := ""
    data := Map()
    
    __New(template, data := "") {
        this.template := template
        
        if (data) {
            this.data := data
        }
    }

    Render() {
        throw MethodNotImplementedException("StringTemplateBase", "Render")
    }

    GetData() {
        data := Map()

        for key, value in this.data {
            data[key] := this.ProcessTemplateValue(key, value)
        }

        return data
    }

    ProcessTemplateValue(key, value) {
        return value
    }
}
