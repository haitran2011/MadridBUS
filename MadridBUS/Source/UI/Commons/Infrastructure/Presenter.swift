import Foundation
import BRYXBanner

class Presenter: HandleErrorDelegate {

    var spinner: SpinnerBase!
    let wireframe: Wireframe
    var params: [String:Any] = [:]
    
    required init(injector: Injector) {
        self.wireframe = injector.instanceOf(Wireframe.self)
    }
    
    func config(view: View) {
        wireframe.setFrom(view: view)
        
        if let parameterizedView = view as? ParameterizedView {
            params = parameterizedView.params
        }
    }
    
    func addParameter<T>(parameter: T) {
        params.updateValue(parameter, forKey: "\(parameter.self)")
    }
    
    func retrieveParameter<T>(parameterType: T.Type) -> T? {
        return params.removeValue(forKey: "\(parameterType)") as? T
    }
    
    func handleErrors(error: Error) {
        let errorController = ErrorViewBase()
        if error._code != 1 {
            errorController.configure(using: .error(description: error.localizedDescription))
            errorController.action = {
                errorController.dismiss()
            }
            
            if spinner != nil {
                spinner.dismiss(animated: true, completion: {
                    self.wireframe.present(controller: errorController)
                })
            } else {
                wireframe.present(controller: errorController)
            }
        } else {
            
        }
    }
    
    func showSpinner(performing completion: (()->())?) {
        spinner = SpinnerBase()
        if completion != nil {
            wireframe.present(controller: spinner, completion: completion!)
        } else {
            wireframe.present(controller: spinner)
        }
        
    }
    
    func hideSpinner(performing completion: (()->())?) {
        spinner.dismiss(animated: true, completion: completion)
    }
    
    func showBanner(displaying message: String, title: String) {
        let banner = Banner(title: title, subtitle: message, image: nil, backgroundColor: Colors.red)
        banner.shouldTintImage = false
        banner.dismissesOnTap = true
        banner.show(duration: 3.0)
    }
}
