import UIKit
import MapKit

protocol WelcomeView: View {
    func updateMap(with location: CLLocation)
}

class WelcomeViewBase: UIViewController, WelcomeView {
    private var presenter: WelcomePresenter
    
    @IBOutlet weak var locationMap: MKMapView!
    @IBOutlet weak var nodesTable: UITableView!
    
    init(injector: Injector = SwinjectInjectorProvider.injector, nibName: String? = "WelcomeView") {
        self.presenter = injector.instanceOf(WelcomePresenter.self)
        super.init(nibName: nibName, bundle: nil)
        presenter.config(using: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        nodesTable.delegate = self
        nodesTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        presenter.obtainLocation()
    }
    
    func updateMap(with location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        locationMap.setRegion(region, animated: true)
    }
}
