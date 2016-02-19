//
//  JdanPictureSource.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
///adapt picture url list from jiandan
class JdanPictureSource : PictureSource{
    internal override init(){
        super.init()
        self.pictureUrlList = "http://jandan.net/?oxwlxojflwblxbsapi=jandan.get_ooxx_comments&page="
    }
    
    internal override func pictureUrlList(page:Int,callback:[String:AnyObject]? -> Void) {
        let url = NSURL(string:pictureUrlList! + String(page))
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url!) { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            if(error != nil || data == nil){
                print(error)
                callback(nil)
                return ;
            }
            do{
                let parsed = try NSJSONSerialization.JSONObjectWithData(data!,
                    options: NSJSONReadingOptions.AllowFragments)
                callback(parsed as? [String:AnyObject])
            }catch{
                print("Parse Json Error!!!")
            }
        }.resume()
    }
}