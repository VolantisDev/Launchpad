class UuidGeneratorTest extends AppTestBase {
    objInstance := ""

    CreateTestInstances() {
        this.objInstance := UuidGenerator()
    }

    TestGenerate() {
        this.AssertNotEmpty(
            this.objInstance.Generate(),
            "UUID is not empty"
        )
    }
}
