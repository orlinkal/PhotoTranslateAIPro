import SwiftUI
import UIKit
import Photos

struct EnhancedImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> EnhancedImagePickerViewController {
        let picker = EnhancedImagePickerViewController(sourceType: sourceType)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: EnhancedImagePickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, EnhancedImagePickerDelegate {
        let parent: EnhancedImagePicker
        
        init(_ parent: EnhancedImagePicker) {
            self.parent = parent
        }
        
        func enhancedImagePicker(_ picker: EnhancedImagePickerViewController, didSelectImage image: UIImage) {
            parent.selectedImage = image
            parent.dismiss()
        }
        
        func enhancedImagePickerDidCancel(_ picker: EnhancedImagePickerViewController) {
            parent.dismiss()
        }
    }
}

protocol EnhancedImagePickerDelegate: AnyObject {
    func enhancedImagePicker(_ picker: EnhancedImagePickerViewController, didSelectImage image: UIImage)
    func enhancedImagePickerDidCancel(_ picker: EnhancedImagePickerViewController)
}

class EnhancedImagePickerViewController: UIViewController {
    private let sourceType: UIImagePickerController.SourceType
    weak var delegate: EnhancedImagePickerDelegate?
    
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let toolbar = UIToolbar()
    private let selectButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let cropOverlay = UIView()
    private let instructionLabel = UILabel()
    
    init(sourceType: UIImagePickerController.SourceType) {
        self.sourceType = sourceType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImageSource()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Setup scroll view with zoom capabilities
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isHidden = true // Initially hidden for camera
        view.addSubview(scrollView)
        
        // Add double-tap gesture for quick zoom
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGesture)
        
        // Setup image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        
        // Setup crop overlay to show what will be captured
        cropOverlay.layer.borderWidth = 2.0
        cropOverlay.layer.borderColor = UIColor.systemGreen.cgColor
        cropOverlay.backgroundColor = UIColor.clear
        cropOverlay.isUserInteractionEnabled = false
        cropOverlay.translatesAutoresizingMaskIntoConstraints = false
        cropOverlay.isHidden = true // Initially hidden for camera
        view.addSubview(cropOverlay)
        
        // Setup instruction label
        instructionLabel.text = "Zoom and position to crop. Only visible area will be captured."
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        instructionLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        instructionLabel.layer.cornerRadius = 8
        instructionLabel.layer.masksToBounds = true
        instructionLabel.numberOfLines = 0
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        instructionLabel.isHidden = true // Initially hidden for camera
        view.addSubview(instructionLabel)
        
        // Setup toolbar
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.isHidden = true // Initially hidden for camera
        view.addSubview(toolbar)
        
