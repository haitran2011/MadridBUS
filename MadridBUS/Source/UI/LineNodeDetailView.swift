import UIKit

protocol LineNodeDetailView: View {
    func update(withNodes nodes: [BusNodeLocalized])
}

class LineNodeDetailViewBase: UIViewController, LineNodeDetailView {
    internal var presenter: LineNodeDetailPresenter

    private var line: BusGeoLine?
    private var nodeFrom: BusGeoNode?
    private var nodes: [BusNodeLocalized]?
    
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var schemeScroll: UIScrollView!
    @IBOutlet weak var frequencyTitleLabel: UILabel!
    @IBOutlet weak var frequencyDataLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    init(with line: BusGeoLine, from node: BusGeoNode, with nodes: [BusNodeLocalized], injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "LineNodeDetailView") {
        self.presenter = injector.instanceOf(LineNodeDetailPresenter.self)
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
        
        self.line = line
        self.nodeFrom = node
        self.nodes = nodes
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        directionSegmentedControl.tintColor = Colors.blue
        directionSegmentedControl.removeAllSegments()
        directionSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "ChevronUp"), at: 0, animated: false)
        directionSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "ChevronDown"), at: 1, animated: false)
        directionSegmentedControl.selectedSegmentIndex = 0
        
        frequencyTitleLabel.font = Fonts.standardBold
        frequencyTitleLabel.textColor = Colors.blue
        frequencyTitleLabel.textAlignment = .left
        frequencyTitleLabel.numberOfLines = 1
        
        frequencyDataLabel.font = Fonts.standardRegular
        frequencyDataLabel.textColor = .black
        frequencyDataLabel.textAlignment = .left
        frequencyDataLabel.numberOfLines = 0
        frequencyDataLabel.lineBreakMode = .byWordWrapping
        
        frequencyTitleLabel.text = "FRECUENCIA GENERAL"
        frequencyDataLabel.text = "Máxima: \(line!.frequency.max) min.\nMínima: \(line!.frequency.min) min."
        
        scheduleTitleLabel.font = Fonts.standardBold
        scheduleTitleLabel.textColor = Colors.blue
        scheduleTitleLabel.textAlignment = .left
        scheduleTitleLabel.numberOfLines = 1
        scheduleTitleLabel.text = "HORARIO GENERAL"
        
        startTimeLabel.font = Fonts.standardRegular
        startTimeLabel.textColor = .black
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 1
        startTimeLabel.text = "Inicio: \(Date.string(from: line!.startTime, using: "hh:mm a"))"
        
        endTimeLabel.font = Fonts.standardRegular
        endTimeLabel.textColor = .black
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 1
        endTimeLabel.text = "Final: \(Date.string(from: line!.endTime, using: "hh:mm a"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = line?.name
    }
    
    func update(withNodes nodes: [BusNodeLocalized]) {
        
    }
}

