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
    
    func configureTitle(on label: UILabel, using localizedKeyString: String) {
        label.font = Fonts.listTitle
        label.text = LocalizedLiteral.localize(using: localizedKeyString)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.numberOfLines = 0
    }
    
    func configureDescription(on label: UILabel, using localizedKeyString: String) {
        label.font = Fonts.listSubtitle
        label.text = LocalizedLiteral.localize(using: localizedKeyString)
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        label.numberOfLines = 0
    }
    
    func configureIcon(on imageView: UIImageView, using image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
    }
    
    func configureButtonTitle(on button: Button, using localizedKeyString: String) {
        button.titleLabel?.font = Fonts.primaryButtonTitle
        button.backgroundColor = Colors.pink
        button.setTitle(LocalizedLiteral.localize(using: localizedKeyString), for: .normal)
        button.setTitleColor(.white, for: .normal)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
