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

protocol MovieDetailDelegate:class{
    func getMovieSuccess(data:NSData?)
    func getMovieFail(err:MovieError)
}

protocol CreatorDelegate{
    func getCreatorSuccess(data:NSData?)
    func getCreatorFail(err:NSError)
}

struct MovieService{
    var listDelegate:MovieListDelegate?
    var detailDelegate:MovieDetailDelegate?
    var creatorDelegate:CreatorDelegate?
    var alamofireManager:Manager{
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manager = Alamofire.Manager(configuration:config)
        return manager
    }
    
    func top250Movies(pageIndex:Int = 0){
        let start = pageIndex * 6
        //        print("start: \(start)")
        Alamofire.request(.GET, API.movies,parameters:["start":start,"count":6]).responseData { (response)-> Void in
            if response.result.error != nil{
                self.listDelegate?.findMoviesFail(MovieError.ListError)
            }else{
                self.listDelegate?.findMoviesSuccess(response.result.value)
            }
        }
    }
    
    func searchMovies(q:String = "",tag:String = "",pageIndex:Int = 0){
        let start = pageIndex * 6
        Alamofire.request(.GET, API.searchMovies, parameters: ["q":q,"tag":tag,"start":start,"count":6]).responseData { (response) -> Void in
            if response.result.error != nil{
                self.listDelegate?.findMoviesFail(MovieError.ListError)
            }else{
                self.listDelegate?.findMoviesSuccess(response.result.value)
            }
        }
    }
    
    func movieDetail(id:String){
        Alamofire.request(.GET,"\(API.movie)/\(id)").responseData { (response) -> Void in
            if response.result.error != nil{
                self.detailDelegate?.getMovieFail(MovieError.DetailError(id: -1))
            }else{
                self.detailDelegate?.getMovieSuccess(response.result.value)
            }
        }
    }
    
    func creator(id:String){
        Alamofire.request(.GET, "\(API.creator)/\(id)").responseData { (response) -> Void in
            if response.result.error != nil{
                self.creatorDelegate?.getCreatorFail(response.result.error!)
            }else{
                self.creatorDelegate?.getCreatorSuccess(response.result.value)
            }
        }
    }
}

extension MovieListPage:MovieListDelegate{
    func findMoviesSuccess(data: NSData?) {
        var listData = dataProvider.data
        if let _data = data{
            var _movies:[Movie] = []
            let jsonData:JSON = JSON(data: _data)
            for (_,subject):(String,JSON) in jsonData["subjects"]{
                let _movie = Movie.initWith(subject)
                _movies.append(_movie)
            }
            listData.pageIndex += 1
            listData.movies += _movies
            dataProvider.data = listData
            pullUpVC.status = .Inactive
            tableview.reloadData()
        }
    }
    
    func findMoviesFail(err: MovieError) {
        print("find error")
    }
}

extension MovieDetailPage:MovieDetailDelegate{
    func getMovieSuccess(data: NSData?) {
        if let _data = data{
            let jsonData = JSON(data:_data)
            let _movie = MovieDetail.initWith(jsonData)
            self.movie = _movie
        }
    }
    func getMovieFail(err: MovieError) {
        print(err)
    }
}

extension CreatorPage:CreatorDelegate{
    func getCreatorSuccess(data: NSData?) {
        if let _data = data{
            let jsonData = JSON(data:_data)
            let _creator = CreatorDetail.initWith(jsonData)
            self.creator = _creator
        }
    }
    func getCreatorFail(err:NSError) {
        print(err)
    }
}