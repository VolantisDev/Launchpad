class UuidGenerator extends IdGeneratorBase {
    Generate() {
        A := Buffer(16)
        DllCall("rpcrt4\UuidCreate", "Ptr", A) 
        Address := A.Ptr
        h := ""
        offset := 0

        Loop 16 
        { 
            x := SubStr(Format("{:X}", NumGet(Address, offset, "Char")), -2)
            h .= x
            offset++
        }

        uuid := SubStr(h,1,8) . "-" . SubStr(h,9,4) . "-" . SubStr(h,13,4) . "-" . SubStr(h,17,4) . "-" . SubStr(h,21,12)
        return uuid
    }
}
