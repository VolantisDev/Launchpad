class BasicData extends StructuredDataBase {
    __New(obj := "") {
        this.obj := obj
    }

    FromString(&src, args*) {
        throw MethodNotImplementedException("BasicStructuredData", "FromString")
    }

    ToString(obj := "", args*) {
        throw MethodNotImplementedException("BasicStructuredData", "ToString")
    }
}
