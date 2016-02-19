//
//  PictureSource.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

///PictureSource to provide picture url list
class PictureSource
{
    private var singleToken = 0
    private var listUrl:String?;
    internal var pictureUrlList:String?
    {
        get{
            if(listUrl == nil){
                fatalError("You haven't bind any source url!!!")
            }
            return listUrl
        }
        set{
            if singleToken == 0 {
                listUrl = newValue
                singleToken = 1
            }else{
                fatalError("You cannot bind picture source url multiple times!!!")
            }
        }
    }
    internal func pictureUrlList(page:Int,callback:[String:AnyObject]? -> Void) {
        fatalError("You should implement this method yourself!!!")
    }
}