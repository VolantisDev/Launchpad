class UuidGeneratorTest extends TestBase {
    objInstance := ""

    Setup() {
        this.objInstance := UuidGenerator()
        ;super.Setup()
    }

    RunTestSteps() {
        this.TestGenerate()
    }

    TestGenerate() {
        this.TestMethod := "Generate"

        this.AssertNotEquals(
            this.objInstance.Generate(),
            "",
            "UUID is not empty"
        )

        this.TestMethod := ""
    }

    Teardown() {
        ;super.Teardown()
    }
}
