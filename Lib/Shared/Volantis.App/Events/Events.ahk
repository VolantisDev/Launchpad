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

    static APP_POST_STARTUP := 0x1002
    static APP_SERVICES_LOADED := 0x1003
    static APP_SERVICE_DEFINITIONS := 0x1005
    static APP_PRE_INITIALIZE := 0x1010
    static APP_POST_INITIALIZE := 0x1011
    static APP_PRE_RUN := 0x1015
    static APP_SHUTDOWN := 0x1020
    static APP_RESTART := 0x1025

    static MODULES_DISCOVER := 0x2040
    static MODULES_DISCOVER_ALTER := 0x2042
    static MODULE_LOAD := 0x2045
    static MODULE_LOAD_ALTER := 0x2047

    static BACKUPS_REGISTER := 0x2070
    static BACKUPS_ALTER := 0x2075

    static AHK_NOTIFYICON := 0x404
}
