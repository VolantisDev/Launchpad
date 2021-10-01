class StructuredDataBase {
    objVal := ""

    Obj {
        get => this.objVal
        set => this.objVal := value
    }

    __New(obj := "") {
        this.obj := obj
    }

    FromString(&src, args*) {
        throw MethodNotImplementedException("StructuredDataBase", "FromString")
    }

    ToString(obj := "", args*) {
        throw MethodNotImplementedException("StructuredDataBase", "ToString")
    }

    FromFile(filePath, args*) {
        if (!filePath) {
            throw FileSystemException("File path '" . filePath . "' is invalid.")
        }

        if (!FileExist(filePath)) {
            throw FileSystemException("File path '" . filePath . "' does not exist.")
        }

        var := ""

        try {
            var := FileRead(filePath)
        } catch as er {
            er.Extra := filePath
            throw er
        }
        
        return this.FromString(&var, args*)
    }

    ToFile(filePath, overwrite := false, args*) {
        if (!filePath) {
            throw FileSystemException("File path '" . filePath . "' is invalid.")
        }

        if (FileExist(filePath) && !overwrite) {
            throw FileSystemException("File path '" . filePath . "' already exists.")
        }

        if (FileExist(filePath)) {
            FileDelete(filePath)
        }

        FileAppend(this.ToString(this.obj, args*), filePath)
    }
}
