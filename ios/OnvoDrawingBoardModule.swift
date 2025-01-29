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

        Function("saveImageToPhotos") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.saveImageToPhotos()
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
        Function("isDrawingTooSimple") {
            DispatchQueue.main.async {
                if let drawingView = DrawingViewRepresentable.currentInstance {
                    drawingView.isDrawingTooSimple()
                }
            }
        }
        
AsyncFunction("saveDrawing") { (uploadUrlString: String, uploadToken: String) async throws -> String in
    return try await withCheckedThrowingContinuation { continuation in
        DispatchQueue.main.async {
            if let drawingView = DrawingViewRepresentable.currentInstance {
                drawingView.saveDrawing(uploadUrlString: uploadUrlString, uploadToken: uploadToken) { responseText in
                    if let responseText = responseText {
                        continuation.resume(returning: responseText)
                    } else {
                        continuation.resume(throwing: NSError(domain: "UPLOAD_FAILED", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to upload drawing"]))
                    }
                }
            } else {
                continuation.resume(throwing: NSError(domain: "NO_DRAWING_VIEW", code: 2, userInfo: [NSLocalizedDescriptionKey: "No drawing view found"]))
            }
        }
    }
}


    }
}