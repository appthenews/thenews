import SwiftUI
import StoreKit

struct Sponsor: View {
    let session: Session
    @State private var product: Product?
    @State private var alert = false
    @State private var error = ""
    @AppStorage("sponsor") private var sponsor = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack(spacing: 0) {
                Image(systemName: "arrow.up.heart")
                    .font(.system(size: 120, weight: .ultraLight))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.accentColor)
                
                Spacer()
                
                Text("Fund The News App")
                    .font(.title2.weight(.medium))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 300)
                
                Text("Contributes to maintenance and\nmaking it available for everyone.")
                    .font(.body.weight(.regular))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: 300)
                    .padding(.top, 6)
                
                if sponsor {
                    Spacer()
                    
                    Text("Thank you")
                        .font(.title3.weight(.medium))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 300)
                        .padding(.bottom, 6)
                    
                    Text("We received\nyour contribution.")
                        .font(.title3.weight(.regular))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: 300)
                } else {
                    Button {
                        guard session.store.status.value == .ready else { return }
                        
                        if let product = product {
                            Task {
                                await session.store.purchase(product)
                            }
                        } else {
                            session.store.status.value = .error("Unable to connect to the App Store, try again later.")
                        }
                    } label: {
                        Text("Sponsor")
                            .font(.body.weight(.bold))
                            .padding(.horizontal)
                            .frame(minWidth: 260, minHeight: 34)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentColor)
                    .foregroundColor(.white)
                    .padding(.vertical, 20)
                    
                    if let product = product {
                        Text("1 time purchase of " + product.displayPrice)
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: 280)
                    }
                }
                
                Spacer()
                Spacer()
                Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !sponsor {
                    Button("Restore Purchases") {
                        Task {
                            await session.store.restore()
                        }
                    }
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .greatestFiniteMagnitude)
        .alert(error, isPresented: $alert) { }
        .onReceive(session.store.status.receive(on: DispatchQueue.main)) {
            switch $0 {
            case let .error(fail):
                error = fail
                alert = true
            default:
                break
            }
        }
        .task {
            product = await session.store.load(item: .sponsor)
        }
    }
}
