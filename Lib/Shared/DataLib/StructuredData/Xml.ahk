; TODO: Create a full StructuredData implementation for XML
class Xml {
    static FromString(&src, args*) {
        obj := ComObject("MSXML2.DOMDocument.6.0")
        obj.async := false
        obj.loadXML(src)
        return obj
    }

    static ToString(obj, args*) {
        throw MethodNotImplementedException("Xml", "ToString")
    }

    static ToFile(obj, filePath, args*) {
        FileAppend(Xml.ToString(obj, args*), filePath)
    }

    static FromFile(filePath, args*) {
        var := FileRead(filePath)
        return Xml.FromString(&var, args*)
    }
}
