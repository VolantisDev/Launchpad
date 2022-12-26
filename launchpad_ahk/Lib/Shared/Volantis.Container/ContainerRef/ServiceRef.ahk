class ServiceRef extends ContainerRefBase {
    method := ""
    
    __New(name, method := "") {
        this.method := method
        super.__New(name)
    }

    GetMethod() {
        return this.method
    }
}
