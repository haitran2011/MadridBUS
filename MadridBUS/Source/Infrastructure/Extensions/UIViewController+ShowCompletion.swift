import UIKit

extension UIViewController {
    public func show(_ vc: UIViewController, sender: Any?, completion: (() -> ())?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        show(vc, sender: sender)
        CATransaction.commit()
    }
}
