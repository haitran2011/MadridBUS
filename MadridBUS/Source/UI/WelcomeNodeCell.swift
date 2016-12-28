import UIKit

class WelcomeNodeCell: UITableViewCell {
    
    @IBOutlet weak var busLineLabel: UILabel!
    @IBOutlet weak var nextBusTimeLabel: UILabel!
    @IBOutlet weak var spinnerETA: UIActivityIndicatorView!

    var line: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    private func commonInit() {
        busLineLabel.backgroundColor = Colors.blue
        busLineLabel.textAlignment = .center
        busLineLabel.font = Fonts.busLineName
        busLineLabel.textColor = .white
        busLineLabel.adjustsFontSizeToFitWidth = true
        
        nextBusTimeLabel.isHidden = true
    }
    
    func configure(using model: BusGeoLine) {
        line = model.name
        busLineLabel.text = model.name
    }
    
    func update(using arrivals: [BusGeoNodeArrival]?) {
        spinnerETA.isHidden = true
        
        guard let busArrivals = arrivals else {
            return
        }
    
        nextBusTimeLabel.text = String(busArrivals[0].ETA / 60)
        nextBusTimeLabel.isHidden = false
    }
}
