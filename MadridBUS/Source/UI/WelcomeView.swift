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
        
        presenter.obtainPOIList(latitude: 40.3833394, longitude: -3.7237334, radius: 1000)
    }
}
