//
//  MovieModel.swift
//  SoyBean
//
//  Created by chenli on 16/3/19.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation

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
}

struct Creator{
    let id:String
    let name:String
    let alt:String
    let avatars:Dictionary<String,String>
}
