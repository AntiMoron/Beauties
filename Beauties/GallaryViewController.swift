//
//  GallaryViewController.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
import UIKit

class GallaryViewController : UIViewController
{
    //MARK:
    internal var items = BSQueue<PhotographView>()
    internal var container = GallaryContainerView()
    private static let columnCount = 4
    var heights = [CGFloat](count: GallaryViewController.columnCount, repeatedValue: 0)
    private func findMinimumColumn(imageHeight : CGFloat) -> Int
    {
        var m : CGFloat = heights[0] + imageHeight
        var ret : Int = 0
        for i in 1..<GallaryViewController.columnCount
        {
            if(heights[i] + imageHeight < m)
            {
                m = heights[i]
                ret = i
            }
        }
        return ret
    }
    private func findMaxColumnHeight() -> CGFloat
    {
        var m : CGFloat = heights[0]
        for i in 1..<GallaryViewController.columnCount
        {
            if(heights[i] > m)
            {
                m = heights[i]
            }
        }
        return m
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        let source = JdanPictureSource()
        let adaptor = JdanPictureUrlListAdaptor()
        self.view.addSubview(container)
        let columnCount = GallaryViewController.columnCount
        let columnWidth = self.view.frame.size.width / CGFloat(columnCount)
        container.frame = self.view.frame
        container.showsHorizontalScrollIndicator = false
        container.showsVerticalScrollIndicator = false
        var loading = false
        var currentPage = 1
        func loadDataClosure(cur : Int,page : Int)
        {
            source.pictureUrlList(page) { (response:[String : AnyObject]?) -> Void in
                guard cur != 0 else{
                    return
                }
                if(response == nil){//如果加载失败，就继续加载,直到cur为0
                    loadDataClosure(cur - 1,page: page)
                    return
                }
                //获取图片URL列表
                let urls = adaptor.extractUrlList(response!)
                //如果获取到了内容
                guard urls.status == .Good else {
                    return
                }
                let results = urls.results
                dispatch_async(dispatch_get_main_queue())
                    {
                        var loadedImageCount = self.items.count
                        for i in 0..<results.count
                        {
                            let aUrl = results[i]
                            let elem = PhotographView()
                            self.items.append(elem)
                            //添加点击大图事件
                            let tap = CustomizedTapGestureRecognizer(target: self, action: Selector("tapToFullScreen:"))
                            self.container.addSubview(elem)
                            //异步加载该图片
                            elem.loadData(aUrl){
                                tap.userData = elem.getImage()
                                elem.addGestureRecognizer(tap)
                                elem.frame = CGRectMake(0,0,columnWidth,0)
                                let columnIndex = self.findMinimumColumn(elem.frame.size.height)
                                elem.frame = CGRectMake(columnWidth * CGFloat(columnIndex),self.heights[columnIndex],
                                    columnWidth,0)//That doesn't matter
                                self.heights[columnIndex] += elem.frame.size.height
                                self.container.contentSize = CGSize(width: columnWidth, height: self.findMaxColumnHeight())
                                loadedImageCount++
                                print("Inside Closure : " + String(loadedImageCount) + "in" + String(self.items.count))
                                if(loadedImageCount == self.items.count)
                                {
                                    loading = false
                                    if loadedImageCount > 200
                                    {
                                        for _ in 1...(loadedImageCount - 200){
                                            self.items.front().removeFromSuperview()
                                            self.items.pop()
                                        }
                                        loadedImageCount = 200
                                    }
                                }
                            }
                        }
                }
            }
        }
        func onContentOffsetChange()
        {
            print("Loading : " + String(loading))
            if(self.container.contentSize.height > self.view.frame.size.height &&
                (container.contentOffset.y + container.frame.size.height) >
                (container.contentSize.height - self.view.frame.height * 0.5))
            {
                if !loading
                {
                    loading = true
                    loadDataClosure(3, page: currentPage++)
                }
            }
        }
        container.functor = onContentOffsetChange
        loadDataClosure(3, page : currentPage)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func tapToFullScreen(sender : CustomizedTapGestureRecognizer)
    {
        let fullscreen = BigPictureViewController()
        fullscreen.pictureImage = sender.userData as! UIImage
        self.presentViewController(fullscreen, animated: true) { () -> Void in
            
        }
    }
}