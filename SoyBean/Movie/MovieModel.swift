//
//  MovieModel.swift
//  SoyBean
//
//  Created by chenli on 16/3/19.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Genres:String{
    case Cartoon = "动画"
    case Fantasy = "奇幻"
    case Feature = "剧情"
    case Kid = "儿童"
    case Music = "音乐"
    case Comedy = "喜剧"
    case Love = "爱情"
    case Crime = "犯罪"
    case Disaster = "灾难"
    case Action = "动作"
    case Science = "科幻"
    case History = "历史"
    case War = "战争"
    case Horrible = "恐怖"
}

struct Movie{
    let id:String
    let title:String
    let originalTitle:String
    let alt:String
    let rate:Float
    let images:[String:String]
    let year:String
    let casts:[Creator]
    //    let directors:[Creator]
    
    static func initWith(json:JSON)->Movie{
        
        let _id = json["id"].stringValue
        let _title = json["title"].stringValue
        let _originalTitle = json["originalTitle"].stringValue
        let _alt = json["alt"].stringValue
        let _rate = json["rating"]["average"].floatValue
        var _images:Dictionary<String,String> = [:]
        for (key,value):(String,JSON) in json["images"]{
            _images[key] = value.stringValue
        }
        let _year = json["year"].stringValue
        var _casts = [Creator]()
        for (_,json) in json["casts"]{
            let _creator = Creator.initWith(json)
            _casts.append(_creator)
        }
        let _movie = Movie(id: _id, title: _title, originalTitle: _originalTitle, alt: _alt, rate: _rate, images: _images, year: _year, casts: _casts)
        return _movie
    }
}

struct Creator{
    let id:String
    let name:String
    let alt:String
    let avatars:Dictionary<String,String>
    
    static func initWith(json:JSON)->Creator{
        var _avatars:Dictionary<String,String> = [:]
        for (k,v):(String,JSON) in json["avatars"]{
            _avatars[k] = v.stringValue
        }
        let _creator = Creator(
            id:json["id"].stringValue,
            name:json["name"].stringValue,
            alt:json["alt"].stringValue,
            avatars:_avatars
        )
        return _creator
    }
}

struct MovieDetail{
    let id:String
    let title:String
    let originalTitle:String
    let alt:String
    let rate:Float
    let images:[String:String]
    let year:String
    let countries:[String]
    let durations:[String]
    let casts:[Creator]
    //    let directors:[Creator]
    let photos:[MoviePhoto]
    let summary:String
    
    static func initWith(json:JSON)->MovieDetail{
        
        let _id = json["id"].stringValue
        let _title = json["title"].stringValue
        let _originalTitle = json["originalTitle"].stringValue
        let _alt = json["alt"].stringValue
        let _rate = json["rating"]["average"].floatValue
        var _images:Dictionary<String,String> = [:]
        for (key,value):(String,JSON) in json["images"]{
            _images[key] = value.stringValue
        }
        let _year = json["year"].stringValue
        var _countries:[String] = []
        for (_,country):(String,JSON) in json["countries"]{
            _countries.append(country.stringValue)
        }
        var _durations:[String] = []
        for (_,duration):(String,JSON) in json["durations"]{
            _durations.append(duration.stringValue)
        }
        var _casts = [Creator]()
        for (_,json) in json["casts"]{
            let _creator = Creator.initWith(json)
            _casts.append(_creator)
        }
        let _summary = json["summary"].stringValue
        
        var _photos = [MoviePhoto]()
        for (_,v):(String,JSON) in json["photos"] {
            let _photo = MoviePhoto.initWith(v)
            _photos.append(_photo)
        }
        let _movie = MovieDetail(id: _id, title: _title, originalTitle: _originalTitle, alt: _alt, rate: _rate, images: _images, year: _year, countries: _countries,durations: _durations,casts: _casts,photos: _photos,summary: _summary)
        return _movie
    }
}

struct MoviePhoto{
    let id:String
    let cover:String
    let alt:String
    let image:String
    let thumb:String
    let icon:String
    
    static func initWith(json:JSON)->MoviePhoto{
        let _id = json["id"].stringValue
        let _cover = json["cover"].stringValue
        let _thumb = json["thumb"].stringValue
        let _image = json["image"].stringValue
        let _icon = json["icon"].stringValue
        let _alt = json["alt"].stringValue
        let _photo = MoviePhoto(id: _id, cover: _cover, alt: _alt, image: _image, thumb: _thumb, icon: _icon)
        return _photo
    }
}
