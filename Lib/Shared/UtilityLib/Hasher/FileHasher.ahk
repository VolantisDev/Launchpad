class FileHasher extends HasherBase {
    static HASH_TYPE_MD2 := 32769
    static HASH_TYPE_MD5 := 32771
    static HASH_TYPE_SHA := 32772
    static HASH_TYPE_SHA256 := 32780
    static HASH_TYPE_SHA384 := 32781
    static HASH_TYPE_SHA512 := 32782

    static PROV_RSA_AES := 24
    static CRYPT_VERIFYCONTEXT := 0xF0000000
    static BUFF_SIZE := 1024 * 1024 ; 1 MB
    static HP_HASHVAL := 0x0002
	static HP_HASHSIZE := 0x0004

    hModule := ""
    hCryptProv := ""

    __New() {
        super.__New()
        this.hModule := DllCall("GetModuleHandleW", "Str", "Advapi32.dll", "Ptr")

        if (!this.hModule) {
            hModule := DllCall("LoadLibraryW", "Str", "Advapi32.dll", "Ptr")
        }

        hCryptProv := Buffer(A_PtrSize)
        DllCall("Advapi32\CryptAcquireContextW", "Ptr", hCryptProv, "UInt", 0, "UInt", 0, "UInt", FileHasher.PROV_RSA_AES, "UInt", FileHasher.CRYPT_VERIFYCONTEXT)
        this.hCryptProv := hCryptProv
    }

    __Delete() {
        DllCall("FreeLibrary", "Ptr", this.hModule)
        DllCall("Advapi32\CryptReleaseContext", "Ptr", this.hCryptProv, "UInt", 0)
        super.__Delete()
    }

    Hash(filePath, hashType := "") {
        if (hashType == "") {
            hashType := FileHasher.HASH_TYPE_SHA256
        }

        f := FileOpen(filePath, "r", "CP0")

        if (!IsObject(f)) {
            throw AppException("Could not load file " . filePath . ".")
        }

        hHash := Buffer(A_PtrSize)
        DllCall("Advapi32\CryptCreateHash", "Ptr", this.hCryptProv, "UInt", hashType, "UInt", 0, "UInt", 0, "Ptr", hHash)
        read_buf := Buffer(FileHasher.BUFF_SIZE, 0)
        hCryptrHashData := DllCall("GetProcAddress", "Ptr", this.hModule, "AStr", "CryptHashData", "Ptr")

        while cbCount := f.RawRead(read_buf, FileHasher.BUFF_SIZE) {
            if (cbCount == 0) {
                break
            }

            hHash := Buffer(A_PtrSize)
            DllCall(hCryptrHashData, "Ptr", hHash, "Ptr", read_buf, "UInt", cbCount, "UInt", 0)
        }

        hashLenSize := 4
        hashLen := 0
        DllCall("Advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", FileHasher.HP_HASHSIZE, "UInt*", &hashLen, "UInt*", &hashLenSize, "UInt", 0)
        pbHash := Buffer(hashLen, 0)
        DllCall("Advapi32\CryptGetHashParam", "Ptr", hHash, "UInt", FileHasher.HP_HASHVAL, "Ptr", pbHash, "UInt*", &hashLen, "UInt", 0)
        hashVal := ""

        Loop hashLen {
            num := Format("0x{:x}", NumGet(pbHash, A_Index - 1, "UChar"))
            hashVal .= SubStr((num >> 4), 0) . SubStr((num & 0xf), 0)
        }

        f.Close()
        DllCall("Advapi32\CryptDestroyHash", "Ptr", hHash)
        return hashVal
    }
}
