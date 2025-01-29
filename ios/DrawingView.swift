import SwiftUI
import UIKit
import PencilKit
import Photos

#if canImport(UniformTypeIdentifiers)
import UniformTypeIdentifiers
#else
import MobileCoreServices
#endif

struct DrawingViewRepresentable: UIViewControllerRepresentable {
    @Binding var qualityControl: Double
    static var currentInstance: DrawingView?

    func makeUIViewController(context: Context) -> DrawingView {
        let drawingView = DrawingView(qualityControl: qualityControl)
        DrawingViewRepresentable.currentInstance = drawingView // Store the reference
        return drawingView
    }

    func updateUIViewController(_ uiViewController: DrawingView, context: Context) {
        // Update the view controller if needed
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue = CGFloat(b) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

class DrawingView: UIViewController, PKCanvasViewDelegate {
    var drawing = PKDrawing()
    var canvasView: PKCanvasView!
    var toolPicker: PKToolPicker!
    var isToolPickerVisible: Bool = true
    var buttonsContainer: UIView!
    var onDismiss: (() -> Void)?
    var savedDrawing: PKDrawing?
    var qualityGlobal: Double = 0.75
    private let patternView = UIView()

    init(qualityControl: Double){
        super.init(nibName: nil, bundle: nil) // This initializes the UIViewController
        self.qualityGlobal = qualityControl
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Main action button
    // Secondary buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        setupCanvasView()
        setupToolPicker()
        loadSavedDraws()
        patternView.backgroundColor = UIColor(patternImage: createTransparentPattern())
        patternView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(patternView, belowSubview: canvasView)
        NotificationCenter.default.addObserver(self,
                                                       selector: #selector(appDidEnterBackground),
                                                       name: UIApplication.didEnterBackgroundNotification,
                                                       object: nil)
    }
    
    @objc func appDidEnterBackground() {
        saveDrawingDraft()
    }
      
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    func saveDrawingDraft() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory.")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("savedDrawing.pkdrawing")
        
        do {
            let data = try canvasView.drawing.dataRepresentation()
            try data.write(to: fileURL)
            print("Drawing saved successfully to \(fileURL)")
        } catch {
            print("Failed to save drawing: \(error.localizedDescription)")
        }
    }
    
    func isDrawingTooSimple() -> Bool {
        let minimumStrokesThreshold = 5 // Set a threshold for the minimum number of strokes required
        let strokeCount = canvasView.drawing.strokes.count
        return strokeCount < minimumStrokesThreshold
    }

    func loadSavedDraws() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory.")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("savedDrawing.pkdrawing")
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                canvasView.drawing = try PKDrawing(data: data)
                print("Drawing loaded successfully from \(fileURL)")
            } catch {
                print("Failed to load drawing: \(error.localizedDescription)")
            }
        } else {
            print("No saved drawing found.")
        }
    }
    
    func wipeSavedDrawing() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Failed to get documents directory.")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("savedDrawing.pkdrawing")
        
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                try FileManager.default.removeItem(at: fileURL)
                print("Saved drawing wiped successfully.")
            } else {
                print("No saved drawing to wipe.")
            }
        } catch {
            print("Failed to wipe saved drawing: \(error.localizedDescription)")
        }
    }

    func setupCanvasView() {
        canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear
        canvasView.delegate = self
        canvasView.minimumZoomScale = 1.0
        canvasView.maximumZoomScale = 5.0
        canvasView.alwaysBounceVertical = true
        canvasView.drawingPolicy = .default
        canvasView.overrideUserInterfaceStyle = .light
        view.addSubview(canvasView)
    }
    
    func setupToolPicker() {
        toolPicker = PKToolPicker()
        toolPicker.setVisible(isToolPickerVisible, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        if #available(iOS 14.0, *) {
            toolPicker = PKToolPicker()
        } else {
            toolPicker = PKToolPicker.shared(for: view.window!)
        }
        toolPicker.overrideUserInterfaceStyle = .light // Force light mode
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        canvasView.becomeFirstResponder()
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func renderDrawingInLightModeAndRotate(drawing: PKDrawing, size: CGSize, isRotated: Bool) -> UIImage? {
        // Determine the rotated size
        let rotatedSize = isRotated ? CGSize(width: size.height, height: size.width) : size
        let renderer = UIGraphicsImageRenderer(size: rotatedSize, format: UIGraphicsImageRendererFormat.default())

        let image = renderer.image { context in
            context.cgContext.saveGState()

            // Set light mode rendering
            overrideUserInterfaceStyle = .light
            
            if isRotated {
                // Rotate context around the center of the image
                context.cgContext.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
                context.cgContext.rotate(by: .pi / 2)
                
                // Adjust the origin to the top-left of the rotated image
                context.cgContext.translateBy(x: -size.width / 2, y: -size.height / 2)
            }

            // Render the drawing without resizing
            let drawingImage = drawing.image(from: CGRect(origin: .zero, size: size), scale: UIScreen.main.scale)
            drawingImage.draw(in: CGRect(origin: .zero, size: size))

            context.cgContext.restoreGState()
        }

        return image
    }

var outletImage: Data? // Make it optional to avoid crashes if it's nil

func saveDrawing(uploadUrlString: String, uploadToken: String, completion: @escaping (String?) -> Void) {
    
           let imageSize = canvasView.bounds.size
        guard let renderedImageRotated = renderDrawingInLightModeAndRotate(drawing: canvasView.drawing, size: imageSize,isRotated: true) else {
               print("Failed to render drawing in light mode context.")
               return
           }
        
        guard let renderedImage = renderDrawingInLightModeAndRotate(drawing: canvasView.drawing, size: imageSize,isRotated: false) else {
               print("Failed to render drawing in light mode context.")
               return
           }
        
        guard let rawImage = renderedImageRotated.pngData() else {
               print("Failed to render drawing in light mode context.")
               return
           }
           outletImage = rawImage
        guard let compressedPngData = compressImage(renderedImageRotated) else {
               print("Failed to compress image to PNG data.")
               return
           }
        
        // Upload the PNG data
       ImageUploader.uploadImage((qualityGlobal == 1 ? rawImage : compressedPngData), toURL: uploadUrlString,user: "", token: uploadToken, viewController: self) { [weak self] responseText in
       completion(responseText)
    }
    }
    
func saveImageToPhotos() {
    PHPhotoLibrary.requestAuthorization { [weak self] status in
        guard let self = self else { return } // Unwrap `self` first

        switch status {
        case .authorized:
            DispatchQueue.main.async {
                guard let imageData = self.outletImage, let image = UIImage(data: imageData) else {
                    print("Failed to convert Data to UIImage or outletImage is nil.")
                    return
                }
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        case .denied, .restricted, .notDetermined, .limited:
            print("Permission to access photo library was denied or limited.")
        @unknown default:
            print("Unknown photo library authorization status.")
        }
    }
}


    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // Handle any errors
            let errorAlert = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(errorAlert, animated: true)
        } else {
            // Successfully saved the image
            let successAlert = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(successAlert, animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.forecClose()
            }
        }
    }
    
    func compressImage(_ image: UIImage,value: Double = 0.75) -> Data? {
        let options: [NSString: Any] = [
            kCGImageDestinationLossyCompressionQuality: value, // Adjust the compression quality (0.0 to 1.0)
        ]
        guard let imageData = image.pngData(), let source = CGImageSourceCreateWithData(imageData as CFData, nil) else {
            return nil
        }
        let mutableData = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(mutableData, UTType.png.identifier as CFString, 1, nil) else {
            return nil
        }
        CGImageDestinationAddImageFromSource(destination, source, 0, options as CFDictionary)
        CGImageDestinationFinalize(destination)
        return mutableData as Data
    }
    
    
    func showDrafts(){
        let alert = UIAlertController(title: "Comming soon", message: "You will have full access of your drafts in next updates, for now your work will be saved untill you export or save image", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func showUploadSuccessMessage() {
        // Call this function to update your UI upon successful upload
        // Example: Show an alert message
        let alert = UIAlertController(title: "Upload Successful", message: "Your drawing has been uploaded.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func toggleToolPickerVisibility() {
        // Toggle the visibility based on the flag
        isToolPickerVisible = !isToolPickerVisible
        toolPicker.setVisible(isToolPickerVisible, forFirstResponder: canvasView)
        if isToolPickerVisible {
            canvasView.becomeFirstResponder()
        }
    }
    
    func undoAction() {
        if canvasView.undoManager?.canUndo == true {
            canvasView.undoManager?.undo()
        }
    }
    
    func setAppAppearance(to style: UIUserInterfaceStyle) {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows.first {
            window.overrideUserInterfaceStyle = style
        }
    }
    
    func forecClose(){
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }) { _ in
            self.view.isHidden = true
            self.onDismiss?()
        }
        setAppAppearance(to: .light)
    }
        
    func redoAction() {
        if canvasView.undoManager?.canRedo == true {
            canvasView.undoManager?.redo()
        }
    }
    var isAdded: Bool = false
override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
        
        let estimatedToolPickerHeight: CGFloat = 100
        let availableHeight = view.bounds.height - estimatedToolPickerHeight
        let width = availableHeight / 2
        let canvasFrame = CGRect(
            x: (view.bounds.width - width) / 2,
            y: 0,
            width: width,
            height: availableHeight
        )
        
        canvasView.frame = canvasFrame

        // Set the frame of patternView to match canvasView but keep it outside the ScrollView
        patternView.frame = canvasFrame
        if(!isAdded){
        drawText(on: patternView)
            isAdded = true
        }

        // Draw text on the patternView if needed
    }
    func drawText(on view: UIView) {
        let text = "Drawing direction ->"
        let textColor = UIColor(hex: "#cccccc")
        let fontName = "Gilroy-Regular"
        let fontSize: CGFloat = 25
        let padding: CGFloat = 30

        // Create a label for the text
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: fontName, size: fontSize)
        label.textColor = textColor
        label.sizeToFit()

        // Create and add the image icon
        let iconImageView = UIImageView()
        if let iconImage = UIImage(named: "arrow_right")?.withRenderingMode(.alwaysTemplate) {
            iconImageView.image = iconImage
            iconImageView.tintColor = textColor
            iconImageView.frame.size = CGSize(width: 24, height: 24)
            iconImageView.contentMode = .scaleAspectFit
        }

        // Rotate the text and icon
        let rotationAngle = -CGFloat.pi / 2
        label.transform = CGAffineTransform(rotationAngle: rotationAngle)
        iconImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)

        // Calculate total height for both elements
        let totalHeight = label.frame.width + 5 + iconImageView.frame.height

        // Adjust the label and icon positions for left alignment
        let yPosition = (view.bounds.height - totalHeight) / 2
        label.frame.origin = CGPoint(x: padding, y: yPosition)
        iconImageView.frame.origin = CGPoint(x: padding, y: yPosition + label.frame.width - 50)

        // Create a container view and add the label and icon
        let containerView = UIView(frame: view.bounds)
        containerView.addSubview(label)
        containerView.addSubview(iconImageView)
        view.addSubview(containerView)
    }


    func createTransparentPattern() -> UIImage {
        let squareSize: CGFloat = 10 // Size of each square in the pattern
        let lightColor = UIColor(hex: "#ffffff") // Transparent background
        let darkColor = UIColor(hex: "#eeeeee") // Dark square color with the desired hex value

        let imageSize = CGSize(width: squareSize * 2, height: squareSize * 2)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)

        let context = UIGraphicsGetCurrentContext()!

        // Draw the light squares (transparent)
        context.setFillColor(lightColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: squareSize, height: squareSize))
        context.fill(CGRect(x: squareSize, y: squareSize, width: squareSize, height: squareSize))

        // Draw the dark squares
        context.setFillColor(darkColor.cgColor)
        context.fill(CGRect(x: squareSize, y: 0, width: squareSize, height: squareSize))
        context.fill(CGRect(x: 0, y: squareSize, width: squareSize, height: squareSize))

        let patternImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return patternImage!
    }
}
