//
//  SCLoacationMannage.swift
//  Sohba
//
//  Created by Ahmed Fathy on 15/07/2021.
//

import Foundation
import CoreLocation

class LocationMannager : NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationMannager()
    
    var loactionMannager: CLLocationManager?
    
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        
        self.requestLoactionAcess()
    }
    
    
    func requestLoactionAcess(){
        
        if loactionMannager == nil{
            
            loactionMannager = CLLocationManager()
            loactionMannager!.delegate = self
            loactionMannager!.desiredAccuracy = kCLLocationAccuracyBest
            loactionMannager!.requestWhenInUseAuthorization()
            
        }else{
            
            print("We have alredy location Manager")
        }
        
        
    }
    
    
    func startUpdating(){
        loactionMannager!.startUpdatingLocation()
    }
    
    
    func stopUpdating(){
        
        if loactionMannager != nil{
            loactionMannager!.stopUpdatingLocation()
        }
    }
    
    
    
    //MARK: - Delegate Function
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last!.coordinate
        
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed To Get Loaction", error.localizedDescription)
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .notDetermined {
            self.loactionMannager!.requestAlwaysAuthorization()
        }
    }
    
}
