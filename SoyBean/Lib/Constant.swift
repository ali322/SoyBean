//
//  Constant.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

struct API{
    static let apiHost = "http://api.douban.com/v2/"
    
    static let movies = "\(apiHost)movie/top250"
    static let searchMovies = "\(apiHost)movie/search"
}

let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height