import UIKit
import MapKit

protocol WelcomeView: View {
    func updateMap(with location: CLLocation)
}

class WelcomeViewBase: UIViewController, WelcomeView {
    private var presenter: WelcomePresenter
    
    internal let nodeCell = "NodeCell"
    
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
        
        nodesTable.register(WelcomeNodeCell.self, forCellReuseIdentifier: nodeCell)
        nodesTable.delegate = self
        nodesTable.dataSource = self
        
        locationMap.delegate = self
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

extension WelcomeViewBase: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: nodeCell, for: indexPath) as! WelcomeNodeCell
        
        return cell
    }
}

extension WelcomeViewBase: MKMapViewDelegate {
    
}
