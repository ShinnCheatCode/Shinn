import SwiftUI

struct RoleGateView: View {
    let onGranted: (UserRole) -> Void
    @State private var selectedRole: UserRole? = nil
    @State private var password: String = ""
    @State private var showError: Bool = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                Image(systemName: "crown.fill")
                    .font(.system(size: 56)).foregroundStyle(.white).padding(.top, 40)
                Text("SHINN CHEAT").font(.system(size: 34, weight: .heavy)).foregroundStyle(.white)
                Text("Chọn vai trò để kích hoạt").font(.subheadline).foregroundStyle(.gray)
                VStack(spacing: 14) {
                    RoleRow(icon: "crown.fill", title: "Owner") { selectedRole = .owner }
                    RoleRow(icon: "checkmark.shield.fill", title: "Admin") { selectedRole = .admin }
                    RoleRow(icon: "person.fill", title: "Member") { onGranted(.member) }
                }
                .padding(.horizontal, 24)
                if let role = selectedRole, role.requiresPassword {
                    passwordBox(for: role).padding(.horizontal, 24)
                }
                Spacer()
            }
        }
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
                .textFieldStyle(.plain).padding(12)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .foregroundStyle(.white)
            if showError {
                Text("Sai mật khẩu").font(.caption).foregroundStyle(.red)
            }
            HStack(spacing: 12) {
                Button {
                    selectedRole = nil; password = ""; showError = false
                } label: {
                    Text("Hủy").frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color.white.opacity(0.08)).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Button {
                    if RoleAuthStore.shared.verify(password, for: role) {
                        onGranted(role)
                    } else {
                        showError = true; password = ""
                    }
                } label: {
                    Text("Xác nhận").frame(maxWidth: .infinity).padding(.vertical, 12)
                        .background(Color.white).foregroundStyle(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.04))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.08), lineWidth: 1))
    }
}

struct RoleRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.08)).frame(width: 44, height: 44)
                    Image(systemName: icon).foregroundStyle(.white)
                }
                Text(title).font(.headline).foregroundStyle(.white)
                Spacer()
            }
            .padding(12)
            .background(Color.white.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.08), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

enum UserRole: String, CaseIterable, Codable {
    case owner, admin, member
    var title: String {
        switch self {
        case .owner:  return "Owner"
        case .admin:  return "Admin"
        case .member: return "Member"
        }
    }
    var iconName: String {
        switch self {
        case .owner:  return "crown.fill"
        case .admin:  return "checkmark.shield.fill"
        case .member: return "person.fill"
        }
    }
    var requiresPassword: Bool {
        switch self {
        case .owner, .admin: return true
        case .member:        return false
        }
    }
}