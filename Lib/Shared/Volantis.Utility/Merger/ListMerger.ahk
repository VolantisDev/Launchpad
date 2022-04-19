class ListMerger extends MergerBase {
    Merge(value1, value2) {
        if (this._isArrayLike(value1) && this._isArrayLike(value2)) {
            for index, val in value2 {
                if (this.deep && idx := this._getIndex(val)) {
                    value1[idx] := this.Merge(value1[idx], val)
                } else {
                    value1.Push(val)
                }
            }
        } else if (this._isMapLike(value1) && this._isMapLike(value2)) {
            for key, val in value2 {
                if (this.deep && value1.Has(key)) {
                    value1[key] := this.Merge(value1[key], val)
                } else {
                    value1[key] := val
                }
            }
        } else {
            value1 := value2
        }

        return value1
    }

    _isArrayLike(value) {
        return HasBase(value, Array.Prototype)
    }

    _isMapLike(value) {
        return (HasBase(value, Map.Prototype) || HasBase(value, ParameterBag.Prototype))
    }

    _getIndex(arr, val) {
        idx := ""

        for checkIndex, checkVal in arr {
            if (checkVal == val) {
                idx := checkIndex
                break
            }
        }

        return idx
    }
}
