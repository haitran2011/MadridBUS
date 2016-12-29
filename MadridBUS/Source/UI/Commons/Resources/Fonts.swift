import UIKit

struct Fonts {
    struct standards {
        static let bold = "AppleSDGothicNeo-Bold"
        static let light = "AppleSDGothicNeo-Light"
        static let medium = "AppleSDGothicNeo-Medium"
        static let regular = "AppleSDGothicNeo-Regular"
        static let semibold = "AppleSDGothicNeo-SemiBold"
        static let thin = "AppleSDGothicNeo-Thin"
        static let ultra_light = "AppleSDGothicNeo-UltraLight"
    }
    
    static let busLineName = UIFont(name: "Anton", size: 20)!
    static let standardLight = UIFont(name: standards.light, size: 16)!
    static let standardBold = UIFont(name: standards.bold, size: 16)!
    static let button = UIFont(name: standards.bold, size: 20)!
}
