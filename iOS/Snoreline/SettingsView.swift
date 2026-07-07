import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) var dismiss
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Preferences") {
                    Toggle("Reminders", isOn: $store.settings.remindersEnabled)
                        .accessibilityIdentifier("remindersToggle")
                    Toggle("Sounds", isOn: $store.settings.soundEnabled)
                        .accessibilityIdentifier("soundsToggle")
                }
                .onChange(of: store.settings) { _, _ in store.save() }

                Section("Trigger Report") {
                    if purchases.isPro {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.accent)
                    } else {
                        Button("Upgrade to Pro") {
                            showingPaywall = true
                        }
                        .accessibilityIdentifier("upgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("restoreButton")
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/snoreline-app/privacy.html")!)
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/snoreline-app/terms.html")!)
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
