import Foundation
import UIKit

protocol Wireframe {
    func setFrom(view: Any)
    
    func pushTo(view: UIViewController)
    func pushTo(view: UIViewController, completion: (() -> ())?)
    func pushTo(view: UIViewController, params: [String: Any])
    func pushTo(view: UIViewController, params: [String: Any], completion: (() -> ())?)
    
    func present(controller: UIViewController, completion: @escaping (() -> ()))
    func present(controller: UIViewController)
    
    func pop(animated: Bool)
}

class WireframeBase: Wireframe {
    
    private var from: UIViewController!
    
    func setFrom(view: Any) {
        guard let viewController = view as? UIViewController else {
            fatalError("\(view) is not an UIViewController")
        }
        
        self.from = viewController
    }
    
    func pushTo(view: UIViewController) {
        DispatchQueue.main.async {
            self.from.show(view, sender: self.from)
        }
    }
    
    func pushTo(view: UIViewController, completion: (() -> ())?) {
        DispatchQueue.main.async {
            self.from.show(view, sender: self.from, completion: completion)
        }
    }
    
    func pushTo(view: UIViewController, params: [String: Any]) {
        guard let viewController = view as? ParameterizedView else {
            fatalError("\(view) doesn't conform ParameterizedView protocol") }
        
        viewController.params = params
        pushTo(view: view)
    }
    
    func pushTo(view: UIViewController, params: [String: Any], completion: (() -> ())?) {
        guard let viewController = view as? ParameterizedView else {
            fatalError("\(view) doesn't conform ParameterizedView protocol") }
        
        viewController.params = params
        pushTo(view: view, completion: completion)
    }
    
    func present(controller: UIViewController, completion: @escaping (() -> ())) {
        DispatchQueue.main.async {
            self.from.present(controller, animated: true, completion: completion)
        }
    }
    
    func present(controller: UIViewController) {
        DispatchQueue.main.async {
            self.from.present(controller, animated: true, completion: nil)
        }
    }
    
    func pop(animated: Bool) {
        _ = from.navigationController?.popViewController(animated: animated)
    }
    
}
