import SwiftUI
import UIKit
import Vision

extension Notification.Name {
    static let pathReady = Notification.Name("pathReady")
}

struct MagicWandTextSelector: UIViewControllerRepresentable {
    let image: UIImage
    @Binding var selectedText: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> MagicWandViewController {
        let viewController = MagicWandViewController(image: image)
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MagicWandViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MagicWandViewControllerDelegate {
        let parent: MagicWandTextSelector
        
        init(_ parent: MagicWandTextSelector) {
            self.parent = parent
        }
        
        func magicWandViewController(_ controller: MagicWandViewController, didSelectText text: String) {
            print("🎯 Coordinator received delegate call with text: '\(text)'")
            print("📝 Setting parent.selectedText to: '\(text)'")
            parent.selectedText = text
            print("🚪 Calling parent.dismiss()")
            parent.dismiss()
            print("✅ Dismiss called successfully")
        }
        
        func magicWandViewControllerDidCancel(_ controller: MagicWandViewController) {
            parent.dismiss()
        }
    }
}

protocol MagicWandViewControllerDelegate: AnyObject {
    func magicWandViewController(_ controller: MagicWandViewController, didSelectText text: String)
    func magicWandViewControllerDidCancel(_ controller: MagicWandViewController)
}

class MagicWandViewController: UIViewController {
    private let image: UIImage
    weak var delegate: MagicWandViewControllerDelegate?
    
    private let imageView = UIImageView()
    private let drawingView = DrawingView()
    private let selectionOverlayView = SelectionOverlayView()
    private let selectTextButton = UIButton(type: .system)
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupNotifications()
        
        // Ensure navigation bar is visible
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup image view
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Setup drawing view for finger input
        drawingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(drawingView)
        
        // Setup selection overlay
        selectionOverlayView.translatesAutoresizingMaskIntoConstraints = false
        selectionOverlayView.isHidden = true
        view.addSubview(selectionOverlayView)
        
        // Setup fallback select text button
        selectTextButton.setTitle("Select Text", for: .normal)
        selectTextButton.setTitleColor(.white, for: .normal)
        selectTextButton.backgroundColor = UIColor.systemBlue
        selectTextButton.layer.cornerRadius = 16
        selectTextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        selectTextButton.addTarget(self, action: #selector(selectTextTapped), for: .touchUpInside)
        selectTextButton.translatesAutoresizingMaskIntoConstraints = false
        selectTextButton.isHidden = true // Initially hidden
        
        // Add subtle shadow for modern look
        selectTextButton.layer.shadowColor = UIColor.black.cgColor
        selectTextButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectTextButton.layer.shadowRadius = 8
        selectTextButton.layer.shadowOpacity = 0.15
        
        view.addSubview(selectTextButton)
        
        print("🔘 Fallback button setup complete")
        print("🔘 Button target: \(selectTextButton.allTargets)")
        print("🔘 Button actions: \(selectTextButton.actions(forTarget: self, forControlEvent: .touchUpInside) ?? [])")
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            drawingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            drawingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            drawingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            drawingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            selectionOverlayView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            selectionOverlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectionOverlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectionOverlayView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            

            
            selectTextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectTextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            selectTextButton.widthAnchor.constraint(equalToConstant: 200),
            selectTextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNavigationBar() {
        // Ensure navigation bar is visible and styled
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Select Text",
            style: .done,
            target: self,
            action: #selector(selectTextTapped)
        )
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        // Add magic wand button
        let magicWandButton = UIBarButtonItem(
            image: UIImage(systemName: "wand.and.stars"),
            style: .plain,
            target: self,
            action: #selector(magicWandTapped)
        )
        navigationItem.rightBarButtonItems?.append(magicWandButton)
        
        print("🔧 Navigation bar setup complete")
        print("🔘 Left button: \(navigationItem.leftBarButtonItem?.title ?? "nil")")
        print("🔘 Right button: \(navigationItem.rightBarButtonItem?.title ?? "nil")")
        print("🔘 Right button enabled: \(navigationItem.rightBarButtonItem?.isEnabled ?? false)")
    }
    
    private func setupNotifications() {
        print("🔔 Setting up notification observer for .pathReady")
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(pathReady),
            name: .pathReady,
            object: nil
        )
        print("✅ Notification observer set up successfully")
    }
    
