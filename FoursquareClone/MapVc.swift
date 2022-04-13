//
//  MapVc.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 3.04.2022.
//

import UIKit
import MapKit
import Parse

class MapVc: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
    }
    
    @objc func chooseLocation(gestureRecognizer: UITapGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModelWithSingleton.sharedInstance.placeName
            annotation.subtitle = PlaceModelWithSingleton.sharedInstance.placeType
            self.mapView.addAnnotation(annotation)
            
            PlaceModelWithSingleton.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModelWithSingleton.sharedInstance.placeLongitude = String(coordinates.longitude)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }

    @objc func saveButtonClicked() { // Burada Parse içine kayıt işlemi oluşturuluyor...
        // PARSE
        let placeModel = PlaceModelWithSingleton.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["comment"] = placeModel.placeComments
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        // Görsel dosya çekme işlemi
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        //Kayıt işlemi
        object.saveInBackground { success, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "\(error?.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.destructive, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
                
            } else {
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    
    @objc func backButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

}
