class SteamOverlayAttachedCondition extends SteamConditionBase {
    __New(launchTime, app, negate := false) {
        logObj := this.GetSteamPath(app) . "\GameOverlayUI.exe.log"

        children := []
        children.Push(FileModifiedAfterCondition(launchTime, logObj))
        children.Push(FileContainsCondition("GameOverlay process connecting to:", logObj))

        super.__New(app, children, negate)
    }
}
