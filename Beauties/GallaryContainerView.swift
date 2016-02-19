//
//  GallaryContainer.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/6.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation
import UIKit

class GallaryContainerView:UIScrollView
{
    internal var functor : (Void->Void)?
    internal override var contentOffset:CGPoint
    {
        didSet
        {
            guard functor != nil else {return;}
            functor!()
        }
    }
}