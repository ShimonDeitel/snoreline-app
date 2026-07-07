import SwiftUI

enum Theme {
    static let accent = Color(hex: "#5B3B8A")
    static let background = Color(hex: "#120C1B")
    static let card = Color(hex: "#1E122B")
    static let textPrimary = Color(hex: "#EEE2F7")
    static let textSecondary = Color(hex: "#A66EC7")

    static var titleFont: Font { .system(.title2, design: .rounded).weight(.bold) }
    static var bodyFont: Font { .system(.body, design: .rounded) }
    static var captionFont: Font { .system(.caption, design: .rounded) }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
