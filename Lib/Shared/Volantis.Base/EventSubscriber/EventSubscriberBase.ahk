/*
    Extending this class is optional as its main purpose is to document the API
*/
class EventSubscriberBase {
    /*
        Format:
        Map(
            Events.EVENT_NAME, [
                ObjBindMethod(this, "HandlerMethod"),
                ObjBindMethod(this, "HandlerMethod2")
            ]
        )
    */
    GetEventSubscribers() {
        return []
    }
}
