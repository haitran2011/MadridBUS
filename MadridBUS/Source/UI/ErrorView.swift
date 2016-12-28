import UIKit

enum ErrorViewType {
    case noData
    case error(description: String)
}

protocol ErrorView: View {
    
}

class ErrorViewBase: ErrorViewController, ErrorView {
    private var presenter: ErrorPresenter
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionButton: Button!
    
    var action: (()->())?
    
    init(injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "ErrorView") {
        self.presenter = injector.instanceOf(ErrorPresenter.self)
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(using type: ErrorViewType) {
        loadViewIfNeeded()
        
        switch type {
        case .noData:
            break
            
        case .error(let description):
            break
        }
    }
    
    @IBAction func didTapActionButton(_ sender: Button) {
        action?()
    }
}
