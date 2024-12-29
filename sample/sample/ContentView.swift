//
//  ContentView.swift
//  sample
//
//  Created by 山﨑　陽介 on 2024/12/01.
//
import SwiftUI
import UIKit

// カメラで画像を選択するビュー
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// メインのビュー
struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showErrorAlert = false
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
            } else {
                Text("写真を撮影してください")
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                // カメラが利用可能か確認
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    showImagePicker = true
                } else {
                    showErrorAlert = true
                }
            }) {
                Text("カメラを起動")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("カメラが利用できません"),
                    message: Text("このデバイスではカメラを使用できません。"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
}

// プレビュー
#Preview {
    ContentView()
}
