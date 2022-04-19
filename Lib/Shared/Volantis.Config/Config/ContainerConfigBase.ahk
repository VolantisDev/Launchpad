class ContainerConfigBase extends ConfigBase {
    container := ""
    parentKey := ""

    __New(container, parentKey := "", autoLoad := true) {
        this.container := container
        this.parentKey := parentKey

        super.__New(autoLoad)
    }

    _has(key) {
        return this.container.HasParameter(this._getContainerKey(key))
    }

    _getContainerKey(key) {
        if (this.parentKey) {
            if (key) {
                key := "." . key
            }

            key := this.parentKey . key
        }

        return key
    }

    _delete(key) {
        this.container.DeleteParameter(key)
    }

    _get(key := "") {
        return this._getContainerParameter(key)
    }

    _getContainerParameter(key := "") {
        return this.container.GetParameter(this._getContainerKey(key))
    }

    _set(key, value) {
        this._setContainerParameter(key, value)
    }

    _setContainerParameter(key, value) {
        this.container.SetParameter(this._getContainerKey(key), value)
    }

    _loadConfig(loadedValues) {
        this._initializeParentParameter()
        super._loadConfig(loadedValues)
    }

    _initializeParentParameter() {
        if (!this._has("")) {
            this._set("", Map())
        }
    }
}
