import SwiftUI

struct Theme {
    // Ana renkler
    static let background = Color.black
    static let foreground = Color.white
    static let accent = Color("FieldGreen")
    
    // Gri tonları
    static let gray100 = Color.white.opacity(0.1)
    static let gray200 = Color.white.opacity(0.2)
    static let gray300 = Color.white.opacity(0.3)
    static let gray400 = Color.white.opacity(0.4)
    
    // Gradyanlar
    static let cardGradient = LinearGradient(
        colors: [Color.black, Color.black.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentGradient = LinearGradient(
        colors: [accent, accent.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // Stil sabitleri
    static let cornerRadius: CGFloat = 12
    static let padding: CGFloat = 16
    static let shadowRadius: CGFloat = 5
    
    // Kart stili
    static func cardStyle<V: View>(_ content: V) -> some View {
        content
            .background(cardGradient)
            .cornerRadius(cornerRadius)
            .shadow(color: .white.opacity(0.1), radius: shadowRadius)
    }
} 