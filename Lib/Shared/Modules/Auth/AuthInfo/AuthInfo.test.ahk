class AuthInfoTest extends AppTestBase {
    TestAuthenticated() {
        authInfoObj := AuthInfo()

        authInfoObj.isAuthenticated := false

        this.AssertFalse(
            authInfoObj.Authenticated,
            "Test setting isAuthenticated to false"
        )

        authInfoObj.Authenticated := true

        this.AssertTrue(
            authInfoObj.Authenticated,
            "Test changing Authenticated to true"
        )
    }

    TestUserId() {
        authInfoObj := AuthInfo()
        
        this.AssertEquals(
            "",
            authInfoObj.UserId,
            "Assert that user ID is blank initially"
        )

        userIds := [
            123,
            "456",
            "1234-5678-9012-3456",
            "r@nd0m"
        ]

        for userId in userIds {
            authInfoObj.Set(authInfoObj.userIdField, userId)

            this.AssertEquals(
                userId,
                authInfoObj.UserId,
                "Test changing user ID to " . userId
            )
        }
    }

    TestGet() {
        authInfoObj := AuthInfo()

        this.AssertEmpty(
            authInfoObj.Get("nonexistantValue"),
            "Getting a non-existent value returns an empty string"
        )

        authInfoObj.Set("testValue", "persistent", true)

        this.AssertEquals(
            "persistent",
            authInfoObj.Get("testValue"),
            "Getting a persistent value is possible"
        )

        authInfoObj.Set("testValue", "overridden", false)

        this.AssertEquals(
            "overridden",
            authInfoObj.Get("testValue"),
            "Getting a secure value overrides a persistent one"
        )
    }

    TestSet() {
        authInfoObj := AuthInfo()
        
        authInfoObj.Set("testValue", "persistent", true)

        this.AssertEquals(
            "persistent",
            authInfoObj.Get("testValue"),
            "Setting a persistent value is possible"
        )

        authInfoObj.Set("testValue", "overridden", false)

        this.AssertEquals(
            "overridden",
            authInfoObj.Get("testValue"),
            "Setting a secure value overrides a persistent one"
        )
    }

    TestGetPersistentData() {
        persistentData := Map("testValue", "persistent")
        authInfoObj := AuthInfo()
        authInfoObj.persistentData := persistentData

        this.AssertEquals(
            persistentData,
            authInfoObj.GetPersistentData(),
            "GetPersistentData returns all persistent data"
        )
    }
}
