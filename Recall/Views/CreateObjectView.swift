import SwiftUI

struct CreateObjectView: View {
    @ObservedObject var networkManager: NetworkManager
    @State private var objectName: String = ""
    @State private var isUploadingImage = false
    @Binding var isCreatingObject: Bool
    @State private var objectID: Int? // Store object ID after creation

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Enter Object Name")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top, 20)

                TextField("Object name...", text: $objectName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    .padding(.horizontal)

                Button(action: {
                    networkManager.createObject(name: objectName) { objectID in
                        if let id = objectID {
                            self.objectID = id
                            isUploadingImage = true
                        }
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(objectName.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .opacity(objectName.isEmpty ? 0.6 : 1.0)
                }
                .disabled(objectName.isEmpty) // Disable button if input is empty
            }
            .padding()
            .navigationDestination(isPresented: $isUploadingImage) {
                if let objectID = objectID { // Safely unwrap objectID
                    UploadImageView(isCreatingObject: $isCreatingObject, objectID: objectID)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isCreatingObject = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Create New Object")
        }
    }
}
