class OpStatusBase {
    started := false
    finished := false
    result := false
    hasResult := false
    hasErrors := false
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
            this.hasErrors := true
        }

        this.finished := true
    }

    SetResult(result) {
        result := result
        this.hasResult := true
    }

    IsFinished() {
        return this.finished
    }

    HasResult() {
        return this.hasResult
    }

    HasErrors() {
        return this.hasErrors
    }

    GetResult() {
        return this.result
    }

    AddError(err, code := "") {
        if (Type(err) == "Array") {
            for index, errItem in err {
                this.errors.push(errItem)
            }
        } else if (Type(err) == "String") {
            this.errors.push(BasicOpError.new(err, code))
        } else {
            this.errors.push(err)
        }

        
    }

    GetErrors() {
        return this.errors
    }
}
