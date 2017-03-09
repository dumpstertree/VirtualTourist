//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FlickrAPI {
    
    
    static public func GetCollectionUrlForLocation( coordinate: CLLocationCoordinate2D, completion: @escaping (_ url: [URL]?, _ error: Error?)->Void)  {
        
        let methodParameters: [String: String] = [
            Constants.Flickr.Keys.method    :   Constants.Flickr.Values.method,
            Constants.Flickr.Keys.api_key   :   Constants.Flickr.Values.api_key,
            Constants.Flickr.Keys.latitude  :   String( coordinate.latitude ),
            Constants.Flickr.Keys.longitude :   String( coordinate.longitude ),
            Constants.Flickr.Keys.extras    :   Constants.Flickr.Values.extras,
            Constants.Flickr.Keys.format    :   Constants.Flickr.Values.format,
            Constants.Flickr.Keys.callback  :   Constants.Flickr.Values.callback
        ]
        
        let session = URLSession.shared
        let request = URLRequest(url: flickrURLFromParameters(parameters: methodParameters))
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil{
                print("ERROR: \(error)")
            }
            
            if error == nil{
                
                let parsedResult: NSDictionary!
                
                do {
                    parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                }
                catch {
                    return
                }
                
                // Photo Dictionary Info
                
                guard let photosDictionary = parsedResult["photos"] as? [String:AnyObject] else {
                    return
                }
                
                // Photo Array
                guard let photoArray = photosDictionary["photo"] as? NSArray else {
                    return
                }
                
                var urlArray: [URL] = []
                for i in 0..<photoArray.count{
                    
                    guard let photo = photoArray[i] as? [String:AnyObject] else{
                        continue
                    }
                    guard let photoURL = photo["url_m"] as? String else{
                        continue
                    }
                    guard let url = URL(string: photoURL) else{
                        continue
                    }
                    urlArray.append(url)
                }
                
                return completion( urlArray, nil)
            }
            
        }
        
        task.resume();
    }
    
    static private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    static public func downloadImage(url: URL, completion: @escaping (_  image: UIImage?, _ error: Error?) -> Void) {
        
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                return completion( image, nil )
            }
        }
    }
    
    static private func flickrURLFromParameters(parameters: [String:String]) -> URL {
        
        let components = NSURLComponents()
        components.scheme = "https"
        components.host   = "api.flickr.com"
        components.path   = "/services/rest"
        
        components.queryItems = [NSURLQueryItem]() as [URLQueryItem]?
        for (key, value) in parameters {
            let queryItem = NSURLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem as URLQueryItem)
        }
        
        return components.url!
    }
    
    
    
}