    @objc private func pathReady() {
        print("🎯 Path ready notification received!")
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        // Show fallback button with animation
        selectTextButton.isHidden = false
        selectTextButton.backgroundColor = UIColor.systemGreen
        
        // Add subtle scale animation
        selectTextButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.selectTextButton.transform = CGAffineTransform.identity
        })
        
        print("✅ Select Text button enabled: \(navigationItem.rightBarButtonItem?.isEnabled ?? false)")
        print("🔘 Fallback button visible: \(!selectTextButton.isHidden)")
    }
    
    @objc private func cancelTapped() {
        delegate?.magicWandViewControllerDidCancel(self)
    }
    
    @objc private func selectTextTapped() {
        print("🔘 Select Text button tapped!")
        print("🎨 Current path exists: \(drawingView.currentPath != nil)")
        
        guard let path = drawingView.currentPath else { 
            print("❌ No path available")
            return 
        }
        
        print("✅ Path found, processing selected area...")
        
        // Process the selected area and directly call delegate
        processSelectedAreaAndDismiss(path: path)
    }
    
    @objc private func magicWandTapped() {
        // Auto-detect text areas and suggest selection
        autoDetectTextAreas()
    }
    
    private func autoDetectTextAreas() {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            DispatchQueue.main.async {
                self?.showTextAreaSuggestions(observations: observations)
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    private func showTextAreaSuggestions(observations: [VNRecognizedTextObservation]) {
        // Show suggested text areas for easy selection
        selectionOverlayView.showTextAreas(observations)
        selectionOverlayView.isHidden = false
    }
    
    private func processSelectedAreaAndDismiss(path: UIBezierPath) {
        print("🔍 Processing selected area and will dismiss...")
        
        // Get the path bounds in view coordinates
        let pathBounds = path.bounds
        print("📐 Path bounds in view: \(pathBounds)")
        
        // Get the actual image display area within the imageView
        let imageViewBounds = imageView.bounds
        let imageSize = image.size
        
        // Calculate how the image is displayed within the imageView
        let imageAspectRatio = imageSize.width / imageSize.height
        let viewAspectRatio = imageViewBounds.width / imageViewBounds.height
        
        var imageFrameInView: CGRect
        
        if imageAspectRatio > viewAspectRatio {
            // Image is wider than view, so it's scaled to fit width
            let scale = imageViewBounds.width / imageSize.width
            let height = imageSize.height * scale
            let y = (imageViewBounds.height - height) / 2
            imageFrameInView = CGRect(x: 0, y: y, width: imageViewBounds.width, height: height)
        } else {
            // Image is taller than view, so it's scaled to fit height
            let scale = imageViewBounds.height / imageSize.height
            let width = imageSize.width * scale
            let x = (imageViewBounds.width - width) / 2
            imageFrameInView = CGRect(x: x, y: 0, width: width, height: imageViewBounds.height)
        }
        
        print("🖼️ Image frame in view: \(imageFrameInView)")
        
        // Convert path coordinates relative to the image frame
        let relativeX = (pathBounds.origin.x - imageFrameInView.origin.x) / imageFrameInView.width
        let relativeY = (pathBounds.origin.y - imageFrameInView.origin.y) / imageFrameInView.height
        let relativeWidth = pathBounds.width / imageFrameInView.width
        let relativeHeight = pathBounds.height / imageFrameInView.height
        
        // Ensure coordinates are within bounds
        let clampedX = max(0, min(1, relativeX))
        let clampedY = max(0, min(1, relativeY))
        let clampedWidth = max(0, min(1 - clampedX, relativeWidth))
        let clampedHeight = max(0, min(1 - clampedY, relativeHeight))
        
        // Convert to image coordinates
        let imageRect = CGRect(
            x: clampedX * imageSize.width,
            y: clampedY * imageSize.height,
            width: clampedWidth * imageSize.width,
            height: clampedHeight * imageSize.height
        )
        
        print("🖼️ Final image selection rect: \(imageRect)")
        
        // Crop the image to the selected area
        if let croppedImage = cropImage(image, to: imageRect) {
            print("✅ Image cropped successfully to size: \(croppedImage.size)")
            recognizeTextFromImageAndDismiss(croppedImage)
        } else {
            print("❌ Failed to crop image")
            // Fallback: just return the path bounds as text and dismiss
            let fallbackText = "Selected area: \(Int(pathBounds.width))x\(Int(pathBounds.height))"
            print("🚀 Calling delegate with fallback text and dismissing")
            delegate?.magicWandViewController(self, didSelectText: fallbackText)
            
            // Also try direct dismiss as backup
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true)
            }
        }
    }
    

    
    private func cropImage(_ image: UIImage, to rect: CGRect) -> UIImage? {
        // Ensure the rect is within image bounds
        let imageSize = image.size
        let cropRect = CGRect(
            x: max(0, rect.origin.x),
            y: max(0, rect.origin.y),
            width: min(rect.width, imageSize.width - rect.origin.x),
            height: min(rect.height, imageSize.height - rect.origin.y)
        )
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    private func recognizeTextFromImageAndDismiss(_ image: UIImage) {
        print("🔤 Starting text recognition and will dismiss...")
        guard let cgImage = image.cgImage else { 
            print("❌ Failed to get CGImage from UIImage")
            return 
        }
        
        print("✅ CGImage obtained for recognition")
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            if let error = error {
                print("❌ Vision framework error: \(error)")
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else { 
                print("❌ No text observations found")
                return 
            }
            
            print("📝 Found \(observations.count) text observations")
            
            let recognizedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: " ")
            
            print("✅ Recognized text: '\(recognizedText)'")
            
            DispatchQueue.main.async {
                if !recognizedText.isEmpty {
                    print("🚀 Calling delegate with recognized text: '\(recognizedText)' and dismissing")
                    self?.delegate?.magicWandViewController(self!, didSelectText: recognizedText)
                    
                    // Also try direct dismiss as backup
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.dismiss(animated: true)
                    }
                } else {
                    print("❌ No text to send to delegate")
                    // Fallback: return a message about the selection
                    self?.delegate?.magicWandViewController(self!, didSelectText: "Selected area (no text detected)")
                    
                    // Also try direct dismiss as backup
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        print("🔍 Performing Vision request...")
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
            print("✅ Vision request started successfully")
        } catch {
            print("❌ Failed to perform Vision request: \(error)")
            // Fallback on error
            DispatchQueue.main.async {
                self.delegate?.magicWandViewController(self, didSelectText: "Error processing selection")
            }
        }
    }
}

