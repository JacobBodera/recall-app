import SwiftUI
import PhotosUI

struct UploadImageView: View {
    @Binding var isCreatingObject: Bool
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var photoPickerItem: PhotosPickerItem?
    let objectID: Int  // ID of the created object

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Upload Image")
                    .font(.title2)
                    .fontWeight(.semibold)

                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("No Image Selected").foregroundColor(.gray))
                }

                PhotosPicker(selection: $photoPickerItem, matching: .images) {
                    Text("Select Image")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                .onChange(of: photoPickerItem) { newItem in
                    loadSelectedImage(from: newItem)
                }

                Button("Finish") {
                    if let selectedImage = selectedImage {
                        uploadImageToServer(image: selectedImage, id: objectID)
                    } else {
                        isCreatingObject = false // Go back if no image is uploaded
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                .disabled(selectedImage == nil)
                .opacity(selectedImage == nil ? 0.6 : 1.0)

                if isUploading {
                    ProgressView()
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Upload Image")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isCreatingObject = false
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }

    /// Loads selected image into state
    private func loadSelectedImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                selectedImage = image
            }
        }
    }

    /// Uploads the selected image as a base64 string to the API
    private func uploadImageToServer(image: UIImage, id: Int) {
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            print("Failed to encode image")
            return
        }

        let url = URL(string: "http://127.0.0.1:8000/TrainImages/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["id": id, "image": imageData]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        isUploading = true

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isUploading = false
                if error == nil {
                    isCreatingObject = false // Go back to home
                } else {
                    print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }.resume()
    }
}
