import UIKit

protocol WelcomeView: View {
    
}

class WelcomeViewBase: UIViewController, WelcomeView {
    private var presenter: WelcomePresenter
    
    init(injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "WelcomeView") {
        self.presenter = injector.instanceOf(WelcomePresenter.self)
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.obtainBusNodes(from: "116")
    }
}
