//
//  MapAnotation.swift
//  Sohba
//
//  Created by Ahmed Fathy on 15/07/2021.
//

import Foundation
import MapKit


class MapAnnotation: NSObject , MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    
    init(title: String , coordinate: CLLocationCoordinate2D){
        
        self.title = title
        self.coordinate = coordinate
    }
}
