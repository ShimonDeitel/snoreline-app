import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager

    @State private var showingAdd = false
    @State private var showingPaywall = false
    @State private var showingSettings = false
    @State private var draft = SnoreEntry()
    @State private var editingItem: SnoreEntry? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()
                if store.items.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray")
                            .font(.system(size: 44))
                            .foregroundStyle(Theme.textSecondary)
                        Text("Nothing logged yet")
                            .font(Theme.bodyFont)
                            .foregroundStyle(Theme.textSecondary)
                    }
                } else {
                    List {
                        ForEach(store.items) { item in
                            Button {
                                editingItem = item
                                draft = item
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.date.formatted(date: .abbreviated, time: .shortened))
                                        .font(Theme.bodyFont)
                                        .foregroundStyle(Theme.textPrimary)
                                    Text(item.createdAt.formatted(date: .abbreviated, time: .shortened))
                                        .font(Theme.captionFont)
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                            .listRowBackground(Theme.card)
                            .accessibilityIdentifier("row_\(item.id.uuidString)")
                        }
                        .onDelete { offsets in
                            store.delete(at: offsets)
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .navigationTitle("Snoreline")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.canAdd(isPro: purchases.isPro) {
                            draft = SnoreEntry()
                            editingItem = nil
                            showingAdd = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addButton")
                }
            }
            .sheet(isPresented: $showingAdd) {
                addSheet
            }
            .sheet(item: $editingItem) { _ in
                addSheet
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
            }
        }
        .tint(Theme.accent)
    }

    private var addSheet: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Date", selection: $draft.date)
                        .accessibilityIdentifier("field_date")
                    TextField("Trigger", text: $draft.trigger, axis: .vertical)
                        .accessibilityIdentifier("field_trigger")
                }
            }
            .navigationTitle(editingItem == nil ? "Add" : "Edit")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAdd = false
                        editingItem = nil
                    }
                    .accessibilityIdentifier("cancelButton")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let editing = editingItem {
                            let updated = SnoreEntry(id: editing.id, createdAt: editing.createdAt, date: draft.date, trigger: draft.trigger)
                            store.update(updated)
                        } else {
                            _ = store.add(draft, isPro: purchases.isPro)
                        }
                        showingAdd = false
                        editingItem = nil
                    }
                    .accessibilityIdentifier("saveButton")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(PurchaseManager())
}
