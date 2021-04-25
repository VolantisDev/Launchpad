class SteamOverlayAttachedCondition extends SteamConditionBase {
    __New(launchTime, app, negate := false) {
        log := this.GetSteamPath(app) . "\GameOverlayUI.exe.log"

        children := []
        children.Push(FileModifiedAfterCondition(launchTime, log))
        children.Push(FileContainsCondition("GameOverlay process connecting to:", log))

        super.__New(app, children, negate)
    }
}
