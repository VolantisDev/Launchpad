class FileHasherTest extends TestBase {
    objInstance := ""

    CreateTestInstances() {
        this.objInstance := HasherBase()
    }

    TestHash() {
        ; @todo Test a known file against a known hash
    }
}
