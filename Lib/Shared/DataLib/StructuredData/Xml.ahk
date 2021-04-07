; TODO: Create a full StructuredData implementation for XML
class Xml {
    static FromString(ByRef src, args*) {
        obj := ComObjCreate("MSXML2.DOMDocument.6.0")
        obj.async := false
        obj.loadXML(src)
        return obj
    }

    static ToString(obj, args*) {
        throw MethodNotImplementedException.new("Xml", "ToString")
    }

    static ToFile(obj, filePath, args*) {
        FileAppend(Xml.ToString(obj, args*), filePath)
    }

    static FromFile(filePath, args*) {
        return Xml.FromString(FileRead(filePath), args*)
    }
}
