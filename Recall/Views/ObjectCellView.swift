import SwiftUI
import AVFoundation

struct ObjectCellView: View {
    let object: ObjectTracking
    @Binding var selectedImage: IdentifiableImage?  // Change UIImage? -> IdentifiableImage?
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
            utterance.rate = 0.5

            // Ensure audio session is properly configured
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to activate audio session: \(error)")
            }

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
                    .onTapGesture {
                        selectedImage = IdentifiableImage(image: uiImage) // Assign the wrapped image
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text(object.name)
                    .font(.headline)
                Text("Last known location: \(object.location_description ?? "Unknown")")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)

            Spacer()

            Button(action: speakObjectDetails) {
                Image(systemName: "speaker.wave.2.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primary)
                    .padding(8)
            }
            .buttonStyle(.plain)
        }
        .padding(8)
    }
}

struct FullScreenImageView: View {
    let image: UIImage
    @Binding var selectedImage: IdentifiableImage?

    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all) // Ensure background covers entire screen

            VStack {
                Spacer() // Pushes image to the center
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit() // Ensures aspect ratio is maintained
                    .frame(maxWidth: .infinity, maxHeight: .infinity) // Uses as much space as possible
                Spacer() // Keeps it centered
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { selectedImage = nil }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.top, 20) // Adds some spacing from the top
                Spacer()
            }
        }
    }
}


