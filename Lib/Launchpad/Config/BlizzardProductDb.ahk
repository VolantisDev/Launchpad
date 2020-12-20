class BlizzardProductDb extends ProtoConfig {
    primaryConfigKey := "Database"

    __New(app, autoLoad := true) {
        path := A_AppDataCommon . "\Battle.net\Agent\product.db"
        protoFile := A_ScriptDir . "\Resources\Dependencies\BlizzardProductDb.proto"
        super.__New(app, path, protoFile, autoLoad)
    }

    GetProductInstalls() {
        if (!this.loaded) {
            this.LoadConfig()
        }

        productInstalls := []

        if (this.config.Has("productInstall") and Type(this.config["productInstall"]) == "Array") {
            productInstalls := this.config["productInstall"]
        }

        return productInstalls
    }

    GetProductInstallPath(productCode) {
        productInstalls := this.GetProductInstalls()
        installPath := ""

        for index, productData in productInstalls {
            if (productData.Has("productCode") and productData["productCode"] == productCode and productData.Has("settings") and productData["settings"].Has("installPathj")) {
                installPath := productData["settings"]["installPath"]
                break
            }
        }

        return installPath
    }
}
