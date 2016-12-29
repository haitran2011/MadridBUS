import UIKit

struct Fonts {
    struct standards {
        static let bold = "AvenirNextCondensed-Bold"
        static let semibold = "AvenirNextCondensed-DemiBold"
        static let medium = "AvenirNextCondensed-Medium"
        static let regular = "AvenirNextCondensed-Regular"
        static let light = "AvenirNextCondensed-UltraLight"
    }
    
    static let busLineName = UIFont(name: "Anton", size: 20)!
    static let standardRegular = UIFont(name: standards.regular, size: 16)!
    static let standardLight = UIFont(name: standards.light, size: 16)!
    static let standardBold = UIFont(name: standards.bold, size: 16)!
    static let standardSemibold = UIFont(name: standards.semibold, size: 16)!
    static let button = UIFont(name: standards.bold, size: 20)!
}
