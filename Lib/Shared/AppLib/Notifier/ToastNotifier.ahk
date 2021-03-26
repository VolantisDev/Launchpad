class ToastNotifier extends NotifierBase {
    Notify(message, title := "", level := "info") {
        if (title == "") {
            title := "Launchpad"
        }

        options := 17 ; @todo Update according to level
        TrayTip(message, title, options)
    }
}
