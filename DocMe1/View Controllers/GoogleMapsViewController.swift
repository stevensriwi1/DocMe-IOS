import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

  // You don't need to modify the default init(nibName:bundle:) method.

  override func viewDidLoad() {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    let camera = GMSCameraPosition.camera(withLatitude: -37.8184, longitude: 144.9525, zoom: 15.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
    view = mapView

    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: -37.8184, longitude: 144.9525)
    marker.title = "Sydney"
    marker.snippet = "Australia"
    marker.map = mapView
  }
}
