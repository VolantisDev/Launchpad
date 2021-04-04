class Events {
    static WM_NCHITTEST := 0x84
    static WM_NCCALCSIZE := 0x83
    static WM_NCACTIVATE := 0x86

    static MOUSE_MOVE := 0x200
    static MOUSE_LEFT_DOWN := 0x201
    static MOUSE_LEFT_UP := 0x202
    static MOUSE_CLICK := 0x203
    static MOUSE_RIGHT_DOWN := 0x204
    static MOUSE_RIGHT_UP := 0x205

    static APP_STARTUP := 0x1001
    static APP_SHUTDOWN := 0x1010

    static CACHES_REGISTER := 0x2010
    static CACHES_ALTER := 0x2015

    static INSTALLERS_REGISTER := 0x2020
    static INSTALLERS_ALTER := 0x2025

    static THEMES_REGISTER := 0x2050
    static THEMES_ALTER := 0x2055

    static WINDOWS_REGISTER := 0x2060
    static WINDOWS_ALTER := 0x2065

    static BACKUPS_REGISTER := 0x2070
    static BACKUPS_ALTER := 0x2075

    static DATASOURCES_REGISTER := 0x3000
    static DATASOURCES_ALTER := 0x3005

    static AHK_NOTIFYICON := 0x404
}
