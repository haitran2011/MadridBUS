import Foundation
import CoreLocation

protocol LocationHelper {
    var isLocationAvailable: Bool {get}
    
    func acquireLocation(success: @escaping (CLLocation) -> ())
    func stopAcquiringLocation()
}

class LocationHelperBase: NSObject, LocationHelper {
    var isLocationAvailable: Bool = false
    
    private let locationManager = CLLocationManager()
    
    internal var locationAcquiredSuccessBlock: ((CLLocation) -> ())?
    
    override init() {
        super.init()

        if CLLocationManager.locationServicesEnabled() && CLLocationManager.authorizationStatus() == .authorizedAlways {
            isLocationAvailable = true
        } else {
            if CLLocationManager.authorizationStatus() == .notDetermined {
                manageLocationAuthorization()
            } else {
                isLocationAvailable = false
            }
        }
    }
    
    func acquireLocation(success: @escaping (CLLocation) -> ()) {
        locationManager.startUpdatingLocation()
        locationAcquiredSuccessBlock = success
        locationManager.delegate = self
    }
    
    func stopAcquiringLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func manageLocationAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension LocationHelperBase: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for aLocation in locations {
            if aLocation.horizontalAccuracy <= 10 {
                locationAcquiredSuccessBlock!(aLocation)
                stopAcquiringLocation()
                break
            }
        }
    }
}
