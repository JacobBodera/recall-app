import SwiftUI

struct ObjectCellView: View {
    let object: ObjectTracking

    func decodeBase64Image(_ base64String: String?) -> UIImage? {
        guard let base64String = base64String,
              let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    var body: some View {
        HStack {
            if let uiImage = decodeBase64Image(object.location_image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } else {
                Image(systemName: "photo") // Fallback image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(object.name)
                    .font(.headline)
                Text("Last seen at: \(object.location_description ?? "Unknown")") // Handle nil safely
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)

            Spacer()
        }
        .padding(8)
    }
}
