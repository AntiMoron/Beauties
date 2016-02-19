//
//  UIImage+Network.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
            }
        }).resume()
    }
    
    func downloadedFrom(link:String, contentMode mode: UIViewContentMode,animated:Bool, callback: Void->Void) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.image = image
                if animated {
                    self.alpha = 0.0
                    UIImageView.animateWithDuration(1.5, animations: {
                        self.alpha = 1.0
                        callback()
                        })
                    self.alpha = 1.0
                } else {
                    self.alpha = 1.0
                    callback()
                }
            }
        }).resume()
    }
}