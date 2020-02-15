import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

    
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
  // You don't need to modify the default init(nibName:bundle:) method.
 
  override func viewDidLoad() {
    // Create a GMSCameraPosition that tells the map to display the specific coordinates
    let camera = GMSCameraPosition.camera(withLatitude: -37.8184, longitude: 144.9525, zoom: 15.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    view = mapView

    marker.snippet = user?.firstname as? String
    marker.position = CLLocationCoordinate2D(latitude: -37.8184, longitude: 144.9525)
    marker.title = "I am Here!"
    marker.map = mapView
  }
    var user: User?
    {
        didSet{
            marker.snippet = (user?.firstname as? String)! + " " + (user?.lastname as? String)!
            
        }
    }
}
