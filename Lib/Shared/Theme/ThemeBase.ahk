class ThemeBase {
    appDir := ""

    logoSrc := this.appDir . "\Graphics\Logo.png"

    mainWindowContentW := 515
    mainWindowButtonAreaW := 430

    controlSpacing := 10
    mainWindowContentMargin := 40

    hugeButtonH := 80
    bigButtonH := 40
    normalButtonH := 30
    smallButtonH := 20
    smallFixedButtonW := 80

    smallLabelW := 75

    backgroundColor := "FFFFFF"
    textColor := "000000"
    lightTextColor := "959595"
    accentColor := "9466FC"
    accentLightColor := "EEE6FF"
    accentDarkColor := "8A57F0"

    mainWindowOptions := ""
    normalWindowOptions := ""
    dialogWindowOptions := ""

    normalFontSize := 11
    smallFontSize := 9
    largeFontSize := 13

    __New(appDir) {
        this.appDir := appDir
    }
}
