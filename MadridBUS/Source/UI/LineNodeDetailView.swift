import UIKit
import MapKit

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
    @IBOutlet weak var maxFreqLabel: UILabel!
    @IBOutlet weak var minFreqLabel: UILabel!
    @IBOutlet weak var scheduleTitleLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var lineMap: MKMapView!
    
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
        frequencyTitleLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_GENERALFREQ")
        
        maxFreqLabel.font = Fonts.standardRegular
        maxFreqLabel.textColor = .black
        maxFreqLabel.textAlignment = .left
        maxFreqLabel.numberOfLines = 1
        maxFreqLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_MAX", with: "\(line.frequency.max) min.")
        
        minFreqLabel.font = Fonts.standardRegular
        minFreqLabel.textColor = .black
        minFreqLabel.textAlignment = .left
        minFreqLabel.numberOfLines = 1
        minFreqLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_MIN", with: "\(line.frequency.min) min.")
        
        scheduleTitleLabel.font = Fonts.standardBold
        scheduleTitleLabel.textColor = Colors.blue
        scheduleTitleLabel.textAlignment = .left
        scheduleTitleLabel.numberOfLines = 1
        scheduleTitleLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_GENERALSCHEDULE")
        
        startTimeLabel.font = Fonts.standardRegular
        startTimeLabel.textColor = .black
        startTimeLabel.textAlignment = .left
        startTimeLabel.numberOfLines = 1
        startTimeLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_STARTTIME", with: Date.timeString(from: line.startTime))
        
        endTimeLabel.font = Fonts.standardRegular
        endTimeLabel.textColor = .black
        endTimeLabel.textAlignment = .left
        endTimeLabel.numberOfLines = 1
        endTimeLabel.text = LocalizedLiteral.localize(using: "LINENODESDETAIL_LB_ENDTIME", with: Date.timeString(from: line.endTime))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = line.name
        lineMap.delegate = self
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
        lineMap.removeAnnotations(lineMap.annotations)
        
        guard let lat = node.latitude, let lon = node.longitude else {
            return
        }
        
        let annotation = NodeAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        annotation.nodeId = "\(node.id)"
        lineMap.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        lineMap.setRegion(region, animated: true)
        lineMap.showsUserLocation = false
    }
}

extension LineNodeDetailViewBase: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let nodeAnnotation = annotation as! NodeAnnotation
        let annotationReuseId = "NodeAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: nodeAnnotation, reuseIdentifier: annotationReuseId)
            annotationView?.canShowCallout = false
            annotationView?.animatesDrop = true
            annotationView?.pinTintColor = Colors.blue
        } else {
            annotationView?.annotation = nodeAnnotation
        }
        
        return annotationView
    }
}
