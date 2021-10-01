class Debugger {
    logger := ""

    __New(logger := "") {
        this.logger := logger
    }

    SetLogger(logger) {
        if (logger is LoggerService) {
            this.logger := logger
        } else {
            throw AppException("Invalid logger provided: " . Type(logger))
        }
    }

    Inspect(var) {
        message := this.ToString(var)
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
        valType := Type(val)
        output := ""

        if (IsObject(val)) {
            indent := this.GetIndent(level, indentStr)
            output := !innerValue ? indent : ""
            
            if (level > 2) {
                output .= valType . "`n"
            } else {
                output .= valType . "{`n"

                if (valType == "Array") {
                    for index, value in val {
                        output .= indent . indentStr . index . ": " . this.ToString(value, level + 1, indentStr, true) . "`n"
                    }
                } else if (valType == "Map") {
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
        } else {
            output := val
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
