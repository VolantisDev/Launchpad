class Bnetlauncher extends Dependency {
    name := "Bnetlauncher"
    mainFile := "bnetlauncher.exe"
    url := "https://github.com/dafzor/bnetlauncher/releases/download/v2.02/bnetlauncher_v202.zip"
    downloadFile := "bnetlauncher.zip"

    Download() {
        base.Download()

        gamesDb := this.path . "\gamesdb.ini"
        if (!FileExist(gamesDb)) {
            FileCopy, %gamesDb%.example, %gamesDb%, 1
        }
    }
}
