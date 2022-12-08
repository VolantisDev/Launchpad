/**
  * This is a base class representing a set of data that has multiple layers.
  *
  * Data can be retrieved from any layer, but the main benefit is that the layers can be combined
  * into one set of data, where each layer overwrites the values of the layer underneath it.
  *
  * Finally, processors can be applied to the final data to alter it in any way necessary.
  *
  * Example:
  *   - Layer 1: Initial defaults
  *   - Layer 2: Defaults from datasource
  *   - Layer 3: Auto-detected defaults
  *   - Layer 4: User configuration values
  *   - Processor 1: Token expander
  *   - Processor 2: File locator
  */
class LayeredDataBase {
    layers := Map()
    layerPriority := []
    processors := []
    original := ""
    snapshots := Map()
    layerSources := Map()
    loadedLayers := Map()
    cloner := ""
    userLayers := ["data"]
    loadingLayers := Map()

    static NO_VALUE := ":NO_VAL:"

    __New(cloner, processors, layerNames, layerSources) {
        this.cloner := cloner

        if (processors) {
            if (!HasBase(processors, Array.Prototype)) {
                processors := [processors]
            }

            this.processors := processors
        }

        if (layerNames && layerNames.Length) {
            this.InitializeLayers(layerNames)
        }

        if (layerSources) {
            this.SetLayerSources(layerSources)
        }
    }

    InitializeLayers(layerNames) {
        layers := Map()

        for index, layerName in layerNames {
            layers[layerName] := Map()
        }

        this.SetLayers(layers)
    }

    SetLayerSources(layerSources) {
        for key, source in layerSources {
            this.SetLayerSource(key, source)
        }
    }

    SetLayerSource(layer, sourceObj) {
        this.layerSources[layer] := sourceObj

        if (!this.HasLayer(layer)) {
            this.SetLayer(layer)
        }

        this.UnloadLayer(layer)
    }

    SetLayers(layers) {
        for layerName, layerData in layers {
            this.SetLayer(layerName, layerData)
        }

        return this
    }

    HasLayer(layerName) {
        return this.layers.Has(layerName)
    }

    SetLayer(layerName, data := "", layerPriority := "") {
        alreadyExists := this.HasLayer(layerName)

        ; @todo Determine how to handle this
        ; if (data && this.layerSources.Has(layerName)) {
        ;     this.layerSources.Delete(layerName)
        ; }

        if (!data) {
            data := Map()
        }

        this.layers[layerName] := data
        
        if (!alreadyExists) {
            if (layerPriority == "") {
                this.layerPriority.Push(layerName)
            } else {
                this.layerPriority.InsertAt(layerPriority, layerName)
            }
        }

        return this
    }

    GetLayer(layerName) {
        hasLayer := this.HasLayer(layerName)

        if (hasLayer && !this.LayerIsLoaded(layerName)) {
            this.LoadLayer(layerName)
        }

        return hasLayer ? this.layers[layerName] : Map()
    }

    CreateSnapshot(snapshotName, layers := "") {
        this.snapshots[snapshotName] := this.CloneLayers(layers)

        return this.snapshots[snapshotName]
    }

    HasSnapshot(snapshotName) {
        return this.snapshots.Has(snapshotName)
    }

    GetSnapshot(snapshotName, ignoreFailure := false) {
        snapshot := ""

        if (this.snapshots.Has(snapshotName)) {
            snapshot := this.snapshots[snapshotName]
        } else if (!ignoreFailure) {
            throw AppException("Snapshot name " . snapshotName . " does not exist.")
        }

        return snapshot
    }

    RestoreSnapshot(snapshotName) {
        snapshot := this.GetSnapshot(snapshotName)

        if (snapshot) {
            this.SetLayers(snapshot)
        } else {
            throw AppException("Cannot restore empty snapshot " . snapshotName)
        }

        return this
    }

    DeleteLayer(layerName) {
        if (this.HasLayer(layerName)) {
            this.layers.Delete(layerName)
        }

        for index, value in this.layerPriority {
            if (layerName == value) {
                this.layerPriority.RemoveAt(index)
                break
            }
        }

        if (this.layerSources.Has(layerName)) {
            this.layerSources.Delete(layerName)
        }
    }

    LoadLayer(layer, reload := false) {
        if (
            (!this.loadingLayers.Has(layer) || !this.loadingLayers[layer])
            && this.layerSources.Has(layer)
            && (reload || !this.LayerIsLoaded(layer))
        ) {
            this.loadingLayers[layer] := true
            this.loadLayerFromSource(layer, this.layerSources[layer])
            this.loadedLayers[layer] := true
            this.loadingLayers.Delete(layer)
        }
    }

