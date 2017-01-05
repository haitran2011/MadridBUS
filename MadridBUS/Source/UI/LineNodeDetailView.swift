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
    @IBOutlet weak var lineScheme: LineScheme!
    @IBOutlet weak var dataWrapper: UIView!
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
        
        dataWrapper.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
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
    }
    
    func update(withNodes nodes: [LineSchemeNodeModel]) {
        var schemeTheme = LineSchemeTheme()
        schemeTheme.normalTitleFont = Fonts.standardRegular
        schemeTheme.normalForegroundColor = Colors.blue
        schemeTheme.normalTitleColor = Colors.blue
        schemeTheme.highlightedForegroundColor = Colors.midnight
        schemeTheme.highlightedBackgroundColor = Colors.blue
        schemeTheme.highlightedTitleColor = .white
        schemeTheme.highlightedTitleFont = Fonts.standardRegular
        schemeTheme.orientation = .horizontal
        
        lineScheme.update(with: nodes, direction: .forward, theme: schemeTheme, delegate: self)
    }
}

extension LineNodeDetailViewBase: LineSchemeDelegate {
    internal func lineScheme(lineScheme: LineScheme, didFinishLoadingWith nodes: [LineSchemeNodeModel]) {
        draw(nodes: nodes)
        
//        for i in 0..<nodes.count {
//            guard nodes.indices.contains(i), nodes.indices.contains(i + 1) else {
//                continue
//            }
//            
//            let originNode = nodes[i]
//            let destinationNode = nodes[i + 1]
//            
//            let source = CLLocationCoordinate2D(latitude: originNode.latitude!, longitude: originNode.longitude!)
//            let destination = CLLocationCoordinate2D(latitude: destinationNode.latitude!, longitude: destinationNode.longitude!)
//            
//            let geodesicPolyline = MKGeodesicPolyline(coordinates: [source, destination], count: 2)
//            
//            lineMap.add(geodesicPolyline)
//            
//            drawRoute(from: source, to: destination)
//        }
    }

    private func draw(nodes: [LineSchemeNodeModel]) {
        lineMap.removeAnnotations(lineMap.annotations)
        
        var annotations: [NodeAnnotation] = []
        for aNode in nodes {
            guard let lat = aNode.latitude, let lon = aNode.longitude else {
                return
            }
            
            let annotation = NodeAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.nodeId = "\(aNode.id)"
            annotations.append(annotation)
        }
        
        lineMap.showAnnotations(annotations, animated: true)
    }
    
    private func drawRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        let directionsRequest = MKDirectionsRequest()
        let source = MKPlacemark(coordinate: from, addressDictionary: nil)
        let destination = MKPlacemark(coordinate: to, addressDictionary: nil)
        
        directionsRequest.source = MKMapItem(placemark: source)
        directionsRequest.destination = MKMapItem(placemark: destination)
        directionsRequest.requestsAlternateRoutes = false
        directionsRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate(completionHandler: { response, error in
            
            if error == nil {
                if response!.routes.count > 1 {
                    
                }
                
                let route = response!.routes[0] as MKRoute
                self.lineMap.add(route.polyline)
            }
            
        })
    }
    
    internal func didTap(node: LineSchemeNodeModel) {
        if node.selected {
            lineMap.removeAnnotations(lineMap.annotations)
            
            guard let lat = node.latitude, let lon = node.longitude else {
                return
            }
            
            let annotation = NodeAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            annotation.nodeId = "\(node.id)"
            lineMap.addAnnotation(annotation)
            
            let region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: lat, longitude: lon), 100, 100)
            lineMap.setRegion(region, animated: true)
            lineMap.showsUserLocation = false
        } else {
            draw(nodes: lineScheme.nodes)
        }
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

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = .red
        lineView.lineWidth = 3
        
        return lineView
    }
}