// Drawing view for finger input
class DrawingView: UIView {
    private var path = UIBezierPath()
    private var lastPoint: CGPoint?
    
    var currentPath: UIBezierPath? {
        return path.isEmpty ? nil : path
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        // Add pan gesture for drawing
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            path = UIBezierPath()
            path.move(to: point)
            self.lastPoint = point
            
        case .changed:
            if self.lastPoint != nil {
                path.addLine(to: point)
                self.lastPoint = point
            }
            
        case .ended:
            path.close()
            
            // Add subtle animation when path completes
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.duration = 0.2
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            layer.add(animation, forKey: "fadeIn")
            
            setNeedsDisplay()
            print("🎨 Drawing path completed, sending notification...")
            // Notify that path is ready
            NotificationCenter.default.post(name: .pathReady, object: nil)
            print("📢 Notification sent: .pathReady")
            
        default:
            break
        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        // Modern stroke with gradient-like effect
        let strokeColor = UIColor.systemBlue
        strokeColor.setStroke()
        path.lineWidth = 2.5
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
        
        // Subtle fill with very low opacity
        let fillColor = UIColor.systemBlue.withAlphaComponent(0.08)
        fillColor.setFill()
        path.fill()
        
        // Add a subtle outer glow effect
        let glowPath = path.copy() as! UIBezierPath
        glowPath.lineWidth = 6.0
        let glowColor = UIColor.systemBlue.withAlphaComponent(0.15)
        glowColor.setStroke()
        glowPath.stroke()
    }
    
    func clearPath() {
        path = UIBezierPath()
        setNeedsDisplay()
    }
}

// Selection overlay view
class SelectionOverlayView: UIView {
    private var textAreaViews: [UIView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showTextAreas(_ observations: [VNRecognizedTextObservation]) {
        // Clear previous text areas
        textAreaViews.forEach { $0.removeFromSuperview() }
        textAreaViews.removeAll()
        
        // Create highlight views for each text area
        for observation in observations {
            let boundingBox = observation.boundingBox
            let view = UIView()
            view.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
            view.layer.borderColor = UIColor.yellow.cgColor
            view.layer.borderWidth = 2.0
            view.layer.cornerRadius = 4
            
            // Convert normalized coordinates to view coordinates
            let x = boundingBox.origin.x * bounds.width
            let y = (1 - boundingBox.origin.y - boundingBox.height) * bounds.height
            let width = boundingBox.width * bounds.width
            let height = boundingBox.height * bounds.height
            
            view.frame = CGRect(x: x, y: y, width: width, height: height)
            addSubview(view)
            textAreaViews.append(view)
            
            // Add tap gesture to select text area
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textAreaTapped(_:)))
            view.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func textAreaTapped(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view else { return }
        
        // Highlight selected text area
        textAreaViews.forEach { view in
            if view == tappedView {
                view.backgroundColor = UIColor.green.withAlphaComponent(0.5)
                view.layer.borderColor = UIColor.green.cgColor
            } else {
                view.backgroundColor = UIColor.yellow.withAlphaComponent(0.3)
                view.layer.borderColor = UIColor.yellow.cgColor
            }
        }
    }
}
