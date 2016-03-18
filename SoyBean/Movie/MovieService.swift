//
//  MovieService.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation
import Alamofire

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
    
    func findMovies()throws{
        Alamofire.request(.GET, API.movies).responseData { (response)-> Void in
            if response.result.error != nil{
                self.listDelegate?.findMoviesFail(response.result.error as! MovieError)
            }else{
                self.listDelegate?.findMoviesSuccess(response.result.value)
            }
        }
        
    }
}

extension MovieListViewController:MovieListDelegate{
    func findMoviesSuccess(data: NSData?) {
        
    }
    
    func findMoviesFail(err: MovieError) {
        
    }
}