//
//  DetailViewController.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/4/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    // OUTLETS
    @IBOutlet weak var _interactionButton: UIBarButtonItem!
    @IBOutlet weak var _emptyLabel: UILabel!
    @IBOutlet weak var _collectionView: UICollectionView!
    @IBOutlet weak var _mapView: MKMapView!
    
    // PASSED VARIABLES
    var _coordinate: CLLocationCoordinate2D!
    var _urlArray: [URL]!
    
    // INSTANCE VARIABLES
    var _collectionViewLength = 32
    var _editing: Bool = false
    var _urlsToLoad: [URL] = []
    
    // OVERRIDE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.allowsMultipleSelection = true
        
        zoomOnLocation()
        placePin()
    }
    
    // ACTIONS
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func interactionButtonPressed(_ sender: Any) {
        
        // Editing Photos
        if _editing{
            
            // Get Selected Items
            guard let selected = self._collectionView.indexPathsForSelectedItems else{
                return
            }
            // Sort in an array going from back to front
            let s = selected.sorted().reversed()
            for index in s{
                _urlsToLoad.remove(at: index.row)
            }
            // Reset to !editing
            _editing = false
            displayInteractionMode()
        }
            
        // New Collection
        else{
            // Repopulate List, includes all images that have been removed in the past
            populateURLSToLoad()
        }
        
        // Reload Collection View
        DispatchQueue.main.async() {
            self._collectionView.reloadData()
        }
    }
    
    
    
    // INTERAL METHODS
    internal func populateURLSToLoad(){
       
        guard var urlCopy = _urlArray else{
            //Error
            return
        }
        
        guard _urlArray.count > 0 else{
            // No Image Dialoge
            return
        }
        
        // Set max length
        var count = _collectionViewLength
        if _collectionViewLength > _urlArray.count{
            count = _urlArray.count
        }
        
        // Create array
        _urlsToLoad.removeAll()
        for _ in 0..<count{
            let r = Int( arc4random_uniform(UInt32(urlCopy.count)) )
            _urlsToLoad.append(urlCopy[r])
            urlCopy.remove(at: r)
        }
    }
    internal func displayInteractionMode(){
       
        // Editing photos
        if _editing{
            _interactionButton.title = "Remove Selected Pictures"
        }
        // New Collection
        else{
            _interactionButton.title = "New Collection"
        }
    }
   
    // PRIVATE METHODS
    private func zoomOnLocation(){
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: _coordinate, span: span)
        _mapView.setRegion(region, animated: true)
    }
    private func placePin(){
        let a = MKPointAnnotation()
        a.coordinate = _coordinate
        _mapView.addAnnotation(a)
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? NetworkImageCollectionViewCell else {
            return
        }
        
        cell.setSelected(selected: true)
        
        _editing = true
        displayInteractionMode()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? NetworkImageCollectionViewCell else {
            return
        }
        
        cell.setSelected(selected: false)
        
        guard let selected = collectionView.indexPathsForSelectedItems else{
            return
        }
        
        if selected.count == 0{
            _editing = false
        }
        
        displayInteractionMode()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if _urlsToLoad.count == 0{
            _emptyLabel.isHidden = false
            return 0
        }
    
         _emptyLabel.isHidden = true
        return _urlsToLoad.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? NetworkImageCollectionViewCell else{
            return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        }
        
        cell._url = _urlsToLoad[indexPath.row]
        cell.pull()
        cell.setSelected(selected: false)
        
        return cell
    }
}
