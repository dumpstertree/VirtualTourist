//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/4/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var _deleteView: UIView!
    @IBOutlet weak var _editToolbarButton: UIBarButtonItem!
    @IBOutlet weak var _mapView: MKMapView!
    var _editing: Bool = false
    
    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        _mapView.delegate = self
        
        attemptToLoadStoredMapTransform()
    }
    
    // Actions
    @IBAction func longPress(sender: UILongPressGestureRecognizer){
        
        guard !_editing else{
            return
        }
        
        if (sender.state == .began){
            let touchLocation = sender.location(in: _mapView)
            let mapLocation = _mapView.convert(touchLocation, toCoordinateFrom: _mapView)
            addAnnotation( coordinate: mapLocation )
        }
    }
    @IBAction func editButtonPressed(sender: AnyObject){
        
        _editing = !_editing
        
        // Editing
        if _editing{
            _editToolbarButton.title = "Done"
            _mapView.frame.origin.y -= _deleteView.frame.height
            _deleteView.frame.origin.y -= _deleteView.frame.height
        }
            
        // Placing
        else{
            _editToolbarButton.title = "Edit"
            _mapView.frame.origin.y += _deleteView.frame.height
            _deleteView.frame.origin.y += _deleteView.frame.height
        }
    }
    
    // Helpers
    internal func attemptToLoadStoredMapTransform(){
        
        guard let savedCoord = DataManager.load() else{
            print("noooooo")
            return
        }
        print(savedCoord)
        
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: savedCoord, span: span)
        _mapView.setRegion(region, animated: true)
        _mapView.centerCoordinate = savedCoord
    }
    internal func addAnnotation( coordinate: CLLocationCoordinate2D ){
        let a = MKPointAnnotation()
        a.coordinate = coordinate
        _mapView.addAnnotation(a)
    }
    internal func removeAnnotation( annotation: MKAnnotation ){
        _mapView.removeAnnotation( annotation )
    }
    internal func segueToDetailView( coordinate: CLLocationCoordinate2D ){
       
        FlickrAPI.GetCollectionUrlForLocation(coordinate: coordinate){ urlArray, error in
            
            guard error == nil else{
                // Dislplay Error
                return
            }
            
            guard urlArray != nil else{
                // Display Error
                return
            }
            
            DispatchQueue.main.async() { () -> Void in
                
                let viewController: DetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                
                viewController._coordinate = coordinate
                viewController._urlArray = urlArray
                viewController.populateURLSToLoad()
                
                self.present(viewController, animated: false, completion: nil)
            }
        }
    }
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        // Remove Annotation
        if _editing{
            for a in _mapView.selectedAnnotations{
                removeAnnotation(annotation: a)
            }
        }
            
        // Segue
        else{
            let coord = _mapView.selectedAnnotations[0].coordinate
            segueToDetailView( coordinate: coord )
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        DataManager.Save.mapTransform(coordinate: _mapView.centerCoordinate)
    }
}
