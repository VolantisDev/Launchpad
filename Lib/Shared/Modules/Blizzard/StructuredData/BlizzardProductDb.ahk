class BlizzardProductDb extends ProtobufData {
    path := ""
    loaded := false

    __New(autoLoad := false) {
        ; TODO: Remove dependency on A_ScriptDir
        this.path := A_AppDataCommon . "\Battle.net\Agent\product.db"
        protoFile := A_ScriptDir . "\Resources\Dependencies\BlizzardProductDb.proto"
        super.__New(protoFile, "", "Database")

        if (autoLoad) {
            this.FromFile()
        }
    }

    GetProductInstalls() {
        if (!this.loaded) {
            this.FromFile()
        }

        productInstalls := []

        if (this.obj.Has("productInstall") && Type(this.obj["productInstall"]) == "Array") {
            productInstalls := this.obj["productInstall"]
        }

        return productInstalls
    }

    GetProductInstallPath(productCode) {
        productInstalls := this.GetProductInstalls()
        installPath := ""

        for index, productData in productInstalls {
            if (productData["productCode"] == productCode && productData.Has("settings") && productData["settings"].Has("installPath")) {
                installPath := productData["settings"]["installPath"]
                break
            }
        }

        return installPath
    }

    FromFile() {
        super.FromFile(this.path)
        this.loaded := true
    }
}
