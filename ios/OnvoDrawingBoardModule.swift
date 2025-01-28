import ExpoModulesCore

public class OnvoDrawingBoardModule: Module {
    // Singleton instance of DrawingView

    public func definition() -> ModuleDefinition {
        Name("OnvoDrawingBoard")

        View(OnvoDrawingBoardView.self) {
            Prop("qualityControl") { (view: OnvoDrawingBoardView, quality: Double) in
                view.qualityControl = quality
            }

            Events("onDismiss")
        }


        Function("undoAction") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.undoAction()
                }
            }
        }

        Function("redoAction") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.redoAction()
                }
            }
        }

        Function("showDrafts") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.showDrafts()
                }
            }
        }

        Function("toggleToolPickerVisibility") {
             DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.toggleToolPickerVisibility()
                }
            }
        }

        Function("wipeSavedDrawing") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.wipeSavedDrawing()
                }
            }
        }

        Function("saveDrawingDraft") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.saveDrawingDraft()
                }
            }
        }
        Function("saveDrawing") { (uploadUrlString: String) in
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.saveDrawing(uploadUrlString: uploadUrlString)
                }
            }
        }
    }
}