class OpStatusBase {
    started := false
    finished := false
    result := false
    hasResultVal := false
    hasErrorsVal := false
    errors := Array()

    /**
    * IMPLEMENTED METHODS
    */

    Start() {
        this.started := true
    }

    Finish(result := "", err := "", errCode := "") {
        if (!this.started) {
            this.Start()
        }

        if (result != "") {
            this.SetResult(result)
        }

        if (err != "") {
            this.AddError(err, errCode)
        }

        if (this.errors.Length > 0) {
            this.hasErrorsVal := true
        }

        this.finished := true
    }

    SetResult(result) {
        result := result
        this.hasResultVal := true
    }

    IsFinished() {
        return this.finished
    }

    HasResult() {
        return this.hasResultVal
    }

    HasErrors() {
        return this.hasErrorsVal
    }

    GetResult() {
        return this.result
    }

    AddError(err, code := "") {
        if (HasBase(err, Array.Prototype)) {
            for index, errItem in err {
                this.errors.push(errItem)
            }
        } else if (Type(err) == "String") {
            this.errors.push(BasicOpError(err, code))
        } else {
            this.errors.push(err)
        }

        
    }

    GetErrors() {
        return this.errors
    }
}
