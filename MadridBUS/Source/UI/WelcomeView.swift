import UIKit
import MapKit

enum WelcomeViewMode {
    case foundNodesAround
    case zeroNodesAround
}

protocol WelcomeView: View {
    func updateMap(with location: CLLocation)
    func updateBusNodes()
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
        //contentWrapper.backgroundColor = Colors.blue
        locationMap.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.obtainLocation()
    }
    
    func updateMap(with location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMap.setRegion(region, animated: true)
        locationMap.showsUserLocation = true
    }
    
    func updateBusNodes() {
        enable(mode: .foundNodesAround)
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
        UIView.animate(withDuration: 5.5) {
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
        cell.configure(using: model, on: presenter.node(at: indexPath.section))

        return cell
    }
}

extension WelcomeViewBase: MKMapViewDelegate {
    
}
