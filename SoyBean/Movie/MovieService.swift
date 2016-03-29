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

struct MovieService{
    var listDelegate:MovieListDelegate?
    var detailDelegate:MovieDetailDelegate?
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
                self.listDelegate?.findMoviesFail(response.result.error as! MovieError)
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
}

extension MovieListPage:MovieListDelegate{
    func findMoviesSuccess(data: NSData?) {
        if searchController.active{
            self.pageIndexOfSearch += 1
        }else{
            self.pageIndexOfMovies += 1
        }
        if let _data = data{
            var _movies:[Movie] = []
            let jsonData:JSON = JSON(data: _data)
            for (_,subject):(String,JSON) in jsonData["subjects"]{
                let _movie = Movie.initWith(subject)
                _movies.append(_movie)
            }
            if searchController.active{
                self.searchResult += _movies
            }else{
                self.movies += _movies
            }
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
            let _movie = Detail.initWith(jsonData)
            self.movie = _movie
        }
    }
    func getMovieFail(err: MovieError) {
        print(err)
    }
}