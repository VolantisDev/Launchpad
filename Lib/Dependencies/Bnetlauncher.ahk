class Bnetlauncher extends Dependency {
    name := "Bnetlauncher"
    mainFile := "bnetlauncher.exe"
    url := "https://github.com/dafzor/bnetlauncher/releases/download/v2.09/bnetlauncher_v209.zip"
    downloadFile := "bnetlauncher.zip"

    Download() {
        base.Download()

        gameDbSource := this.appDir . "\Data\gamedb.ini"
        gameDb := this.path . "\gamedb.ini"
        FileCopy, %gameDbSource%, %gameDb%, 1
    }
}