    loadLayerFromSource(layer, sourceObj, cloneMap := true) {
        data := ""

        if (HasBase(sourceObj, LayerSourceBase.Prototype)) {
            data := sourceObj.LoadData()
        } else if (HasBase(sourceObj, Map.Prototype)) {
            data := sourceObj

            if (cloneMap) {
                data := this.cloner.Clone(data)
            }
        } else if (HasMethod(sourceObj)) {
            data := sourceObj()
        }

        if (!data) {
            data := Map()
        }

        this.SetLayer(layer, data)
    }

    LoadAllLayers(reload := false) {
        for , layerName in this._getLayerPriority() {
            this.LoadLayer(layerName, reload)
        }
    }

    LayerIsLoaded(layer) {
        return this.loadedLayers.Has(layer) && this.loadedLayers[layer]
    }

    UnloadLayer(layer) {
        if (this.LayerIsLoaded(layer)) {
            this.layers[layer] := Map()
            this.loadedLayers.Delete(layer)
        }
    }

    UnloadAllLayers(includeUserLayers := false) {
        for , layerName in this._getLayerPriority() {
            if (!includeUserLayers) {
                isUserLayer := false

                for index, layer in this.userLayers {
                    if (layer == layerName) {
                        isUserLayer := true
                        break
                    }
                }

                if (isUserLayer) {
                    break
                }
            }

            this.UnloadLayer(layerName)
        }
    }

    /**
        key: The key to retrieve

        processValue: Whether or not to apply the processors to the returned value

        layer: The layer to retrieve data from. The default if empty is all layers (with 
        the topmost layer that has a value winning out)
    */
    GetValue(key, processValue := true, layer := "", defaultValue := "") {
        value := defaultValue
        hasValue := false

        if (layer != "") {
            if (this.HasValue(key, layer)) {
                value := this.GetRawLayerValue(layer, key)
                hasValue := true
            }
        } else {
            for , layerName in this._getLayerPriority(true) {
                if (this.HasValue(key, layerName)) {
                    value := this.GetRawLayerValue(layerName, key)
                    hasValue := true
                    break
                }
            }
        }

        if (processValue && hasValue) {
            value := this.ApplyProcessors(value)
        }

        return value
    }

    GetRawLayerValue(layer, key, default := ":NO_VAL:") {
        value := default

        if (this.HasLayer(layer)) {
            if (!this.LayerIsLoaded(layer)) {
                this.LoadLayer(layer)
            }
    
            if (this.layers[layer].Has(key)) {
                value := this.layers[layer][key]
            }
        }

        return value
    }

    _getLayerPriority(reverse := false) {
        layerPriority := this.layerPriority

        if (reverse) {
            priorityClone := layerPriority.Clone()
            layerPriority := []

            for index, layerName in this.layerPriority.Clone() {
                layerPriority.Push(priorityClone.Pop())
            }
        }

        return layerPriority
    }

    HasValue(key, layer := "", allowEmpty := true) {
        hasValue := false

        if (layer) {
            if (this.HasLayer(layer)) {
                if (!this.LayerIsLoaded(layer)) {
                    this.LoadLayer(layer)
                }
    
                hasValue := (this.layers[layer].Has(key))

                if (hasValue && !allowEmpty) {
                    hasValue := this.layers[layer][key] != ""
                }
            }
        } else {
            for , layerName in this._getLayerPriority(true) {
                if (this.HasValue(key, layerName, allowEmpty)) {
                    hasValue := true
                    break
                }
            }
        }

        return hasValue
    }

    HasUserValue(key, allowEmpty := true) {
        hasValue := false

        for , layer in this.userLayers {
            if (this.HasValue(key, layer, allowEmpty)) {
                hasValue := true
                break
            }
        }

        return hasValue
    }

    HasData(userLayersOnly := false) {
        hasData := false
        layers := userLayersOnly ? this.userLayers : this._getLayerPriority(true)

        for , layer in layers {
            hasSource := this.layerSources.Has(layer)

            if (hasSource && HasBase(this.layerSources[layer], LayerSourceBase.Prototype)) {
                if (this.layerSources[layer].HasData()) {
                    hasData := true
                    break
                }
            } else {
                if (hasSource) {
                    this.LoadLayer(layer, false)
                }

                if (this.layers[layer] && this.layers[layer].Count > 0) {
                    hasData := true
                    break
                }
            }
        }
    }

    ApplyProcessors(value) {
        for index, processor in this.processors {
            value := this.ApplyProcessor(processor, value)
        }

        return value
    }

    ApplyProcessor(processor, value) {
        return processor.Process(value)
    }

    /**
        key: The key to set the value for

        value: The new value to set

        layer: The layer to set the value to. The default if empty is the topmost layer.
    */
    SetValue(key, value, layer := "") {
        if (layer == "") {
            layer := this.GetTopLayer()
        }

        if (this.HasLayer(layer)) {
            if (!this.LayerIsLoaded(layer)) {
                this.LoadLayer(layer)
            }

            this.layers[layer][key] := value
        } else {
            throw AppException("Layer " . layer . " not found.")
        }
    }

