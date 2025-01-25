import ExpoModulesCore

public class OnvoDrawingBoardModule: Module {
    public func definition() -> ModuleDefinition {
        Name("OnvoDrawingBoard")

        // Define the view component
        View(OnvoDrawingBoardView.self) {
            // Expose the qualityControl prop
            Prop("qualityControl") { (view: OnvoDrawingBoardView, quality: Double) in
                view.qualityControl = quality
            }

            // Expose the onDismiss event
            Events("onDismiss")
        }
    }
}