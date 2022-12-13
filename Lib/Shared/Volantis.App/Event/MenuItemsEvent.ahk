class MenuItemsEvent extends EventBase {
    menuItemsObj := ""

    MenuItems {
        get => this.menuItemsObj
    }

    __New(eventName, menuItems := "") {
        if (!menuItems) {
            menuItems := []
        }

        this.menuItemsObj := menuItems
        super.__New(eventName)
    }
}
