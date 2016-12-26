import UIKit

struct Fonts {
    struct standards {
        static let black = "Calibre-Black"
        static let black_italic = "Calibre-BlackItalic"
        static let bold = "Calibre-Bold"
        static let bold_italic = "Cablibre-BoldItalic"
        static let light = "Calibre-Light"
        static let light_italic = "Calibre-LightItalic"
        static let medium = "Calibre-Medium"
        static let medium_italic = "Calibre-MediumItalic"
        static let regular_italic = "Calibre-RegularItalic"
        static let semibold = "Calibre-SemiBold"
        static let semibold_italic = "Calibre-SemiboldItalic"
        static let thin = "Calibre-Thin"
        static let thin_italic = "Calibre-ThinItalic"
    }
    
    static let primaryButtonTitle = UIFont(name: standards.bold, size: 20)!
    static let secondaryButtonTitle = UIFont(name: standards.bold, size: 18)!
    
    static let bigTitle = UIFont(name: standards.bold, size: 30)!
    static let listTitle = UIFont(name: standards.bold, size: 18)!
    static let listSubtitle = UIFont(name: standards.light, size: 18)!
    static let listItem = UIFont(name: standards.light, size: 18)!
    static let listItemBold = UIFont(name: standards.semibold, size: 18)!
    
    static let headerTitle = UIFont(name: standards.bold, size: 26)!
    static let headerReason = UIFont(name: standards.thin, size: 20)!
    
    static let centeredTitle = UIFont(name: standards.thin, size: 26)!
    static let centeredSubtitle = UIFont(name: standards.medium, size: 26)!
    
    static let textField = UIFont(name: standards.light, size: 18)!
    
    static let giantNumber = UIFont(name: standards.black, size: 200)!
    
    static let miniLight = UIFont(name: standards.light, size: 14)
    static let miniBold = UIFont(name: standards.bold, size: 14)!
}
