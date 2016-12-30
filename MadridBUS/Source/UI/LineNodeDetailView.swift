import UIKit

protocol LineNodeDetailView: View {
    func update(withNodes nodes: [LineSchemeNodeModel])
}

class LineNodeDetailViewBase: UIViewController, LineNodeDetailView {
    internal var presenter: LineNodeDetailPresenter
    
    private var line: BusGeoLine
    private var nodeFrom: BusGeoNode
    private var nodes: [BusNodeLocalized]
    
    @IBOutlet weak var directionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var schemeScroll: UIScrollView!
    @IBOutlet weak var frequencyTitleLabel: UILabel!
    @IBOutlet weak var frequencyDataLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    private var graphicLine: LineScheme?
    
    init(with line: BusGeoLine, from node: BusGeoNode, with nodes: [BusNodeLocalized], injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "LineNodeDetailView") {
        self.presenter = injector.instanceOf(LineNodeDetailPresenter.self)
        self.line = line
        self.nodeFrom = node
        self.nodes = nodes
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
    
        directionSegmentedControl.tintColor = Colors.blue
        directionSegmentedControl.removeAllSegments()
        directionSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "ChevronDown"), at: 0, animated: false)
        directionSegmentedControl.insertSegment(with: #imageLiteral(resourceName: "ChevronUp"), at: 1, animated: false)
        directionSegmentedControl.selectedSegmentIndex = 0
        directionSegmentedControl.addTarget(self, action: #selector(didChangeDirectionValue), for: .valueChanged)
        
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
        frequencyDataLabel.text = "Máxima: \(line.frequency.max) min.\nMínima: \(line.frequency.min) min."
        
        scheduleTitleLabel.font = Fonts.standardBold
        scheduleTitleLabel.textColor = Colors.blue
        scheduleTitleLabel.textAlignment = .left
        scheduleTitleLabel.numberOfLines = 1
        scheduleTitleLabel.text = "HORARIO GENERAL"
        
        startTimeLabel.font = Fonts.standardRegular
        startTimeLabel.textColor = .black
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 1
        startTimeLabel.text = "Inicio: \(Date.string(from: line.startTime, using: "hh:mm a"))"
        
        endTimeLabel.font = Fonts.standardRegular
        endTimeLabel.textColor = .black
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 1
        endTimeLabel.text = "Final: \(Date.string(from: line.endTime, using: "hh:mm a"))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = line.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.nodes(on: line.name)
    }
    
    func didChangeDirectionValue() {
        guard let currentGraphicLine = graphicLine else {
            return
        }
        
        switch directionSegmentedControl.selectedSegmentIndex {
        case 0: currentGraphicLine.change(to: .forward)
        case 1: currentGraphicLine.change(to: .backwards)
        default: return
        }
        
        schemeScroll.contentSize = CGSize(width: schemeScroll.bounds.width, height: currentGraphicLine.frame.height)
    }
    
    func update(withNodes nodes: [LineSchemeNodeModel]) {
        var schemeTheme = LineSchemeTheme()
        schemeTheme.titleFont = Fonts.standardRegular
        schemeTheme.normalBackgroundColor = .white
        schemeTheme.normalForegroundColor = Colors.blue
        schemeTheme.normalTitleColor = .black
        schemeTheme.highlightedBackgroundColor = Colors.blue
        schemeTheme.highlightedForegroundColor = Colors.red
        schemeTheme.highlightedTitleColor = .white
        
        schemeScroll.subviews.forEach({ $0.removeFromSuperview() })
        
        graphicLine = LineScheme(with: nodes, direction: .forward, theme: schemeTheme)
        graphicLine!.delegate = self
        graphicLine!.frame = CGRect(x: 0, y: 0, width: schemeScroll.bounds.width, height: graphicLine!.frame.height)
        schemeScroll.contentInset = .zero
        schemeScroll.addSubview(graphicLine!)
        schemeScroll.contentSize = CGSize(width: schemeScroll.bounds.width, height: graphicLine!.frame.height)
    }
}

extension LineNodeDetailViewBase: LineSchemeDelegate {
    func didTap(node: LineSchemeNodeModel) {
        
    }
}
