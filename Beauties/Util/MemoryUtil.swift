//
//  MemoryUtil.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation

public class MemoryUtil
{
    public func setUserDefault(value:AnyObject,key:String!)
    {
        let userDefault = NSUserDefaults.standardUserDefaults();
        userDefault.setObject(value, forKey: key)
    }
    public func getUserDefault(key:String!) -> AnyObject?
    {
        let userDefault = NSUserDefaults.standardUserDefaults();
        return userDefault.objectForKey(key)
    }
}