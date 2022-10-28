class AssertableBase {
    results := []
    testSuccess := true

    AssertTrue(value, description := "") {
        return this.Assertion(
            "Assert True", 
            (!!value), 
            description, 
            Map("Value", value)
        )
    }

    AssertFalse(value, description := "") {
        return this.Assertion(
            "Assert False", 
            (!value), 
            description, 
            Map("Value", value)
        )
    }

    AssertEquals(value1, value2, description := "") {
        return this.Assertion(
            "Assert Equals", 
            (value1 == value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertEmpty(value, description := "") {
        return this.Assertion(
            "Assert Empty",
            (value == ""),
            description,
            Map("Value", value)
        )
    }

    AssertNotEmpty(value, description := "") {
        isNotEmpty := (value)

        if (HasBase(value, Array.Prototype)) {
            isNotEmpty := (value.Length > 0)
        } else if (HasBase(value, Map.Prototype)) {
            isNotEmpty := (value.Size > 0)
        }

        return this.Assertion(
            "Assert Not Empty",
            !!isNotEmpty,
            description,
            Map("Value", value)
        )
    }

    AssertNotEquals(value1, value2, description := "") {
        return this.Assertion(
            "Assert Not Equals", 
            (value1 != value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertGreaterThan(value1, value2, description := "") {
        return this.Assertion(
            "Assert Greater Than", 
            (value1 > value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertLessThan(value1, value2, description := "") {
        return this.Assertion(
            "Assert Less Than", 
            (value1 < value2), 
            description, 
            Map(
                "Value 1", value1, 
                "Value 2", value2
            )
        )
    }

    AssertFileExists(path, description := "") {
        return this.Assertion(
            "Assert File Exists", 
            (!!FileExist(path)), 
            description, 
            Map("Path", path)
        )
    }

    AssertFileDoesNotExist(path, description := "") {
        return this.Assertion(
            "Assert File Does Not Exist", 
            (!FileExist(path)), 
            description, 
            Map("Path", path)
        )
    }

    Assertion(assertionName, condition, description := "", data := "") {
        success := !!condition

        this.results.Push(Map(
            "success", success, 
            "method", this.TestMethod, 
            "assertion", assertionName, 
            "data", data, 
            "description", description
        ))

        if (!success) {
            this.testSuccess := false
        }

        return success
    }
}
