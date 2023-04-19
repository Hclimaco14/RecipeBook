//
//  MapViewController.swift
//  RecipeBook
//
//  Created by Hector Climaco on 16/04/23.
//  
//

import UIKit
import MapKit

protocol MapDisplayLogic {
    
}

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Variables
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D()
    var interactor: MapBusinessLogic?
    var router: MapRoutingLogic?
    var recipe = RecipeResponse(){
        didSet {
            recipeVM = Map.ViewModel(recipe: recipe)
        }
    }
    private var recipeVM = Map.ViewModel()
    
    // MARK: - Object Lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Commons.validateLocationPermissions(view: self) {
            setUpMapView()
            loadRecipeInMap()
        }
    }
    
    // MARK: - Configurators
    
    fileprivate func setup() {
        
        let viewcontroller   = self
        let interactor      = MapInteractor()
        let presenter       = MapPresenter()
        let router          = MapRouter()
        
        viewcontroller.interactor = interactor
        viewcontroller.router     = router
        interactor.presenter      = presenter
        presenter.view            = viewcontroller
        router.view               = viewcontroller
    }
    
    fileprivate func setUpMapView() {
        
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager = CLLocationManager()
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager.requestAlwaysAuthorization()
                self.locationManager.startUpdatingLocation()
                self.mapView.showsUserLocation = true
                self.mapView.delegate = self
            }
    }
    
    func centerInMap(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let distance = origin.toCLLocation().distance(from: destination.toCLLocation()) * 2
        let region = MKCoordinateRegion(center: destination, latitudinalMeters: distance, longitudinalMeters: distance)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: - Private
    func setUpAnnotations(annotations: [RecipeAnnotation] ) {
        for annotation in annotations {
            mapView.addAnnotation(annotation)
        }
    }
    
    func loadRecipeInMap() {
        mapView.addAnnotation(recipeVM.annotation)
        mapView.tintColor = RecipeBookColor.Purple
    }
    
    func goToPoint(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D,
                   transportType:  MKDirectionsTransportType = .automobile) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: origin, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType =  [.automobile, .walking]
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            DispatchQueue.main.async {
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc func navitaionToPoint() {
        goToPoint(origin: currentLocation, destination: recipeVM.location)
    }
    
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location.coordinate
        locationManager.stopUpdatingLocation()
        centerInMap(origin: location.coordinate, destination: recipeVM.location)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is RecipeAnnotation else { return nil }
        
        let identifier = "recipe"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let image = UIImage(named: "carrot")
            annotationView?.image = image
            let rightButton = UIButton(type: .detailDisclosure)
            rightButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
            rightButton.tintColor = RecipeBookColor.Purple
            
            rightButton.addTarget(self, action: #selector(self.navitaionToPoint), for: .touchUpInside)
            annotationView?.rightCalloutAccessoryView = rightButton
        } else {
            
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
    
}


extension MapViewController: MapDisplayLogic {
    
}
