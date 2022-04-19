class GuiRegion {
    static VALUE_TYPE_ABSOLUTE := "absolute"
    static VALUE_TYPE_OFFSET := "offset"
    static VALUE_TYPE_UNSET := "unset"

    valueMap := Map(
        "x", Map(
            "value", "",
            "type", "unset"
        ),
        "y", Map(
            "value", "",
            "type", "unset"
        ),
        "w", Map(
            "value", "",
            "type", "unset"
        ),
        "h", Map(
            "value", "",
            "type", "unset"
        )
    )

    X {
        get => this.GetValue("x")
        set => this.SetValue(value, "x")
    }

    Y {
        get => this.GetValue("y")
        set => this.SetValue(value, "y")
    }

    W {
        get => this.GetValue("w")
        set => this.SetValue(value, "w")
    }

    H {
        get => this.GetValue("h")
        set => this.SetValue(value, "h")
    }

    __New(x := "", y := "", w := "", h := "") {
        if (x != "") {
            this.SetValue(x, "x")
        }
        
        if (w != "") {
            this.SetValue(w, "w")
        }

        if (y != "") {
            this.SetValue(y, "y")
        }

        if (h != "") {
            this.SetValue(h, "h")
        }
    }

    SetValue(val, dimension) {
        valueType := GuiRegion.VALUE_TYPE_UNSET

        if (val) {
            if (InStr(val, "+") == 1) {
                valueType := GuiRegion.VALUE_TYPE_OFFSET
                val := SubStr(val, 2)
            } else if (InStr(val, "-") == 1) {
                valueType := GuiRegion.VALUE_TYPE_OFFSET
                val := SubStr(val, 2)
            } else {
                valueType := GuiRegion.VALUE_TYPE_ABSOLUTE
            }
        }

        if (dimension == "X" || dimension == "Y") {
            if (valueType == "offset") {
                existingType := this.valueMap[dimension]["type"]
                originalVal := this.valueMap[dimension]["value"]

                if (!originalVal) {
                    originalVal := 0
                }

                if (existingType == GuiRegion.VALUE_TYPE_OFFSET) {
                    val := originalVal + val
                } else if (existingType == GuiRegion.VALUE_TYPE_ABSOLUTE) {
                    val := originalVal + val
                    valueType := GuiRegion.VALUE_TYPE_ABSOLUTE
                }
            }
        } else if (dimension == "W" || dimension == "H") {
            if (valueType == "offset") {
                originalVal := this.valueMap[dimension]["value"]

                if (!originalVal) {
                    originalVal := 0
                }

                val := originalVal + val
                valueType := GuiRegion.VALUE_TYPE_ABSOLUTE
            }
        } else {
            throw EntityException("Cannot set value for unknown dimension " . dimension)
        }

        this.valueMap[dimension]["value"] := val
        this.valueMap[dimension]["type"] := valueType
    }

    GetValue(dimension) {
        val := ""

        if (dimension == "X" || dimension == "Y") {
            if (this.valueMap[dimension]["type"] == GuiRegion.VALUE_TYPE_ABSOLUTE) {
                val := this.valueMap[dimension]["value"]

                if (val < 0) {
                    val := 0
                }
            } else if (this.valueMap[dimension]["type"] == GuiRegion.VALUE_TYPE_OFFSET) {
                val := this.valueMap[dimension]["value"]

                if (val >= 0) {
                    val := "+" . val
                }
            }
        } else if (dimension == "W" || dimension == "H") {
            val := this.valueMap[dimension]["value"]

            if (val < 0) {
                val := 0
            }
        } else {
            throw EntityException("Invalid dimension " . dimension . " specified")
        }

        return val
    }

    SubtractMargin(margin, dimension := "") {
        if (!dimension) {
            this.SubtractMargin(margin, "X")
            this.SubtractMargin(margin, "Y")
        } else if (dimension == "X" || dimension == "Y") {
            otherDimension := dimension == "X" ? "W" : "H"
            val := this.valueMap[dimension]["value"]
            valueType := this.valueMap[dimension]["type"]
            otherVal := this.valueMap[otherDimension]["value"]
            otherType := this.valueMap[otherDimension]["type"]

            if (valueType == GuiRegion.VALUE_TYPE_ABSOLUTE || valueType == GuiRegion.VALUE_TYPE_OFFSET) {
                val := val + margin

                if (otherType != GuiRegion.VALUE_TYPE_UNSET) {
                    otherVal := otherVal - (margin * 2)
                }
            } else if (valueType == GuiRegion.VALUE_TYPE_UNSET) {
                val := margin
                valueType := GuiRegion.VALUE_TYPE_OFFSET
            } else {
                throw EntityException("Invalid value type specified")
            }

            this.valueMap[dimension]["value"] := val
            this.valueMap[dimension]["type"] := valueType

            if (otherType != GuiRegion.VALUE_TYPE_UNSET) {
                this.valueMap[otherDimension]["value"] := otherVal
                this.valueMap[otherDimension]["type"] := otherType
            }
        } else {
            throw EntityException("Margins should be added to the X or Y dimension")
        }

        return this
    }

    GetPositionString() {
        position := ""

        if (this.valueMap["x"]["type"] != GuiRegion.VALUE_TYPE_UNSET) {
            position := position . " x" . this.valueMap["x"]["value"]
        }

        if (this.valueMap["y"]["type"] != GuiRegion.VALUE_TYPE_UNSET) {
            position := position . " y" . this.valueMap["y"]["value"]
        }

        if (this.valueMap["w"]["type"] != GuiRegion.VALUE_TYPE_UNSET) {
            position := position . " w" . this.valueMap["w"]["value"]
        }

        if (this.valueMap["h"]["type"] != GuiRegion.VALUE_TYPE_UNSET) {
            position := position . " h" . this.valueMap["h"]["value"]
        }

        return position
    }
}
