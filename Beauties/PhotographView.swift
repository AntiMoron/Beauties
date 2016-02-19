//
//  PhotoGraphView.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/6.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
import UIKit


class PhotographView : UIView
{
    // MARK: initialization
    private func commonInit()
    {
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(photo)
    }
    init()
    {
        super.init(frame: CGRectZero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    // MARK: private variables
    private static let borderSize : CGFloat = 3;
    private var photo = UIImageView()
    private var __width : CGFloat = 0
    private var __height : CGFloat = 0
    // MARK: internal variables
    enum FocusOn
    {
        case Width,Height
    }
    internal var focusOn : FocusOn = .Width
    //MARK: computed properties
    internal var width : CGFloat
    {
        set
        {
            __width = newValue
            updateFrame(self.frame)
        }
        get{return __width;}
    }
    internal var height : CGFloat
    {
        set
        {
            __height = newValue
            updateFrame(self.frame)
        }
        get{return __height;}
    }
    internal override var frame : CGRect
    {
        didSet
        {
            updateFrame(super.frame)
        }
    }
    // MARK: helper method
    private func updateFrame(newValue : CGRect)
    {
        let borderSize = PhotographView.borderSize
        if(self.width == 0 || self.height == 0){
            return
        }
        if(focusOn == .Width){
            let aspect = self.height / self.width
            let picWidth = newValue.size.width - 2 * borderSize
            let picHeight = picWidth * aspect
            super.frame = CGRectMake(newValue.origin.x,newValue.origin.y,
                newValue.size.width,
                picHeight + 2 * borderSize)
            self.photo.frame = CGRectMake(borderSize,borderSize,picWidth,picHeight)
        }else{
            let aspect = self.width / self.height
            let picHeight = newValue.size.height - 2 * borderSize
            let picWidth = picHeight * aspect
            super.frame = CGRectMake(newValue.origin.x,newValue.origin.y,
                picWidth + 2 * borderSize,
                newValue.size.height)
            self.photo.frame = CGRectMake(borderSize,borderSize,picWidth,picHeight)
        }
    }
    // MARK: module exposed method
    /// To load picture from an url
    internal func loadData(url : String, callback : Void->Void)
    {
        photo.downloadedFrom(url, contentMode: .ScaleAspectFit,animated:true)
        {
            dispatch_async(dispatch_get_main_queue()){
                self.width = self.photo.image!.size.width
                self.height = self.photo.image!.size.height
                callback()
            }
        }
    }
    
    internal func getImage() -> UIImage?
    {
        return self.photo.image
    }
}