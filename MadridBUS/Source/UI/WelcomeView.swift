import UIKit
import MapKit

enum WelcomeViewMode {
    case fullMap(shouldReset: Bool, completionHandler: (()->())?)
    case foundNodesAround
    case zeroNodesAround
}

protocol WelcomeView: View {
    var nodesTableDataSet: [BusGeoNode] { get set }
    
    func updateMap(with location: CLLocation)
    func updateNodesTable()
    func enable(mode: WelcomeViewMode)
}

class WelcomeViewBase: UIViewController, WelcomeView {
    internal var presenter: WelcomePresenter
    internal var manualSearch = ManualSearchViewBase()
    internal var nodesTable = NodesNearTable()

    internal var nodesTableDataSet: [BusGeoNode] = [] {
        didSet {
            if nodesTableDataSet.count > 0 {
                enable(mode: .foundNodesAround)
            }
        }
    }
    
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
        
        presenter.nodesAround(using: 50)
    }
    
    func updateMap(with location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMap.setRegion(region, animated: true)
        locationMap.showsUserLocation = true
    }
    
    func updateMapForAnnotations() {
        for aNode in nodesTableDataSet {
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
            let section = nodesTableDataSet.index { (aNode) -> Bool in aNode.id == selectedAnnotation.nodeId }!
            nodesTable.reloadData()
            nodesTable.scrollToRow(at: IndexPath(item: 0, section: section), at: .middle, animated: true)
        }
    }
    
    func enable(mode: WelcomeViewMode) {
        switch mode {
        case .fullMap(let shouldReset, let completionHandler):
            locationMap_heightConstraint.constant = 0
            animateBottomWrapper(forShowing: false, shouldReset: shouldReset, completionHandler: completionHandler)
            
        case .foundNodesAround:
            nodesTable.show(over: contentWrapper, delegating: self, sourcing: self)
            view.layoutIfNeeded()
            animateBottomWrapper(forShowing: true)
            
        case .zeroNodesAround:
            manualSearch.show(over: contentWrapper, delegating: self)
            view.layoutIfNeeded()
            animateBottomWrapper(forShowing: true)
        }
    }
    
    private func animateBottomWrapper(forShowing shouldShow: Bool, shouldReset: Bool = false, completionHandler: (() -> ())? = nil) {
        if shouldShow {
            locationMap_heightConstraint.constant = -view.bounds.size.height * 0.5
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.updateMapForAnnotations()
                }
            }
        } else {
            locationMap_heightConstraint.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                if completed {
                    self.nodesTable.hide()
                    self.manualSearch.hide()
                    
                    if shouldReset {
                        self.nodesTableDataSet.removeAll()
                        self.locationMap.removeAnnotations(self.locationMap.annotations)
                    }
                    
                    completionHandler?()
                }
            }
        }
    }
}

extension WelcomeViewBase: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return nodesTableDataSet.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: nodesTable.headerReuseId) as! NodesNearTableHeader
        header.titleLabel.text = nodesTableDataSet[section].address
        return header
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodesTableDataSet[section].lines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nodesTable.cellReuseId, for: indexPath) as! NodesNearTableCellBase
        
        let model = nodesTableDataSet[indexPath.section].lines[indexPath.row]
        
        if shouldHighlightNodeCell(at: indexPath.section) {
            cell.configure(using: model, on: nodesTableDataSet[indexPath.section], highlighted: true)
        } else {
            cell.configure(using: model, on: nodesTableDataSet[indexPath.section], highlighted: false)
        }
        
        return cell
    }
    
    private func shouldHighlightNodeCell(at section: Int) -> Bool {
        if let currentNodeId = (locationMap.selectedAnnotations.first as? NodeAnnotation)?.nodeId {
            if nodesTableDataSet[section].id == currentNodeId {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! NodesNearTableCell
        
        guard let line = cell.line, let node = cell.node else {
            return
        }
        
        presenter.nodes(on: line, from: node)
    }
}

extension WelcomeViewBase: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let nodeAnnotation = annotation as! NodeAnnotation
        let annotationReuseId = "BusNodeAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseId) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: nodeAnnotation, reuseIdentifier: annotationReuseId)
            annotationView?.canShowCallout = true
            annotationView?.animatesDrop = true
            annotationView?.pinTintColor = Colors.blue
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

extension WelcomeViewBase: ManualSearchViewDelegate {
    func didSelect(radius: Int) {
        enable(mode: .fullMap(shouldReset: true, completionHandler: { 
            self.presenter.nodesAround(using: radius)
        }))
    }
}
