class Debugger {
    logger := ""
    maxLevels := ""

    __New(logger := "", maxLevels := 2) {
        this.logger := logger
        this.maxLevels := maxLevels
    }

    SetLogger(logger) {
        if (logger is LoggerService) {
            this.logger := logger
        } else {
            throw AppException("Invalid logger provided: " . Type(logger))
        }
    }

    Inspect(var, params*) {
        message := this.ToString(var)

        if (params && params.Length) {
            for index, paramVar in params {
                paramStr := this.ToString(paramVar)

                if (paramStr) {
                    message .= "`n`n" . paramStr
                }
            }
        }

        if (A_IsCompiled) {
            this.LogMessage(message)
        } else {
            this.ShowMessage(message)
        }
    }

    ShowMessage(message) {
        MsgBox(message, "Debugger")
    }

    LogMessage(message) {
        if (this.logger) {
            this.logger.Debug(message)
        }
    }
    
    ToString(val, level := 0, indentStr := "`t", innerValue := false) {
        output := ""

        if (IsObject(val)) {
            indent := this.GetIndent(level, indentStr)
            output := !innerValue ? indent : ""
            
            if (level > this.maxLevels) {
                output .= Type(val) . "`n"
            } else {
                output .= Type(val) . "{`n"

                if (HasBase(val, Array.Prototype)) {
                    for index, value in val {
                        output .= indent . indentStr . index . ": " . this.ToString(value, level + 1, indentStr, true) . "`n"
                    }
                } else if (HasBase(val, Map.Prototype)) {
                    for key, value in val {
                        output .= indent . indentStr . key . ": " . this.ToString(value, level + 1, indentStr, true) . "`n"
                    }
                } else {
                    for name, value in val.OwnProps() {
                        output .= indent . indentStr . name . ": " . this.ToString(value, level + 1, indentStr, true) . "`n"
                    }
                }

                output .= indent . "}"
            }

            if (!innerValue) {
                output .= "`n"
            }
        } else if (Type(val) == "String") {
            output := "`"" . Trim(val, "`"") . "`""
        } else {
            output := Type(val) . ": " . val
        }

        if (output == "") {
            output := "<emptry string>"
        }

        return output
    }

    GetIndent(level := 0, indentStr := "`t") {
        indent := ""

        if (level > 0) {
            Loop level {
                indent .= indentStr
            }
        }

        return indent
    }
}
