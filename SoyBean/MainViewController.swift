//
//  MainViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieListVC = MovieListViewController(nibName:"MovieList",bundle: nil)
        let bookListVC = BookListViewController(nibName:"BookList",bundle:nil)
        self.setViewControllers([
            movieListVC,bookListVC
            ], animated: true)
        self.tabBar.items?[0].title = "电影"
        self.tabBar.items?[1].title = "图书"
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
