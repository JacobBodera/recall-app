import SwiftUI
import AVFoundation

struct ObjectCellView: View {
    let object: ObjectTracking
    private let speechSynthesizer = AVSpeechSynthesizer()

    private func decodeBase64Image(_ base64String: String?) -> UIImage? {
        guard let base64String = base64String,
              let imageData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }

    private func speakObjectDetails() {
        let text = "\(object.name). Last known location is \(object.location_description ?? "unknown")."
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5 // Adjust the speed if needed
        speechSynthesizer.speak(utterance)
    }

    var body: some View {
        HStack {
            if let uiImage = decodeBase64Image(object.location_image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                Text("Last seen at: \(object.location_description ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)

            Spacer()

            // Adaptive color for light/dark mode
            Button(action: speakObjectDetails) {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primary) // Automatically adjusts for dark mode
                    .padding(8)
            }
            .buttonStyle(.plain) // Prevents default button styling
        }
        .padding(8)
    }
}
