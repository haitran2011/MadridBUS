import UIKit

protocol WelcomeNodeCell: class {
    func update(using ETA: String, heading: String)
}

class WelcomeNodeCellBase: UITableViewCell, WelcomeNodeCell {
    
    internal var presenter: WelcomeNodeCellPresenter!
    
    @IBOutlet weak var busLineLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var nextBusTimeLabel: UILabel!
    @IBOutlet weak var spinnerETA: UIActivityIndicatorView!

    override func awakeFromNib() {
        let injector: Injector = SwinjectInjectorProvider.injector
        presenter = injector.instanceOf(WelcomeNodeCellPresenter.self)
        presenter.config(using: self)
        
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        busLineLabel.backgroundColor = Colors.blue
        busLineLabel.textAlignment = .center
        busLineLabel.font = Fonts.busLineName
        busLineLabel.textColor = .white
        busLineLabel.adjustsFontSizeToFitWidth = true
        
        directionLabel.isHidden = true
        directionLabel.backgroundColor = .white
        directionLabel.textAlignment = .left
        directionLabel.font = Fonts.standardBold
        directionLabel.textColor = .black
        directionLabel.adjustsFontSizeToFitWidth = true
        
        nextBusTimeLabel.isHidden = true
        nextBusTimeLabel.backgroundColor = .white
        nextBusTimeLabel.textAlignment = .right
        nextBusTimeLabel.font = Fonts.standardLight
        nextBusTimeLabel.textColor = .black
        nextBusTimeLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(using model: BusGeoLine, on node: BusGeoNode) {
        busLineLabel.text = model.name
        
        presenter.nextArrival(at: model.name, on: node.id)
    }
    
    func update(using ETA: String, heading: String) {
        nextBusTimeLabel.text = ETA
        directionLabel.text = heading
        
        spinnerETA.isHidden = true
        nextBusTimeLabel.isHidden = false
        directionLabel.isHidden = false
    }
}