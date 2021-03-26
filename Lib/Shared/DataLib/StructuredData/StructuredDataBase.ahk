class StructuredDataBase {
    objVal := ""

    Obj {
        get => this.objVal
        set => this.objVal := value
    }

    __New(obj := "") {
        this.obj := obj
    }

    FromString(ByRef src, args*) {
        throw MethodNotImplementedException.new("StructuredDataBase", "FromString")
    }

    ToString(obj := "", args*) {
        throw MethodNotImplementedException.new("StructuredDataBase", "ToString")
    }

    FromFile(filePath, args*) {
        if (!filePath) {
            throw FileSystemException.new("File path '" . filePath . "' is invalid.")
        }

        if (!FileExist(filePath)) {
            throw FileSystemException.new("File path '" . filePath . "' does not exist.")
        }

        return this.FromString(FileRead(filePath), args*)
    }

    ToFile(filePath, overwrite := false, args*) {
        if (!filePath) {
            throw FileSystemException.new("File path '" . filePath . "' is invalid.")
        }

        if (FileExist(filePath) && !overwrite) {
            throw FileSystemException.new("File path '" . filePath . "' already exists.")
        }

        if (FileExist(filePath)) {
            FileDelete(filePath)
        }

        FileAppend(this.ToString(this.obj, args*), filePath)
    }
}
