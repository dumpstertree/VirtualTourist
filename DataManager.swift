//
//  DataManager.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import MapKit
import CoreData

class DataManager{
    
    private static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private static let context     = appDelegate.persistentContainer.viewContext
    
    class Save{
        static func mapTransform( coordinate: CLLocationCoordinate2D ){
            var mapTransform: MapTransform!
            
            // Try Load
            do {
                guard let mapTransforms = try context.fetch(MapTransform.fetchRequest()) as? [MapTransform] else{
                    throw DataError.FetchFailed
                }
                if mapTransforms.count == 0{
                    throw DataError.ListEmpty
                }
                mapTransform = mapTransforms[0]
            }
                
            // Else New
            catch{
                if mapTransform == nil{
                    mapTransform = MapTransform(context: context)
                }
            }
            
            // Save
            mapTransform.latitude  = coordinate.latitude
            mapTransform.longitude = coordinate.longitude
            appDelegate.saveContext()
        }
        static func annotations( annotations: [MKAnnotation] ){
            
            var tourSpots: [TourSpot]!
            
            // Try Load
            do {
                guard let savedTourSpots = try context.fetch(MapTransform.fetchRequest()) as? [TourSpot] else{
                    throw DataError.FetchFailed
                }
                tourSpots = savedTourSpots
            }
            // Else New
            catch{
                 tourSpots = []
            }

            
            for tourSpot in tourSpots{
                tourSpots.append(<#T##newElement: Element##Element#>)
            }
            
            // Save
            //mapTransform.latitude  = coordinate.latitude
            //mapTransform.longitude = coordinate.longitude
            appDelegate.saveContext()
        }
    }
    
    static func load() -> CLLocationCoordinate2D? {
        
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            guard let mapTransforms = try context.fetch(MapTransform.fetchRequest()) as? [MapTransform] else{
                return nil
            }
        
            if mapTransforms.count > 0{
                let lat = mapTransforms[0].latitude
                let lon = mapTransforms[0].longitude
                
                return CLLocationCoordinate2DMake(lat, lon)
            }
        } catch {
            print("Fetching Failed")
        }
        
        return nil
    }
    
    private enum DataError : Error {
        case FetchFailed
        case ListEmpty
    }
}
