//
//  MovieService.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum MovieError:ErrorType{
    case ListError
    case DetailError(id:Int)
}

protocol MovieListDelegate:class{
    func findMoviesSuccess(data:NSData?)
    func findMoviesFail(err:MovieError)
}

struct MovieService{
    var listDelegate:MovieListDelegate?
    var alamofireManager:Manager{
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager = Alamofire.Manager(configuration:config)
        return manager
    }
    
    func top250Movies(){
        Alamofire.request(.GET, API.movies).responseData { (response)-> Void in
            if response.result.error != nil{
                self.listDelegate?.findMoviesFail(response.result.error as! MovieError)
            }else{
                self.listDelegate?.findMoviesSuccess(response.result.value)
            }
        }
    }
    
    func searchMovies(q:String = "",tag:String = ""){
        Alamofire.request(.GET, API.searchMovies, parameters: ["q":q,"tag":tag]).responseData { (response) -> Void in
            if response.result.error != nil{
                self.listDelegate?.findMoviesFail(MovieError.ListError)
            }else{
                self.listDelegate?.findMoviesSuccess(response.result.value)
            }
        }
    }
}

extension MovieListViewController:MovieListDelegate{
    func findMoviesSuccess(data: NSData?) {
        if let _data = data{
            
            var _movies:[Movie] = []
            let jsonData:JSON = JSON(data: _data)
            for (_,subject):(String,JSON) in jsonData["subjects"]{
                let _id = subject["id"].stringValue
                let _title = subject["title"].stringValue
                let _originalTitle = subject["originalTitle"].stringValue
                let _alt = subject["alt"].stringValue
                let _rate = subject["rating"]["average"].floatValue
                var _images:Dictionary<String,String> = [:]
                for (key,value):(String,JSON) in subject["images"]{
                    _images[key] = value.stringValue
                }
                let _year = subject["year"].stringValue
                var _casts:[Creator] = []
                for (_,json):(String,JSON) in subject["casts"]{
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
                    _casts.append(_creator)
                }
                let _movie = Movie(id:_id,title:_title,originalTitle: _originalTitle,
                    alt: _alt,rate: _rate,images: _images,year: _year,casts: _casts
                )
                _movies.append(_movie)
            }
            if searchController.active{
                self.searchResult += _movies
            }else{
                self.movies += _movies
            }
            tableview.reloadData()
        }
    }
    
    func findMoviesFail(err: MovieError) {
        print("find error")
    }
}