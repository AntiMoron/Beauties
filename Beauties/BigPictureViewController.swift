//
//  BigPictureViewController.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/6.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
import UIKit

class BigPictureViewController : UIViewController,UIActionSheetDelegate
{
    private var __pictureView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        self.view.addSubview(__pictureView)
        let tap = CustomizedTapGestureRecognizer(target:self,action:Selector("dismissSelf:"))
        let longPress = UILongPressGestureRecognizer(target: self, action: Selector("savePicture:"))
        let pinch = UIPinchGestureRecognizer(target: self, action: Selector("scalePicture:"))
        let pan = UIPanGestureRecognizer(target: self, action: Selector("movePicture:"))
        let doubleTap = UITapGestureRecognizer(target: self, action: Selector("resetPicture:"))
        doubleTap.numberOfTapsRequired = 2
        tap.requireGestureRecognizerToFail(doubleTap)
        self.view.addGestureRecognizer(doubleTap)
        self.view.addGestureRecognizer(tap)
        self.view.addGestureRecognizer(longPress)
        self.view.addGestureRecognizer(pinch)
        self.view.addGestureRecognizer(pan)
    }
    
    internal var pictureImage : UIImage
    {
        set
        {
            __pictureView.image = newValue
            let vcW = self.view.frame.size.width
            let vcH = self.view.frame.size.height
            let aspect = newValue.size.width / newValue.size.height
            let center = CGPoint(x:self.view.frame.size.width * 0.5,
                y:self.view.frame.size.height * 0.5)
            if(vcW < vcH){
                var w = vcW
                var h = vcW / aspect
                if(h > vcH){
                    h = vcH
                    w = h * aspect
                }
                __pictureView.frame = CGRectMake(center.x - (w * 0.5),
                    center.y - (h * 0.5), w, h)
            }else{
                var w = vcH * aspect
                var h = vcH
                if(w > vcW){
                    w = vcW
                    h = w / aspect
                }
                __pictureView.frame = CGRectMake(center.x - (w * 0.5),
                    center.y - (h * 0.5), w, h)
            }
        }
        get
        {
            return __pictureView.image!
        }
    }
    // MARK: gestures
    var currentTransform : CGAffineTransform? = nil
    internal func scalePicture(sender:UIPinchGestureRecognizer)
    {
        switch sender.state{
        case .Began:
            currentTransform = __pictureView.transform
            break
        case .Changed:
            __pictureView.transform = CGAffineTransformScale(currentTransform!,sender.scale,sender.scale)
            break
        case .Ended:
            //In case of picture too small
            let testPoint = CGPointMake(1, 1)
            let retPoint = CGPointApplyAffineTransform(testPoint, __pictureView.transform)
            if (retPoint.x < testPoint.x) && (retPoint.y < testPoint.y)
            {
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.__pictureView.transform = CGAffineTransformIdentity
                    self.__pictureView.center = self.view.center
                })
            }
        default:
            break
        }
    }
    var lastLocation : CGPoint?
    internal func movePicture(sender:UIPanGestureRecognizer)
    {
        switch sender.state
        {
        case .Began:
            lastLocation = sender.locationInView(self.view)
            break
        case .Changed:
            let curLocation = sender.locationInView(self.view)
            let location = lastLocation!
            let offset = CGPointMake(curLocation.x - location.x,curLocation.y - location.y)
            let curCenter = __pictureView.center
            __pictureView.center = CGPointMake(curCenter.x + offset.x,curCenter.y + offset.y)
            lastLocation = curLocation
            break
        case .Ended:
            //In case of picture moved out of window
            let picCenter = __pictureView.center
            let screenCenter = self.view.center
            let picSize = __pictureView.frame.size
            let xBound = picSize.width * CGFloat(0.5)
            let yBound = picSize.height * CGFloat(0.5)
            if (abs(picCenter.x - screenCenter.x) > xBound) ||
                (abs(picCenter.y - screenCenter.y) > yBound)
            {
                var x = picCenter.x - screenCenter.x
                var y = picCenter.y - screenCenter.y
                if(abs(x) > xBound)
                {
                    if(x < 0)
                    {
                        x = -xBound
                    }
                    else
                    {
                        x = xBound
                    }
                }
                if(abs(y) > yBound)
                {
                    if(y < 0)
                    {
                        y = -yBound
                    }
                    else
                    {
                        y = yBound
                    }
                }
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.__pictureView.center = CGPointMake(self.view.center.x + x,self.view.center.y + y)
                })
            }
            break
        default:
            break
        }
    }
    //long press
    internal func savePicture(sender:UILongPressGestureRecognizer)
    {
        guard sender.state == .Began else {return;}
        let alertView = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: "保存")
        alertView.showInView(self.view)
    }
    
    internal func dismissSelf(sender:CustomizedTapGestureRecognizer)
    {
        self.dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    internal func resetPicture(sender:UITapGestureRecognizer)
    {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.__pictureView.center = self.view.center
            self.__pictureView.transform = CGAffineTransformIdentity
        }
    }
    // MARK: ActionSheet Delegate
    internal func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        let image = __pictureView.image
        guard image != nil else {return;}

        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        actionSheet.dismissWithClickedButtonIndex(0, animated: true)
    }
}