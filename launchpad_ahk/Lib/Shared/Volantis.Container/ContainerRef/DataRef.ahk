class DataRef extends ContainerRefBase {
    stringTemplate := ""

    __New(name, stringTemplate := "") {
        if (stringTemplate) {
            this.stringTemplate := stringTemplate
        }
        super.__New(name)
    }

    GetStringTemplate() {
        return this.stringTemplate
    }
}
