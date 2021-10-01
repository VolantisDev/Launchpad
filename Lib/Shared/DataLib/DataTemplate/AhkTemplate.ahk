class AhkTemplate extends StringTemplate {
    ahkVar := ""

    __New(template, data := "") {
        this.ahkVar := AhkVariable()
        super.__New(template, data)
    }

    Render() {
        output := super.Render()
        data := this.GetData()

        for key, value in data {
            token := "{%" . key . "%}"
            output := StrReplace(output, token, this.ahkVar.ToString(value))
        }
    }
}
