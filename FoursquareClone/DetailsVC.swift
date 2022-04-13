//
//  DetailsVC.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 3.04.2022.
//

import UIKit
import MapKit
import Parse

class DetailsVC: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var placeTypelLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var choosenPlaceId = ""
    var choosenLatitude = Double()
    var choosenLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
       getDataFromParse()
    
    }
    
    func getDataFromParse() {
       
        // seçilen yeri detailsVC de göstermek için gerekli kod
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: choosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if error != nil {
                
            } else {
                if objects != nil {
                    if objects!.count > 0 {
                        let choosenPlaceObject = objects![0]
                        if let placeName = choosenPlaceObject.object(forKey: "name") as? String {
                            self.placeNameLabel.text = placeName
                        }
                        
                        if let placeType = choosenPlaceObject.object(forKey: "type") as? String {
                            self.placeTypelLabel.text = placeType
                        }
                        
                        if let placeComments = choosenPlaceObject.object(forKey: "comment") as? String {
                            self.commentsLabel.text = placeComments
                        }
                        
                        if let placeLatitude = choosenPlaceObject.object(forKey: "latitude") as? String {
                            if let placeLatitudeDouble = Double(placeLatitude) {
                                self.choosenLatitude = placeLatitudeDouble
                            }
                        }
                        
                        if let placeLongitude = choosenPlaceObject.object(forKey: "longitude") as? String {
                            if let placeLongitudeDouble = Double(placeLongitude) {
                                self.choosenLongitude = placeLongitudeDouble
                            }
                        }
                        
                        if let imageData = choosenPlaceObject.object(forKey: "image") as? PFFileObject {
                            imageData.getDataInBackground { data, error in
                                if error == nil {
                                    if data != nil {
                                        self.imageView.image = UIImage(data: data!)
                                    }
                                }
                            }
                        }
                        
                        // DetailVC içinde map e konumu aktarma
                        let location = CLLocationCoordinate2D(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
                        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
                        let region = MKCoordinateRegion(center: location, span: span)
                        self.mapView.setRegion(region, animated: true)
                        
                        //Annotation ekleme
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = self.placeNameLabel.text
                        annotation.subtitle = self.placeTypelLabel.text
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // Konum üzerinde oluşturlan details butonuna tıklanınca navigasyona erişim sağlayan metod
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.choosenLatitude != 0.0 && self.choosenLongitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.choosenLatitude, longitude: self.choosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
    }
}
