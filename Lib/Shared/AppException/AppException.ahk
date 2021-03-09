class AppException {
    innerException := {Message: "", What: "", Extra: "", File: "", Line: ""}

    Message {
        get => this.innerException.Message
    }

    What {
        get => this.innerException.What
    }

    Extra {
        get => this.innerException.HasProp("Extra") ? this.innerException.Extra : ""
    }

    File {
        get => this.innerException.File
    }

    Line {
        get => this.innerException.Line
    }

    __New(message, what := "", extra := "") {
        if (!what) {
            what := -2
        } else if (IsNumber(what)) {
            what -= 1
        }
        this.innerException := Exception(message, what, extra)
    }

    GetException() {
        return this.innerException
    }
}
