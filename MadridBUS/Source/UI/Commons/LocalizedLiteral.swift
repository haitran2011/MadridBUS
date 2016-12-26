import Foundation

class LocalizedLiteral {
    static func localize(using key: String, with arguments: String) -> String {
        let retrievedString = localize(using: key)
        return String(format: retrievedString, arguments)
        
        //TIP: There's a problem casting an array to a variadic function parameter. By now swift is not implementing this casting for a matter of generics structure.
        //More info here: https://devforums.apple.com/message/974316#974316
    }
    
    static func localize(using key: String) -> String {
        return NSLocalizedString(key, tableName: "Languages", comment: "")
    }
}
