//
//  PlaceModelWithSingleton.swift
//  FoursquareClone
//
//  Created by Ali Osman DURMAZ on 3.04.2022.
//

import Foundation
import UIKit

class PlaceModelWithSingleton {
    static let sharedInstance = PlaceModelWithSingleton()
    
    var placeName = ""
    var placeType = ""
    var placeComments = ""
    var placeImage = UIImage()
    var placeLatitude = ""
    var placeLongitude = ""
    
    private init (){}
}