        // Setup buttons
        selectButton.setTitle("Crop & Use Photo", for: .normal)
        selectButton.setTitleColor(.white, for: .normal)
        selectButton.backgroundColor = UIColor.systemBlue
        selectButton.layer.cornerRadius = 12
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
        selectButton.translatesAutoresizingMaskIntoConstraints = false
        selectButton.isEnabled = false // Initially disabled
        toolbar.addSubview(selectButton)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = UIColor.systemGray
        cancelButton.layer.cornerRadius = 12
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        toolbar.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            cropOverlay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cropOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cropOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cropOverlay.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            instructionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            instructionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            instructionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 80),
            
            selectButton.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor, constant: 60),
            selectButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            selectButton.widthAnchor.constraint(equalToConstant: 120),
            selectButton.heightAnchor.constraint(equalToConstant: 44),
            
            cancelButton.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor, constant: -60),
            cancelButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupImageSource() {
        if sourceType == .camera {
            // For camera, show a custom camera interface
            showCustomCamera()
        } else {
            // For photo library, show the enhanced picker
            showPhotoLibrary()
        }
    }
    
    private func showCustomCamera() {
        // Create a custom camera interface
        let cameraView = UIView()
        cameraView.backgroundColor = .black
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cameraView)
        
        let cameraLabel = UILabel()
        cameraLabel.text = "Camera functionality will be handled by the parent view controller"
        cameraLabel.textColor = .white
        cameraLabel.textAlignment = .center
        cameraLabel.numberOfLines = 0
        cameraLabel.translatesAutoresizingMaskIntoConstraints = false
        cameraView.addSubview(cameraLabel)
        
        NSLayoutConstraint.activate([
            cameraView.topAnchor.constraint(equalTo: view.topAnchor),
            cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cameraLabel.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            cameraLabel.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor),
            cameraLabel.leadingAnchor.constraint(equalTo: cameraView.leadingAnchor, constant: 20),
            cameraLabel.trailingAnchor.constraint(equalTo: cameraView.trailingAnchor, constant: -20)
        ])
    }
    
    private func showPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true) {
            // For photo library, we'll show the interface after selection
            // The interface is already set up but hidden
        }
    }
    
    @objc private func selectButtonTapped() {
        if let image = imageView.image {
            print("🔍 Original image orientation: \(image.imageOrientation.rawValue)")
            print("🔍 Original image size: \(image.size)")
            
            // Crop the image to only the visible portion based on current zoom and scroll position
            let croppedImage = cropImageToVisibleArea(image)
            
            print("🔍 Cropped image orientation: \(croppedImage.imageOrientation.rawValue)")
            print("🔍 Cropped image size: \(croppedImage.size)")
            
            delegate?.enhancedImagePicker(self, didSelectImage: croppedImage)
        }
    }
    
    private func cropImageToVisibleArea(_ image: UIImage) -> UIImage {
        // Get the current visible rect in the scroll view
        let visibleRect = scrollView.bounds
        
        // Calculate the scale factor between the image view and the original image
        let imageViewSize = imageView.frame.size
        let imageSize = image.size
        
        // Calculate the scale factors
        let scaleX = imageSize.width / imageViewSize.width
        let scaleY = imageSize.height / imageViewSize.height
        
        // Get the current scroll view content offset
        let contentOffset = scrollView.contentOffset
        
        // Calculate the visible area in the image view's coordinate system
        let visibleAreaInImageView = CGRect(
            x: contentOffset.x,
            y: contentOffset.y,
            width: visibleRect.width,
            height: visibleRect.height
        )
        
        // Convert to the original image's coordinate system
        let cropRect = CGRect(
            x: visibleAreaInImageView.origin.x * scaleX,
            y: visibleAreaInImageView.origin.y * scaleY,
            width: visibleAreaInImageView.width * scaleX,
            height: visibleAreaInImageView.height * scaleY
        )
        
        // Ensure the crop rect doesn't exceed the image bounds
        let finalCropRect = CGRect(
            x: max(0, min(cropRect.origin.x, imageSize.width - cropRect.width)),
            y: max(0, min(cropRect.origin.y, imageSize.height - cropRect.height)),
            width: min(cropRect.width, imageSize.width - max(0, cropRect.origin.x)),
            height: min(cropRect.height, imageSize.height - max(0, cropRect.origin.y))
        )
        
        // Perform the actual cropping with proper orientation handling
        guard let cgImage = image.cgImage?.cropping(to: finalCropRect) else {
            return image // Fallback to original if cropping fails
        }
        
        // Create a new UIImage with the cropped CGImage and preserve the original orientation
        let croppedImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
        
        // If the image has a non-standard orientation, normalize it
        if image.imageOrientation != .up {
            return normalizeImageOrientation(croppedImage)
        }
        
        return croppedImage
    }
    
    private func normalizeImageOrientation(_ image: UIImage) -> UIImage {
        print("🔄 Normalizing image orientation from: \(image.imageOrientation.rawValue)")
        
        // If the image is already in the correct orientation, return it
        if image.imageOrientation == .up {
            print("✅ Image already in correct orientation")
            return image
        }
        
        // Create a graphics context to draw the image in the correct orientation
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("✅ Image normalized to orientation: \(normalizedImage?.imageOrientation.rawValue ?? -1)")
        return normalizedImage ?? image
    }
    
    @objc private func cancelButtonTapped() {
        delegate?.enhancedImagePickerDidCancel(self)
    }
    
    @objc private func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
        if scrollView.zoomScale > scrollView.minimumZoomScale {
            // Zoom out to minimum
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            // Zoom in to maximum
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension EnhancedImagePickerViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        // Center the image when zooming
        let boundsSize = scrollView.bounds.size
        var frameToCenter = imageView.frame
        
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        
        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        imageView.frame = frameToCenter
        
        // Update crop overlay to show current visible area
        updateCropOverlay()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update crop overlay when scrolling
        updateCropOverlay()
    }
    
    private func updateCropOverlay() {
        // The crop overlay shows the current visible area that will be captured
        // It's already constrained to the view bounds, so it automatically shows the crop area
        cropOverlay.layer.borderColor = UIColor.systemGreen.cgColor
        cropOverlay.layer.borderWidth = 2.0
        
        // Add a subtle animation to make it clear
        let animation = CABasicAnimation(keyPath: "borderWidth")
        animation.fromValue = 1.0
        animation.toValue = 2.0
        animation.duration = 0.2
        cropOverlay.layer.add(animation, forKey: "borderWidth")
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EnhancedImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let image = info[.originalImage] as? UIImage {
                // Show the enhanced cropping interface for the captured photo
                self.imageView.image = image
                self.selectButton.isEnabled = true
                self.selectButton.backgroundColor = UIColor.systemGreen
                self.selectButton.setTitle("Crop & Use Photo", for: .normal)
                
                // Determine if this is from camera or photo library
                let isFromCamera = picker.sourceType == .camera
                if isFromCamera {
                    self.instructionLabel.text = "Review and crop your photo. Only visible area will be captured."
                } else {
                    self.instructionLabel.text = "Zoom and position to crop. Only visible area will be captured."
                }
                
                // Show the enhanced interface
                self.scrollView.isHidden = false
                self.toolbar.isHidden = false
                self.cropOverlay.isHidden = false
                self.instructionLabel.isHidden = false
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.delegate?.enhancedImagePickerDidCancel(self)
        }
    }
}
