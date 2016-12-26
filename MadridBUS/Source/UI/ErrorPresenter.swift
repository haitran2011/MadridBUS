import Foundation

protocol ErrorPresenter {
    func config(using view: View)
}

class ErrorPresenterBase: Presenter, ErrorPresenter {
    private weak var view: ErrorView!
    
    required init(injector: Injector) {
        super.init(injector: injector)
    }
    
    func config(using view: View) {
        guard let errorView = view as? ErrorView else {
            fatalError("\(view) is not an ErrorView")
        }
        
        self.view = errorView
        super.config(view: view)
    }
}
