import UIKit

class ErrorViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = LocalizedLiteral.localize(using: "COMMON_NAV_AGREEMENT")
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
