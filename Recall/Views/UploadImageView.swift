import SwiftUI
import PhotosUI

struct UploadImageView: View {
    @Binding var isCreatingObject: Bool
    @State private var selectedImages: [UIImage] = []
    @State private var isUploading = false
    @State private var photoPickerItems: [PhotosPickerItem] = []
    @State private var showSuccessMessage = false
    let objectID: Int  // ID of the created object

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Upload Image")
                    .font(.title2)
                    .fontWeight(.semibold)

                // Display selected images
                if selectedImages.isEmpty {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("No Images Selected").foregroundColor(.gray))
                } else {
                    List(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 100)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }
                    .frame(height: 200)
                }

                // Allow selection of multiple images
                PhotosPicker(
                    selection: $photoPickerItems,
                    matching: .images
                ) {
                    Text("Select Images")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                .onChange(of: photoPickerItems) { newItems in
                    loadSelectedImages(from: newItems)
                }

                Button("Finish") {
                    // Show success message and simulate navigation back
                    showSuccessMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        isCreatingObject = false  // Go back to home
                    }
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(selectedImages.isEmpty ? Color.gray : Color.green)
                .cornerRadius(12)
                .shadow(radius: 2)
                .padding(.horizontal)
                .disabled(selectedImages.isEmpty)  // Disable until at least one image is selected

                if isUploading {
                    ProgressView()
                        .padding()
                }

                // Success message after pressing finish
                if showSuccessMessage {
                    Text("Images successfully uploaded!")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.top)
                        .transition(.opacity)
                }
            }
            .padding()
            .navigationTitle("Upload Image")
            // Removed the Back button from the navigation bar
        }
    }

    /// Loads selected images into state
    private func loadSelectedImages(from items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImages.append(image)
                }
            }
        }
    }
}
