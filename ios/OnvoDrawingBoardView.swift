import ExpoModulesCore
import SwiftUI

public class OnvoDrawingBoardView: ExpoView {
    private var hostingController: UIHostingController<DrawingViewRepresentable>?

    var qualityControl: Double = 0.75 {
        didSet {
            updateView()
        }
    }

    var onDismiss: (() -> Void)? {
        didSet {
            updateView()
        }
    }

    required init(appContext: AppContext? = nil) {
        super.init(appContext: appContext)
        setupHostingController()
    }

    private func setupHostingController() {
        let drawingView = DrawingViewRepresentable(
            qualityControl: Binding(
                get: { self.qualityControl },
                set: { newValue in
                    self.qualityControl = newValue
                }
            )
        )

        let hostingController = UIHostingController(rootView: drawingView)
        hostingController.view.frame = self.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(hostingController.view)

        self.hostingController = hostingController
    }

    private func updateView() {
        guard let hostingController = hostingController else { return }
        hostingController.rootView = DrawingViewRepresentable(
            qualityControl: Binding(
                get: { self.qualityControl },
                set: { newValue in
                    self.qualityControl = newValue
                }
            )
        )
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        hostingController?.view.frame = self.bounds
    }
}