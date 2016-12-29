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
        contentView.backgroundColor = .clear
        accessoryType = .detailButton
        tintColor = Colors.blue
        
        busLineLabel.backgroundColor = Colors.blue
        busLineLabel.textAlignment = .center
        busLineLabel.font = Fonts.busLineName
        busLineLabel.textColor = .white
        busLineLabel.adjustsFontSizeToFitWidth = true
        busLineLabel.layer.borderColor = UIColor.white.cgColor
        
        directionLabel.isHidden = true
        directionLabel.backgroundColor = .clear
        directionLabel.textAlignment = .left
        directionLabel.font = Fonts.standardRegular
        directionLabel.textColor = .black
        directionLabel.numberOfLines = 1
        directionLabel.lineBreakMode = .byTruncatingTail
        
        nextBusTimeLabel.isHidden = true
        nextBusTimeLabel.backgroundColor = .clear
        nextBusTimeLabel.textAlignment = .right
        nextBusTimeLabel.font = Fonts.standardSemibold
        nextBusTimeLabel.textColor = .black
        nextBusTimeLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configure(using model: BusGeoLine, on node: BusGeoNode, highlighted: Bool) {
        busLineLabel.text = model.name
        if highlighted {
            backgroundColor = Colors.green
            tintColor = .white
            nextBusTimeLabel.textColor = .white
            busLineLabel.layer.borderWidth = 2
            directionLabel.textColor = .white
        } else {
            backgroundColor = .white
            tintColor = Colors.blue
            nextBusTimeLabel.textColor = .black
            busLineLabel.layer.borderWidth = 0
            directionLabel.textColor = .black
        }
        
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
