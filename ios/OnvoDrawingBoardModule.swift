import ExpoModulesCore

public class OnvoDrawingBoardModule: Module {
    public func definition() -> ModuleDefinition {
        Name("OnvoDrawingBoard")

        View(OnvoDrawingBoardView.self) {
            Prop("qualityControl") { (view: OnvoDrawingBoardView, quality: Double) in
                view.qualityControl = quality
            }

            Events("onDismiss")
        }
    }
}