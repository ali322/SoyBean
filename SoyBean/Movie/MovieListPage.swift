//
//  MovieListViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MovieListPage: UIViewController{
    @IBOutlet weak var tableview:UITableView!
    
    
    var movies:[Movie] = []
    
    var searchController:UISearchController!
    var searchResultController = MovieSearchResult(nibName:"MovieSearchResult",bundle: nil)
    
    var pageIndexOfMovies = 0
    var q:String = ""
    
    var pullUpVC = PullUpViewController()
    
    var movieService = MovieService()
    let movieCellIndentify:String = "movieCell"
    
    var detailPage = MovieDetailPage(nibName:"MovieDetail",bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        do{
        movieService.listDelegate = self
        movieService.top250Movies()
        //        }catch MovieError.ListError{
        //            Util.alert("提示", message: "接口异常")
        //        }
        // Do any additional setup after loading the view.
        //        tableview.backgroundColor = UIColor.greenColor()
        tableview.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: movieCellIndentify)
        tableview.dataSource = self
        tableview.delegate = self
        //        tableview.estimatedRowHeight = 100
        //        tableview.rowHeight = UITableViewAutomaticDimension
        
        searchController = UISearchController(searchResultsController:searchResultController)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        //        searchBar.hidden = true
        //        searchBar.prompt = " "
        searchBar.sizeToFit()
        searchBar.placeholder = "请输入电影信息"
        searchController.searchResultsUpdater = searchResultController
        searchResultController.delegate = self
        //        tableview.tableHeaderView = searchBar
        //        self.addChildViewController(searchController)
        
        //        self.addChildViewController(pullUpVC)
        tableview.tableFooterView = pullUpVC.view
        
        self.navigationItem.title = "TOP250"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearch")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func showSearch(){
        self.presentViewController(self.searchController, animated: true, completion: nil)
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


extension MovieListPage:UISearchBarDelegate{
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        tableview.reloadData()
    }
}

extension MovieListPage:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier(movieCellIndentify, forIndexPath: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
}

extension MovieListPage:UITableViewDelegate,SearchResultDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
        pullUpVC.status = .Active
        //        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        print("didend dragging")
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Loading
            movieService.top250Movies(pageIndexOfMovies)
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var movie:Movie
        movie = movies[indexPath.row]
        jumpToDetailPage(movie.id)
    }
    
    func jumpToDetailPage(id: String) {
        detailPage.id = id
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

