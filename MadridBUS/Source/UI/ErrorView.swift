import UIKit

enum ErrorViewType {
    case continueProcess
    case waitingForAccountCreation
    case accountRejected
    case identityValidationRejected
    case pendingConfirmation
    case alreadyClient
    case taxesOutsideSpain
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
        case .continueProcess:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "ContinueHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-HELLO")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION-CONTINUE")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
            
        case .waitingForAccountCreation:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "DefaultHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-HELLO")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION-WAITING-FOR-CREATION")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
            
        case .accountRejected:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "DefaultHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-HELLO")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION-ACCOUNT-REJECTED")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
            
        case .identityValidationRejected:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "DefaultHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-HELLO")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION-IDENTITY-REJECTED")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
            
        case .pendingConfirmation:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "DefaultHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-HELLO")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION-PENDING-CONFIRMATION")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
        
        case .alreadyClient:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "ErrorViewHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-UPS")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION_ALREADY-CLIENT")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_FIND-OFFICE")
            
        case .taxesOutsideSpain:
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "ErrorViewHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-UPS")
            configureDescription(on: descriptionLabel, using: "ERRORVIEW_LB_DESCRIPTION_OUTSIDE-SPAIN")
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
            
        case .error(let description):
            configureIcon(on: imageView, using: #imageLiteral(resourceName: "ErrorViewHeaderImage"))
            configureTitle(on: titleLabel, using: "ERRORVIEW_LB_TITLE-UPS")
            configureDescription(on: descriptionLabel, using: description)
            configureButtonTitle(on: actionButton, using: "COMMON_BT_UNDERSTAND")
        }
    }
    
    @IBAction func didTapActionButton(_ sender: Button) {
        action?()
    }
}
