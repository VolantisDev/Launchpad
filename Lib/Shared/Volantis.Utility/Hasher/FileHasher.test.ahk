class FileHasherTest extends TestBase {
    objInstance := ""

    Setup() {
        this.objInstance := HasherBase()
        ; super.Setup()
    }

    RunTestSteps() {
        this.TestHash()
    }

    TestHash() {
        this.TestMethod := "Hash"
        ; @todo Test a known file against a known hash
        this.TestMethod := ""
    }

    Teardown() {
        ; super.Teardown()
    }
}
