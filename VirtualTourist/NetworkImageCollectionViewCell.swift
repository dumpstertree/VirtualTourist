//
//  NetworkImageCollectionViewCell.swift
//  VirtualTourist
//
//  Created by Zachary Collins on 3/5/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit
class NetworkImageCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var _loadingView: UIView!
    @IBOutlet weak var _activityWheel: UIActivityIndicatorView!
    @IBOutlet weak var _imageView: UIImageView!
    var _url: URL!
    
    func pull(){
        
        _imageView.layer.cornerRadius = Constants.Visual.cornerRadius
        
        _imageView.isHidden = true
        _loadingView.isHidden = false
        _activityWheel.startAnimating()
        
        guard _url != nil else{
            return
        }
        
        FlickrAPI.downloadImage(url: _url){ image, error in
           
            guard error == nil else{
                return
            }
            guard image != nil else{
                return
            }
            
            self._imageView.isHidden = false
            self._loadingView.isHidden = true
            self._activityWheel.stopAnimating()
            
            self._imageView.image = image
        }
    }
    
    func setSelected( selected: Bool ){
        
        if selected{
            _imageView.layer.cornerRadius = Constants.Visual.cornerRadius
            _imageView.layer.borderWidth = Constants.Visual.selectBorderWidth
            _imageView.layer.borderColor = Constants.Visual.selectBorderColor
            _imageView.layer.masksToBounds = true
        }
        else{
            _imageView.layer.cornerRadius = Constants.Visual.cornerRadius
            _imageView.layer.borderWidth = 0
            _imageView.layer.borderColor = nil
            _imageView.layer.masksToBounds = true
        }
    }
}
