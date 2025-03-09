//
//  ColorExtension.swift
//  SimpleMoneyTracker
//
//  Created by Borja Suñen on 26/1/25.
//
import SwiftUI

extension Color {
    static let mainColor = Color("MainColor") // Asegúrate de usar el nombre exacto del asset
    
    /// Devuelve el Hexadecimal del color
    func toHex() -> String {
            let uiColor = UIColor(self)
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            let r = Int(red * 255), g = Int(green * 255), b = Int(blue * 255)
            return String(format: "#%02X%02X%02X", r, g, b)
        }
    
    init(hex: String) {
         let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
         var int: UInt64 = 0
         Scanner(string: hex).scanHexInt64(&int)
         let r = Double((int >> 16) & 0xFF) / 255.0
         let g = Double((int >> 8) & 0xFF) / 255.0
         let b = Double(int & 0xFF) / 255.0
         self.init(red: r, green: g, blue: b)
     }
}
