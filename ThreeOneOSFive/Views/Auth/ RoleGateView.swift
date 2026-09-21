import SwiftUI

struct RoleGateView: View {
    let onGranted: (UserRole) -> Void
    @State private var selectedRole: UserRole? = nil
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 72)

                Image(systemName: "crown.fill")
                    .font(.system(size: 52, weight: .regular))
                    .foregroundStyle(.white)

                Text("SHINN CHEAT")
                    .font(.system(size: 28, weight: .heavy))
                    .foregroundStyle(.white)
                    .padding(.top, 18)

                Text("Chọn vai trò để kích hoạt")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.45))
                    .padding(.top, 8)
                    .padding(.bottom, 28)

                VStack(spacing: 14) {
                    RoleRow(icon: "crown.fill", title: "Owner") {
                        selectedRole = .owner
                    }
                    RoleRow(icon: "checkmark.shield.fill", title: "Admin") {
                        selectedRole = .admin
                    }
                    RoleRow(icon: "person.fill", title: "Member") {
                        onGranted(.member)
                    }
                }
                .padding(.horizontal, 20)

                if let role = selectedRole, role.requiresPassword {
                    passwordBox(for: role)
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                }

                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.easeInOut(duration: 0.2), value: selectedRole)
    }

    private func passwordBox(for role: UserRole) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lock.fill")
                Text("Mật khẩu \(role.title)").font(.headline)
            }
            .foregroundStyle(.white)

            SecureField("Nhập mật khẩu", text: $password)
                .textFieldStyle(.plain)
                .padding(12)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)

            if showError {
                Text("Sai mật khẩu").font(.caption).foregroundStyle(.red)
            }

            HStack(spacing: 12) {
                Button {
                    selectedRole = nil
                    password = ""
                    showError = false
                } label: {
                    Text("Hủy")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white.opacity(0.08))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Button {
                    if RoleAuthStore.shared.verify(password, for: role) {
                        onGranted(role)
                    } else {
                        showError = true
                        password = ""
                    }
                } label: {
                    Text("Xác nhận")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct RoleRow: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 48, height: 48)
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundStyle(.white)
                }
                Text(title)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

enum UserRole: String, CaseIterable, Codable {
    case owner, admin, member
    var title: String {
        switch self {
        case .owner: return "Owner"
        case .admin: return "Admin"
        case .member: return "Member"
        }
    }
    var iconName: String {
        switch self {
        case .owner: return "crown.fill"
        case .admin: return "checkmark.shield.fill"
        case .member: return "person.fill"
        }
    }
    var requiresPassword: Bool {
        switch self {
        case .owner, .admin: return true
        case .member: return false
        }
    }
}