class GdiPlusBase {
    handle := ""

    __New() {
        this.handle := this.Startup()
    }

    GetHandle() {
        return this.handle
    }

    Startup() {

    }
}
