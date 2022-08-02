import SwiftUI

struct About: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            Image("Launch")
            Spacer()
            
            HStack {
                Text("The News")
                    .font(.title2.weight(.heavy))
                    .foregroundColor(.init(red: 1, green: 0.651, blue: 1, opacity: 1))
                    .padding(.vertical, 10)
            }
            .frame(maxWidth: .greatestFiniteMagnitude)
            .background(.white)
            
            Spacer()
            
            Button {
                UIApplication.shared.share(URL(string: "https://apps.apple.com/us/app/news/id1632729572?platform=iphone")!)
            } label: {
                Image(systemName: "square.and.arrow.up.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .font(.system(size: 30, weight: .regular))
                    .foregroundStyle(.white)
                    .contentShape(Rectangle())
            }
            
            Spacer()
            
            Text(verbatim: Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                .font(.body.monospacedDigit())
                .foregroundStyle(.white)
            HStack(spacing: 0) {
                Text("From Berlin with ")
                    .foregroundColor(.white)
                    .font(.caption)
                Image(systemName: "heart.fill")
                    .foregroundColor(.white)
                    .font(.footnote)
            }
            Spacer()
        }
        .background(Color(red: 1, green: 0.651, blue: 1, opacity: 1))
    }
}
