//
//  JdanPictureUrlListAdaptor.swift
//  Beauties
//
//  Created by GaoBoyuan on 15/12/4.
//  Copyright © 2015年 AntSama. All rights reserved.
//

import Foundation

class JdanPictureUrlListAdaptor : PictureUrlListAdaptor
{
    private func matchesForRegexInText(regex: String!, text: String!) -> (status:Bool,results:[String]) {
        do{
            let regex = try NSRegularExpression(pattern: regex, options: .CaseInsensitive)
            let nsString = text as NSString
            let results = regex.matchesInString(text,
                options: NSMatchingOptions.Anchored, range: NSMakeRange(0, nsString.length))
            var ret = [String]()
            for i in 0..<results.count {
                let aResult = results[i]
                let aString : String = nsString.substringWithRange(aResult.range)
                ret.append(aString)
            }
            return (true,ret)
        }catch{
            return (false,[])
        }
    }
    
    internal override func extractUrlList(response:[String : AnyObject]) -> (status : Status,results : [String])
    {
        var result = [String]()
        if(response["status"] as? String == nil)
        {
            return (.Bad,result)
        }
        if(response["status"] as! String != "ok"){
            return (.Bad,result)
        }
        let comments = response["comments"] as! [AnyObject]
        for i in 0..<comments.count {
            let aComment = comments[i] as! [String:AnyObject]
            let commentContent = aComment["comment_content"] as! String
            let matches = matchesForRegexInText("<img src=\".*\"", text: commentContent)
            if(matches.status == true && matches.results.count > 0) {
                let aString = matches.results[0]
                let r = Range<String.Index>(start: aString.startIndex.advancedBy(10),
                    end: aString.startIndex.advancedBy(aString.characters.count - 1))
                result.append(aString.substringWithRange(r))
                print("What I got -->" + result.last!)
            }else{
                print("Nothing matched!")
            }
        }
        return (.Good,result)
    }
}
