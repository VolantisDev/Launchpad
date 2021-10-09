class AppComponentManagerBase extends ComponentManagerBase {
    __New(container, eventMgr, notifierObj, servicePrefix, componentType, definitionLoader := "", autoLoad := true) {
        super.__New(
            container,
            servicePrefix,
            eventMgr,
            notifierObj,
            componentType,
            definitionLoader,
            autoLoad
        )
    }
}
