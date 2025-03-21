import SwiftUI
import UIKit

// MARK: Color

enum Colors {
    static let white = Color(red: 244, green: 244, blue: 244)
    static let black = Color(red: 4, green: 4, blue: 4, opacity: 1)
    static let white50 = Color(red: 77, green: 85, blue: 94, opacity: 0.5)
    static let red = Color(uiColor: UIColors.red)
    static let black4 = Color(uiColor: UIColors.black4)
}

// MARK: UIColor

enum UIColors {
    static let gray = UIColor(hex: "#272729")
    static let black = UIColor(red: 4, green: 4, blue: 4, alpha: 1)
    static let white = UIColor(hex: "#F4F4F4")
    static let yellow = UIColor(hex: "#FED702")
    static let black4 = UIColor(hex: "#040404")
    static let red = UIColor(hex: "#D70015")
}


extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }
        
        if hexSanitized.count == 6 {
            var rgb: UInt64 = 0
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        } else {
            self.init(white: 0.0, alpha: 1.0)
        }
    }
}
