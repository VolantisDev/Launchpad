class UuidGeneratorTest extends TestBase {
    objInstance := ""

    CreateTestInstances() {
        this.objInstance := UuidGenerator()
    }

    TestGenerate() {
        this.AssertNotEquals(
            this.objInstance.Generate(),
            "",
            "UUID is not empty"
        )
    }
}
