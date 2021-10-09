class AppComponentManagerBase extends ComponentManagerBase {
    notifierObj := ""

    __New(container, eventMgr, notifierObj, servicePrefix, componentType, definitionLoader := "", autoLoad := true) {
        this.notifierObj := notifierObj

        super.__New(
            container,
            servicePrefix,
            eventMgr,
            componentType,
            definitionLoader,
            autoLoad
        )
    }
}
