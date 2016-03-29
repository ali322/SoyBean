//
//  MovieDetailPage.swift
//  SoyBean
//
//  Created by chenli on 16/3/29.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MovieDetailPage: UIViewController {
    var id:String?{
        didSet{
            if let _id = id{
                movieService.movieDetail(_id)
            }
        }
    }
    var movie:Movie?{
        didSet{
            self.updateUI()
        }
    }
    
    @IBOutlet weak var cover:UIImageView!
    @IBOutlet weak var movietitle:UILabel!
    
    var movieService = MovieService()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieService.detailDelegate = self
        
    }
    
    func updateUI(){
        if let _movie = movie{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let coverdata = NSData(contentsOfURL: NSURL(string: _movie.images["large"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cover.image = UIImage(data: coverdata)
                })
            })
            movietitle.text = _movie.title
            
            self.navigationItem.title = _movie.title
        }
    }
}
