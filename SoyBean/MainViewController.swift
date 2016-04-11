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
        
        let movieListVC = MovieListPage(nibName:"MovieList",bundle: nil)
        let movieNavigationVC = UINavigationController(rootViewController: movieListVC)
        let bookListVC = BookListPage(nibName:"BookList",bundle:nil)
        let bookNavigationVC = UINavigationController(rootViewController: bookListVC)
        self.setViewControllers([
            movieNavigationVC,bookNavigationVC
            ], animated: true)
        self.tabBar.items?[0].title = "电影"
        self.tabBar.items?[0].image = UIImage(named: "Film")
        self.tabBar.items?[1].title = "图书"
        self.tabBar.items?[1].image = UIImage(named: "book")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
