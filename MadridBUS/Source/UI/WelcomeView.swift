import UIKit
import MapKit

enum WelcomeViewMode {
    case foundNodesAround
    case zeroNodesAround
}

protocol WelcomeView: View {
    func updateMap(with location: CLLocation)
    func updateMap(with nodes: [BusGeoNode])
    func updateNodesTable()
    func enable(mode: WelcomeViewMode)
}

class WelcomeViewBase: UIViewController, WelcomeView {
    internal var presenter: WelcomePresenter
    internal var manualSearch = ManualSearchViewBase()
    internal var nodesTable = NodesNearTable()
    
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var locationMap_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentWrapper: UIView!
    
    init(injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "WelcomeView") {
        self.presenter = injector.instanceOf(WelcomePresenter.self)
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentWrapper.backgroundColor = Colors.blue
        locationMap.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.obtainLocation()
    }
    
    func updateMap(with location: CLLocation) {
        //let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.382797016999334, longitude:  -3.7231069600644706), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMap.setRegion(region, animated: true)
        locationMap.showsUserLocation = true
    }
    
    func updateMap(with nodes: [BusGeoNode]) {
        for aNode in nodes {
            let annotation = NodeAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: aNode.latitude, longitude: aNode.longitude)
            annotation.title = "(\(aNode.id)) \(aNode.name)"
            annotation.nodeId = aNode.id
            locationMap.addAnnotation(annotation)
        }
    }
    
    func updateNodesTable() {
        enable(mode: .foundNodesAround)
        nodesTable.reloadData()
    }
    
    func updateNodesTable(with annotation: NodeAnnotation?) {
        if let selectedAnnotation = annotation {
            presenter.activeAnnotationId = selectedAnnotation.nodeId
        } else {
            presenter.activeAnnotationId = nil
        }
        
        nodesTable.reloadData()
    }
    
    func enable(mode: WelcomeViewMode) {
        switch mode {
        case .foundNodesAround:
            nodesTable.show(over: contentWrapper, delegating: self, sourcing: self)
            
        case .zeroNodesAround:
            manualSearch.show(over: contentWrapper)
        }
        
        view.layoutIfNeeded()
        
        locationMap_heightConstraint.constant = -view.bounds.size.height * 0.5
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

extension WelcomeViewBase: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.node(at: section).address
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nodesTable.nodeCell, for: indexPath) as! WelcomeNodeCellBase
        
        let model = presenter.model(at: indexPath)
        
        if presenter.shouldHighlightNodeCell(at: indexPath) {
            cell.configure(using: model, on: presenter.node(at: indexPath.section), highlighted: true)
        } else {
            cell.configure(using: model, on: presenter.node(at: indexPath.section), highlighted: false)
        }
        
        return cell
    }
}

extension WelcomeViewBase: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let nodeAnnotation = annotation as! NodeAnnotation
        let annotationReuseId = "BusNodeAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: nodeAnnotation, reuseIdentifier: annotationReuseId)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = nodeAnnotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        updateNodesTable(with: view.annotation as? NodeAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        updateNodesTable(with: nil)
    }
}
