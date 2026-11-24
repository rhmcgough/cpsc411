import SwiftUI

// Credentials are stored in UserDefaults for educational purposes only.
// Production apps should use Keychain or secure authentication tokens.
struct UserAccount: Codable, Identifiable {
    var id = UUID()
    let username: String
    let password: String
}

struct LoginView: View {

    @AppStorage("usersData") private var usersData: Data = Data()
    @AppStorage("currentUsername") private var currentUsername = ""
    @AppStorage("isLoggedIn") private var isLoggedIn = false

    @State private var username = ""
    @State private var password = ""
    @State private var message = ""

    // Helper property to decode registered users
    private var users: [UserAccount] {
        get {
            guard !usersData.isEmpty,
                  let decoded = try? JSONDecoder().decode([UserAccount].self, from: usersData) else {
                return []
            }
            return decoded
        }
        nonmutating set {
            if let data = try? JSONEncoder().encode(newValue) {
                usersData = data
            }
        }
    }

    var body: some View {

        NavigationStack {

            Form {

                if isLoggedIn {

                    Section {
                        Text("Logged in as \(currentUsername)")
                        Button("Log Out", role: .destructive, action: logout)
                    }

                } else {

                    Section("Account") {
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        SecureField("Password", text: $password)
                    }

                    Section {
                        Button("Log In", action: login)
                        Button("Create Account", action: register)
                    }

                    if !message.isEmpty {
                        Text(message)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Account")
        }
    }

    // Registering a new account
    private func register() {
        let trimmed = username.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !password.isEmpty else { return }

        if users.contains(where: { $0.username.lowercased() == trimmed.lowercased() }) {
            message = "Username already exists."
            return
        }

        var updatedUsers = users
        updatedUsers.append(UserAccount(username: trimmed, password: password))
        users = updatedUsers

        currentUsername = trimmed
        isLoggedIn = true
        message = ""
    }

    // Logging in
    private func login() {
        let trimmed = username.trimmingCharacters(in: .whitespaces)
        if let match = users.first(where: { $0.username.lowercased() == trimmed.lowercased() && $0.password == password }) {
            currentUsername = match.username
            isLoggedIn = true
            message = ""
        } else {
            message = "Invalid username or password."
        }
    }

    // Logging out
    private func logout() {
        isLoggedIn = false
        currentUsername = ""
        password = ""
    }
}

#Preview {
    LoginView()
}
