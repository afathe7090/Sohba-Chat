//
//  SCMapViewController.swift
//  Sohba
//
//  Created by Ahmed Fathy on 15/07/2021.
//

import UIKit
import MapKit
import CoreLocation

class SCMapViewController: UIViewController {

    //MARK: - Variables
    
    
    
    var location: CLLocation?
    var mapView: MKMapView!
    
    
    
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Map View"
        configureMapView()
        configureLeftBarButton()
        
    }
    
    
    
    
    //MARK: - Map View
    private func configureMapView(){
        
        mapView = MKMapView(frame: view.frame)
        mapView.showsUserLocation = true
        
        self.tabBarController?.tabBar.isHidden = true
        
        if location != nil {
            mapView.setCenter(location!.coordinate, animated: false)
            
            mapView.addAnnotation(MapAnnotation(title: "User Annotation", coordinate: location!.coordinate))
        }
        
        view.addSubview(mapView)
    }
    
    
    
    
    
    //MARK: - configureBack Button
    private func configureLeftBarButton() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
    }
    
    
    
    @objc func backButtonPressed() {
        
        self.navigationController?.popViewController(animated: true)
    }

    
}