    DeleteValue(key, layer := "") {
        if (layer == "") {
            layer := this.GetTopLayer()
        }

        if (this.HasLayer(layer)) {
            if (!this.LayerIsLoaded(layer)) {
                this.LoadLayer(layer)
            }

            if (this.HasValue(key, layer, true)) {
                this.layers[layer].Delete(key)
            }
        }
    }

    DeleteUserValue(key) {
        for index, layer in this.userLayers {
            this.DeleteValue(key, layer)
        }
    }

    GetTopLayer() {
        layer := ""

        for index, layerName in this.layerPriority {
            layer := layerName
        }

        if (!layer) {
            throw AppException("There is currently no top layer.")
        }

        return layer
    }

    GetMergedData(process := true) {
        data := Map()

        for index, layer in this.layerPriority {
            if (!this.LayerIsLoaded(layer)) {
                this.LoadLayer(layer)
            }

            data := this.MergeData(data, this.layers[layer], true)
        }

        if (process) {
            for key, value in data {
                data[key] := this.ApplyProcessors(value)
            }
        }

        return data
    }

    MergeData(data, otherData, overwrite := true) {
        for key, value in otherData {
            if (!data.Has(key) || overwrite) {
                data[key] := value
            }
        }

        return data
    }

    CloneLayers(layers := "") {
        if (layers == "") {
            this.LoadAllLayers()
            layers := this.layers
        } else if (Type(layers) == "String") {
            if (!this.LayerIsLoaded(layers)) {
                this.LoadLayer(layers)
            }

            layers := Map(layers, this.layers[layers])
        }

        cloned := Map()

        for key, layer in layers {
            cloned[key] := this.CloneData(layer)
        }

        return cloned
    }

    CloneData(data) {
        ; @todo use a deep cloner object?
        return data.Clone()
    }

    /**
        Diffs changes between the requested layer or all layers merged (default if blank)
    */
    DiffChanges(snapshotName, layer := "") {
        if (layer && !this.LayerIsLoaded(layer)) {
            this.LoadLayer(layer)
        }

        currentData := (layer == "") ? this.GetMergedData(false) : this.layers[layer]
        snapshotData := this.GetSnapshot(snapshotName, true)
        originalData := Map()
        
        added := Map()
        modified := Map()
        removed := Map()

        if (snapshotData != "") {
            if (layer == "") {
                for key, data in snapshotData {
                    originalData := this.MergeData(originalData, data, true)
                }
            } else if snapshotData.Has(layer) {
                originalData := snapshotData[layer]
            }
        }

        if (originalData.Count == 0) {
            added := this.CloneData(currentData)
        } else {
            for key, value in currentData {
                if (originalData.Has(key)) {
                    if (value != originalData[key]) {
                        modified[key] := value
                    }
                } else {
                    added[key] := value
                }
            }

            for key, value in originalData {
                if (!currentData.Has(key)) {
                    removed[key] := value
                }
            }
        }

        return DiffResult(added, modified, removed)
    }

    ; TODO: Replace with a call to Debugger's Inspect method
    DebugData(layer := "") {
        if (layer == "") {
            this.LoadAllLayers()
        } else {
            if (!this.LayerIsLoaded(layer)) {
                this.LoadLayer(layer)
            }
        }

        layers := (layer == "") ? this.layers : Map(layer, this.layers[layer])

        output := ""

        for layer, layerData in layers {
            if (output) {
                output .= "`n"
            }

            output .= layer . "{`n"

            for key, value in layerData {
                output .= "`t" . key . ": " . this.DebugValue(value) . "`n"
            }

            output .= "}`n"
        }

        if (output) {
            MsgBox(output)
        }
    }

    DebugValue(val, indent := "`t") {
        output := val

        if (HasBase(val, Array.Prototype)) {
            output := indent . "Array {`n"

            for index, value in val {
                output .= indent . "`t" . index . ": " . this.DebugValue(value, indent . "`t") . "`n"
            }

            output .= indent . "}`n"
        } else if (HasBase(val, Map.Prototype)) {
            output := indent . "Map {`n"

            for key, value in val {
                output .= indent . "`t" . key . ": " . this.DebugValue(value, indent . "`t") . "`n"
            }

            output .= indent . "}`n"
        } else if (IsObject(val)) {
            output := indent . "Object {`n"

            for key, value in val.OwnProps() {
                output .= indent . "`t" . key . ": " . this.DebugValue(value, indent . "`t") . "`n"
            }

            output .= indent . "}`n"
        }

        return output
    }

    SaveData() {
        storageId := this.entity.GetStorageId()

        for index, layer in this.userLayers {
            if (this.layerSources.Has(layer) && HasBase(this.layerSources[layer], LayerSourceBase.Prototype)) {
                this.layerSources[layer].SaveData(this.GetLayer(layer))
            }
        }
    }
}
