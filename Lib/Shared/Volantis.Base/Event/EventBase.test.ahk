class EventBaseTest extends AppTestBase {
    TestEventName() {
        eventNames := [
            "Event Name 1",
            "EventName2",
            "3"
        ]

        for eventName in eventNames {
            testEvent := EventBase(eventName)

            this.AssertEquals(
                eventName,
                testEvent.EventName,
                "Event name is " . eventName
            )
        }
    }
}
