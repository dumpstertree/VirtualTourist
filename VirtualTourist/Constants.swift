//
//  Constants.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class Constants{
   
    struct Visual{
        static let selectBorderWidth: CGFloat = 5
        static let selectBorderColor: CGColor = UIColor.cyan.cgColor
        static let cornerRadius: CGFloat = 5.0
    }
    struct Flickr{
        struct Keys{
            static let method:    String = "method"
            static let api_key:   String = "api_key"
            static let latitude:  String = "lat"
            static let longitude: String = "lon"
            static let extras:    String = "extras"
            static let format:    String = "format"
            static let callback:  String = "nojsoncallback"
            
        }
        struct Values {
            static let method:   String = "flickr.photos.search"
            static let api_key:  String = "357586a746612b8d59cb8c65b4bb9309"
            static let extras:   String = "url_m"
            static let format:   String = "json"
            static let callback: String = "1"
        }
    }
}
