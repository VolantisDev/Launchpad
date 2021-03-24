class BlizzardProductDb extends ProtoConfig {
    primaryConfigKey := "Database"
    configKey := "BlizzardProductDb"

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

        if (this.config.Has("productInstall") && Type(this.config["productInstall"]) == "Array") {
            productInstalls := this.config["productInstall"]
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
}
