/**
  This is a base class representing a set of data that has multiple layers.

  Data can be retrieved from any layer, but the main benefit is that the layers can be combined
  into one set of data, where each layer overwrites the values of the layer underneath it.

  Finally, processors can be applied after the layers are merged.

  Example:
    - Layer 1: Initial defaults
    - Layer 2: Defaults from datasource
    - Layer 3: Auto-detected defaults
    - Layer 4: User configuration values
    - Processor 1: Token expander
    - Processor 2: File locator
*/
class LayeredDataBase {
    layers := Map()
    layerPriority := []
    processors := []
    original := ""

    __New(processors, params*) {
        if (processors != "") {
            this.processors := processors
        }

        if (params.Has(1)) {
            this.SetLayers(params*)
        }

        this.LoadValues()
    }

    LoadValues() {
        ; Optional hook for subclasses to load data into one or more layers
    }

    SetLayers(params*) {
        nextParam := 1

        while (params.Has(nextParam)) {
            layerName := params[nextParam]
            layerData := params[nextParam + 1]
            this.SetLayer(layerName, layerData)
            nextParam := nextParam + 2
        }
    }

    SetLayer(layerName, data, layerPriority := "") {
        alreadyExists := this.layers.Has(layerName)
        this.layers[layerName] := data

        if (!alreadyExists) {
            if (layerPriority == "") {
                this.layerPriority.Push(layerName)
            } else {
                this.layerPriority.InsertAt(layerPriority, layerName)
            }
        }
    }

    GetLayer(layerName) {
        return this.layers.Has(layerName) ? this.layers[layerName] : Map()
    }

    DeleteLayer(layerName) {
        if (this.layers.Has(layerName)) {
            this.layers.Delete(layerName)

            for index, value in this.layerPriority {
                if (layerName == value) {
                    this.layerPriority.RemoveAt(index)
                    break
                }
            }
        }
    }

    /**
        key: The key to retrieve

        processValue: Whether or not to apply the processors to the returned value

        layer: The layer to retrieve data from. The default if empty is all layers (with 
        the topmost layer that has a value winning out)
    */
    GetValue(key, processValue := true, layer := "") {
        value := ""

        if (layer != "") {
            if (this.layers.Has(layer) && this.layers[layer].Has(key)) {
                value := this.layers[layer][key]
            }
        } else {
            for index, layerName in this.layerPriority {
                if (this.layers[layerName].Has(key)) {
                    value := this.layers[layerName][key]
                }
            }
        }

        if (processValue) {
            value := this.ApplyProcessors(value)
        }

        return value
    }

    HasValue(key, layer := "", allowEmpty := true) {
        hasValue := false

        if (layer != "") {
            hasValue := (this.layers.Has(layer) && this.layers[layer].Has(key))
        } else {
            for index, layerName in this.layerPriority {
                if (this.layers[layerName].Has(key)) {
                    if (allowEmpty || this.layers[layerName][key] != "") {
                        hasValue := true
                        break
                    }
                }
            }
        }

        return hasValue
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

        if (this.layers.Has(layer)) {
            this.layers[layer][key] := value
        }
    }

    DeleteValue(key, layer := "") {
        if (layer == "") {
            layer := this.GetTopLayer()
        }

        if (this.layers.Has(layer) && this.layers[layer].Has(key)) {
            this.layers[layer].Delete(key)
        }
    }

    GetTopLayer() {
        layer := ""

        for index, layerName in this.layerPriority {
            layer := layerName
        }

        return layer
    }

    GetMergedData(process := true) {
        data := Map()

        for index, layer in this.layerPriority {
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

    StoreOriginal(update := false) {
        if (this.original == "" || update) {
            this.original := this.CloneLayers()
        }
        
        return this.original
    }

    RestoreFromOriginal() {
        if (this.original != "") {
            this.layers := this.CloneLayers(this.original)
        }
    }

    CloneLayers(layers := "") {
        if (layers == "") {
            layers := this.layers
        } else if (Type(layers) == "String") {
            layers := Map(layers, this.layers[layers])
        }

        cloned := Map()

        for key, layer in layers {
            cloned[key] := this.CloneData(layer)
        }

        return cloned
    }

    CloneData(data) {
        return data.Clone()
    }

    /**
        Diffs changes between the requested layer or all layers merged (default if blank)
    */
    DiffChanges(layer := "") {
        currentData := (layer == "") ? this.GetMergedData(false) : this.layers[layer]
        originalData := Map()
        
        added := Map()
        modified := Map()
        removed := Map()

        if (this.original != "") {
            if (layer == "") {
                for key, data in this.original {
                    originalData := this.MergeData(originalData, data, true)
                }
            } else if this.original.Has(layer) {
                originalData := this.original[layer]
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

        return DiffResult.new(added, modified, removed)
    }

    DebugData(layer := "") {
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

        if (Type(val) == "Array") {
            output := indent . "Array {`n"

            for index, value in val {
                output .= indent . "`t" . index . ": " . this.DebugValue(value, indent . "`t") . "`n"
            }

            output .= indent . "}`n"
        } else if (Type(val) == "Map") {
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
}
