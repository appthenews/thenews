import SwiftUI

struct Purchased: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "arrow.up.heart.fill")
                .font(.system(size: 80, weight: .ultraLight))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.accentColor)
                .padding(.bottom, 20)
            
            Text("Sponsor")
                .font(.title.weight(.bold))
            Text("We received your\ncontribution.")
                .font(.title3.weight(.regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .padding(.vertical, 5)
            
            Button {
                dismiss()
            } label: {
                Text("OK")
                    .font(.body.weight(.medium))
                    .padding(.horizontal)
                    .frame(minWidth: 140, minHeight: 30)
            }
            .buttonStyle(.borderedProminent)
            .tint(.accentColor)
            .foregroundColor(.white)
            .padding(.top, 20)
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
    }
}
