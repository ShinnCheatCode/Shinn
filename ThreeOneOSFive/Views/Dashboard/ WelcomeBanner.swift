import SwiftUI

struct WelcomeBanner: View {
    let userName: String
    let status: DeviceStatus

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [.purple.opacity(0.6), .blue.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))

            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Image("Avatar")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.white.opacity(0.4), lineWidth: 2))

                    Circle()
                        .fill(status.color)
                        .frame(width: 12, height: 12)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Welcome, \(userName)").font(.headline)
                    Text("Device Status:").font(.caption)
                    Text(status.label)
                        .font(.caption.bold())
                        .foregroundStyle(status.color)
                }
                Spacer()
                Text("Better Tools\nFor Your Game")
                    .font(.caption2)
                    .multilineTextAlignment(.trailing)
            }
            .padding(16)
        }
        .frame(height: 140)
    }
}

enum DeviceStatus {
    case connected, disconnected

    var label: String {
        switch self {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        }
    }

    var color: Color {
        switch self {
        case .connected: return .green
        case .disconnected: return .red
        }
    }
}