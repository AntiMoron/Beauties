//
//  PictureUrlListAdaptor.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation


class PictureUrlListAdaptor
{
    internal enum Status {
        case Good,Bad
    }
    internal func extractUrlList(response:[String : AnyObject]) -> (status : Status,results : [String])
    {
        fatalError("You should implement this method yourself!!! -- PictureUrlListAdaptor::extractUrlList")
    }
}