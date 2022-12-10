class DirConditionBase extends FileConditionBase {
    Exists(path) {
        return DirExist(path)
    }
}
