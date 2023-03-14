/**
 * All event objects should extend from this class or a descendent of this class and use it share
 * data with event subscribers, which can read and sometimes alter the event object's properties.
 */
class EventBase {
    _eventName := ""

    EventName {
        get => this._eventName
    }

    __New(eventName) {
        this._eventName := eventName
    }
}
