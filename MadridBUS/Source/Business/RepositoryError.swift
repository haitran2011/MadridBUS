import Foundation

class RepositoryError: NSError {
    init(message: String, code: Int = 1) {
        super.init(domain: "MadridBUS.Data", code: code, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
