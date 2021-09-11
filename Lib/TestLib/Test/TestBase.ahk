class TestBase {
    results := Map()

    Setup() {
        ; Should be implemented
    }

    Run() {
        ; Should be implemented
        return true
    }

    Teardown() {
        ; Should be implemented
    }

    GetKey() {
        return Type(this)
    }

    GetResults() {
        return this.results
    }

    AssertTrue(taskName, value) {
        condition := (!!value)
        return this.Assertion(taskName, "Assert True", condition, "Value is true", "Value is not true")
    }

    AssertFalse(taskName, value) {
        condition := (!value)
        return this.Assertion(taskName, "Assert False", condition, "Value is false", "Value is not false")
    }

    AssertEquals(taskName, value1, value2) {
        condition := (value1 == value2)
        return this.Assertion(taskName, "Assert Equals", condition, "Values are equal", "Values are not equal")
    }

    AssertFileExists(taskName, path) {
        condition := (!!FileExist(path))
        return this.Assertion(taskName, "Assert File Exists", condition, "File exists", "File does not exist")
    }

    AssertFileDoesNotExist(taskName, path) {
        condition := (!FileExist(path))
        return this.Assertion(taskName, "Assert File Does Not Exist", condition, "File does not exist", "File exists")
    }

    Assertion(taskName, assertionName, condition, successMessage, failMessage) {
        success := !!condition
        message := assertionName . ": "
        message .= success ? successMessage : failMessage

        this.results[taskName] := Map("success", success, "message", message)
        return success
    }
}
