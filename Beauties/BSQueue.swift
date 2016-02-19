//
//  BSQueue.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/8.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation

///Queue for 'Beauties'
public class BSQueue<T : Any>
{
    private var frontCur = 0
    private var reuseCur = -1
    private var capacity = 0
    private var impl = [T]()
    
    public var count : Int
    {
        get
        {
            return impl.count - frontCur
        }
    }

    public func empty() -> Bool
    {
        return self.count == 0
    }
    
    public func size() -> Int
    {
        return impl.count
    }
    
    public func append(o : T)
    {
        if(frontCur > reuseCur && reuseCur >= 0)
        {
            impl[reuseCur] = o
            reuseCur++
        }
        else
        {
            impl.append(o)
        }
    }
    
    public func pop()
    {
        frontCur++
    }
    
    public func front() -> T
    {
        return impl[frontCur]
    }
    
    public subscript (index:Int) -> T
    {
        set
        {
            impl[index + frontCur] = newValue
        }
        get{
            return impl[index + frontCur]
        }
    }
}