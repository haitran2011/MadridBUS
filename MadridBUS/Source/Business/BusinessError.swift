import Foundation

class BusinessError: NSError {
    
    init(message: String) {
        super.init(domain: "MadridBUS.Business", code: 2, userInfo: [NSLocalizedDescriptionKey: message])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
