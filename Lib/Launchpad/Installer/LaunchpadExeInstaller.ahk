class LaunchpadExeInstaller extends InstallerBase {
    name := "Launchpad.exe Installer"
    movedApp := false
    version := "latest"
    isUpdater := false

    __New(appState, cache, tmpDir := "") {
        SplitPath(A_ScriptFullPath,,,,scriptNameNoExt)
        this.isUpdater := scriptNameNoExt == this.appName . "Updater"

        components := []

        if (this.isUpdater) {
            component := GitHubReleaseInstallerComponent.new("VolantisDev/Launchpad", this.appName . ".exe", false, "", appState, "LaunchpadExe", cache, this.appName, true, tmpDir, true)
            component.version := this.version
            components.Push(component)
        }

        super.__New(appState, "LaunchpadExeInstaller", cache, components, tmpDir)
    }

    Install(progress := "") {
        if (!this.isUpdater and A_IsCompiled) {
            installDir := this.DetermineInstallDir()

            if (installDir != this.scriptDir) {
                MsgBox("Launchpad will now be copied to the folder you've selected.")
                DirCreate(installDir)
                FileCopy(A_ScriptFullPath, installDir . "\Launchpad.exe", true)
                this.movedApp := true
                this.scriptDir := installDir

                for (index, component in this.installerComponents) {
                    component.scriptDir := installDir
                }
            }
        }

        result := super.Install(progress)

        if (this.movedApp) {
            createShortcut := MsgBox("Launchpad.exe has been installed to " . this.scriptDir . ". Would you like to create a desktop shortcut?", "Launchpad Install Shortcut", "YesNo")

            if (createShortcut) {
                FileCreateShortcut(this.scriptDir . "\Launchpad.exe", A_Desktop . "\Launchpad.lnk", this.scriptDir, "", "Manage and build game launchers", this.scriptDir . "\Launchpad.exe")
            }

            MsgBox("Initial installation finished. Please run Launchpad from the installation folder to complete the setup process.")
            ; @todo Notify user that the app is going to restart before continuing
            ; @todo schedule the new Launchpad.exe to start after a couple of seconds
            ExitApp 0
        }

        ; offer to create a desktop shortcut

        return result
    }

    DetermineInstallDir() {
        installDir := ""

        if (FileExist(this.scriptDir . "\Launchpad.ini")) {
            installDir := this.scriptDir
        }

        if (installDir == "") {
            installDir := this.PromptForInstallDir()
        }

        return installDir
    }

    PromptForInstallDir() {
        inCorrectDir := MsgBox("Would you like to install Launchpad.exe to the current folder? Clicking No will allow you to choose a different folder.", "Launchpad Install Folder", "YesNo")

        dir := this.scriptDir


        if (inCorrectDir == "No") {
            dir := DirSelect("*" . this.scriptDir, 3, "Select the folder you would like to install Launchpad to.")
        }
        
        return dir
        ; @todo make this a nicer prompt
    }
}
