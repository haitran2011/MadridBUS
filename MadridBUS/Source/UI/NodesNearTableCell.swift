import UIKit

protocol NodesNearTableCell: class {
    var nextArrival: BusGeoNodeArrival? { get set }
    var line: BusGeoLine? { get }
    var node: BusGeoNode? { get }
    
    func update(using ETA: Int?, heading: String)
}

class NodesNearTableCellBase: UITableViewCell, NodesNearTableCell {
    internal var line: BusGeoLine?
    internal var node: BusGeoNode?

    internal var presenter: NodesNearTableCellPresenter!
    
    var nextArrival: BusGeoNodeArrival?
    
    @IBOutlet weak var busLineLabel: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var nextBusTimeLabel: UILabel!
    @IBOutlet weak var spinnerETA: UIActivityIndicatorView!

    override func awakeFromNib() {
        let injector: Injector = SwinjectInjectorProvider.injector
        presenter = injector.instanceOf(NodesNearTableCellPresenter.self)
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
        line = model
        self.node = node
        
        busLineLabel.text = model.id
        if model.id.characters.first == "N" {
            busLineLabel.backgroundColor = .black
            busLineLabel.textColor = Colors.yellow
        } else {
            busLineLabel.backgroundColor = Colors.blue
            busLineLabel.textColor = .white
        }
        
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
    
    func update(using ETA: Int?, heading: String) {
        var stringETA = ""
        
        if let currentETA = ETA {
            if currentETA < 60 && currentETA > 0{
                stringETA = LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_ARRIVING")
            } else if currentETA == 999999 {
                stringETA = "+ 20 min."
            } else if currentETA == 0 {
                stringETA = LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_STOPPED")
            } else {
                stringETA = "\(currentETA / 60) min."
            }
            
            directionLabel.text = LocalizedLiteral.localize(using: "WELCOMENODECELL_LB_DIRECTION", with: heading)
        } else {
            directionLabel.text = heading
        }
        
        nextBusTimeLabel.text = stringETA
        
        
        spinnerETA.isHidden = true
        nextBusTimeLabel.isHidden = false
        directionLabel.isHidden = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nextArrival = nil
        
        spinnerETA.isHidden = false
        nextBusTimeLabel.isHidden = true
        directionLabel.isHidden = true
    }
}
