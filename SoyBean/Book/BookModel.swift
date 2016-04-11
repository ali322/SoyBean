//
//  BookModel.swift
//  SoyBean
//
//  Created by chenli on 16/4/11.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation
import SwiftyJSON

class Book:NSObject{
    var id:String = ""
    var title:String = ""
    var images:Dictionary<String,String> = [:]
    var author:Array<String> = []
    var publisher:String = ""
    var pubdate:String = ""
    var rating:Float = 0.0
    
    func initWithJSON(json:JSON)->Self{
        self.id = json["id"].stringValue
        self.title = json["title"].stringValue
        var _images:[String:String] = [:]
        for (k,v):(String,JSON) in json["images"]{
            _images[k] = v.stringValue
        }
        self.images = _images
        self.author = json["author"].map({ (_,v) -> String in
            return v.stringValue
        })
        self.publisher = json["publisher"].stringValue
        self.pubdate = json["pubdate"].stringValue
        self.rating = json["rating"]["average"].floatValue
        return self
    }
}




