import Foundation

class RepositoryError: NSError {
    
    init(message: String) {
        super.init(domain: "MadridBUS.Data", code: 1, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
