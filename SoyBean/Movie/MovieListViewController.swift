//
//  MovieListViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController{
    @IBOutlet weak var tableview:UITableView!
    
    
    var movies:[Movie] = []
    var searchResult:[Movie] = []
    
    var searchController:UISearchController!
    var pageIndexOfMovies = 0
    var pageIndexOfSearch = 0
    var q:String = ""
    
    var pullUpVC = PullUpViewController()
    
    var movieService = MovieService()
    let movieCellIndentify:String = "movieCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        do{
        movieService.listDelegate = self
        movieService.top250Movies()
        //        }catch MovieError.ListError{
        //            Util.alert("提示", message: "接口异常")
        //        }
        // Do any additional setup after loading the view.
        tableview.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: movieCellIndentify)
        tableview.dataSource = self
        tableview.delegate = self
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableViewAutomaticDimension
        
        //        let searchResultVC = UIViewController()
        //        searchResultVC.view.frame = self.view.bounds
        //        searchResultVC.view.backgroundColor = UIColor.redColor()
        searchController = UISearchController(searchResultsController:nil)
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        //        searchBar.delegate = self
        //        searchBar.hidden = true
        //        searchBar.prompt = " "
        searchBar.sizeToFit()
        searchBar.placeholder = "请输入电影信息"
        searchController.searchResultsUpdater = self
        tableview.tableHeaderView = searchBar
        
        self.addChildViewController(pullUpVC)
        tableview.tableFooterView = pullUpVC.view
        
        self.navigationItem.title = "TOP250"
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if searchController.active{
            searchController.active = false
            searchController.searchBar.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MovieListViewController:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let q = searchController.searchBar.text{
            guard q != "" && q.utf8.count > 3 else {
                return
            }
            self.q = q
            movieService.searchMovies(q)
        }
    }
}

extension MovieListViewController:UISearchBarDelegate{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        tableview.reloadData()
    }
}

extension MovieListViewController:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active {
            return searchResult.count
        }
        return movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier(movieCellIndentify, forIndexPath: indexPath) as! MovieCell
        if searchController.active{
            cell.movie = searchResult[indexPath.row]
        }else{
            cell.movie = movies[indexPath.row]
        }
        return cell
    }
}

extension MovieListViewController:UITableViewDelegate{
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //        print(scrollView.contentSize.height - scrollView.frame.height,scrollView.contentOffset.y)
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.height + 50{
            print("draging")
            pullUpVC.status = .Dragging
        }else{
            pullUpVC.status = .Inactive
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.height + 50{
            if searchController.active{
                movieService.searchMovies(self.q,tag: "",pageIndex:pageIndexOfSearch)
            }else{
                movieService.top250Movies(pageIndexOfMovies)
            }
        }
    }
}

