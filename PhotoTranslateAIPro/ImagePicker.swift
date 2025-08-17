//
//  ImagePicker.swift
//  PhotoTranslateAIPro
//
//  Created by Orlin Kalev on 17.08.25.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        // Check if source type is available and set appropriate source type
        let finalSourceType: UIImagePickerController.SourceType
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            finalSourceType = sourceType
        } else {
            // Fallback to photo library if camera is not available
            finalSourceType = .photoLibrary
        }
        
        picker.sourceType = finalSourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        // Add error handling
        if finalSourceType == .camera {
            picker.cameraCaptureMode = .photo
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
