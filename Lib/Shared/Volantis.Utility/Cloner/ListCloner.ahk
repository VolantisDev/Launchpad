class ListCloner extends ClonerBase {
    Clone(val) {
        if (HasBase(val, Map.Prototype)) {
            val := val.Clone()

            if (this.deep) {
                for key, mapVal in val {
                    val[key] := this.Clone(mapVal)
                }
            }
        } else if (HasBase(val, Array.Prototype)) {
            val := val.Clone()

            if (this.deep) {
                for index, arrayVal in val {
                    val[index] := this.Clone(arrayVal)
                }
            }
        }

        return val
    }
}
