import UIKit

class Button: UIButton {
    
    private var buttonAction: (()->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        showsTouchWhenHighlighted = true
    }
    
    func handleControlEvent(_ event: UIControlEvents, withBlock action: @escaping (()->())) {
        buttonAction = action
        addTarget(self, action: #selector(performActionBlock), for: event)
    }
    
    func performActionBlock() {
        guard let action = buttonAction else { return }
        action()
    }
}
