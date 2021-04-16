class SteamOverlayAttachedCondition extends SteamConditionBase {
    __New(launchTime, app, negate := false) {
        log := this.GetSteamPath(app) . "\GameOverlayUI.exe.log"

        children := []
        children.Push(FileModifiedAfterCondition.new(launchTime, log))
        children.Push(FileContainsCondition.new("GameOverlay process connecting to:", log))

        super.__New(app, childConditions, negate)
    }
}
