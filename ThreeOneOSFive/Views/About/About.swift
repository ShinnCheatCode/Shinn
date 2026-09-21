    private func aboutRow(icon: String, title: String, subtitle: String, trailing: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .foregroundStyle(.white)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(Color.white.opacity(0.45))
                }
                Spacer()
                if !trailing.isEmpty {
                    Image(systemName: trailing)
                        .font(.footnote)
                        .foregroundStyle(Color.white.opacity(0.35))
                }
            }
            .padding(14)
            .background(Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .buttonStyle(.plain)
    }