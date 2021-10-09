class SteamOverlayAttachedCondition extends SteamConditionBase {
    __New(launchTime, app, negate := false) {
        children := []
        children.Push(FileModifiedAfterCondition(launchTime))
        children.Push(FileContainsCondition("GameOverlay process connecting to:"))
        super.__New(app, children, negate)
    }

    evaluateChildConditions(args*) {
        super.evaluateChildConditions([this.GetSteamPath(this.app) . "\GameOverlayUI.exe.log"])
    }

    EvaluateCondition(args*) {
        return true
    }
}
