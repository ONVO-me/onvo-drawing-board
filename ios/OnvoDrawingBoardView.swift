import ExpoModulesCore
import UIKit

class OnvoDrawingBoardView: ExpoView {
    private var drawingViewController: DrawingView?

    var qualityControl: Double = 0.75 {
        didSet {
            drawingViewController?.qualityGlobal = qualityControl
        }
    }

    var onDismiss: (() -> Void)? {
        didSet {
            drawingViewController?.onDismiss = onDismiss
        }
    }

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        setupDrawingView()
    }

    private func setupDrawingView() {
        // Initialize the DrawingView (UIViewController)
        drawingViewController = DrawingView(qualityControl: qualityControl)

        // Set the onDismiss handler
        drawingViewController?.onDismiss = { [weak self] in
            self?.onDismiss?()
        }

        // Add the DrawingView's view as a subview
        if let drawingView = drawingViewController?.view {
            drawingView.frame = self.bounds
            drawingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(drawingView)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        drawingViewController?.view.frame = self.bounds
    }
}