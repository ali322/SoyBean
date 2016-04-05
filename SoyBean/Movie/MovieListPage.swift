//
//  MovieListViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

enum MovieListDataType{
    case Top250
    case SearchResult
    
}

struct MovieListData{
    var movies = [Movie]()
    var pageIndex = 0
}

struct MovieListDataProvider{
    
    var data:[MovieListData] = Array<MovieListData>.init(count: 2, repeatedValue: MovieListData())
    var dataType:MovieListDataType = .Top250
    
    func getData()->MovieListData{
        return self.data[dataType.hashValue]
    }
    mutating func setData(data:MovieListData){
        self.data[dataType.hashValue] = data
    }
}

class MovieListPage: UIViewController{
    @IBOutlet weak var tableview:UITableView!
    
    var dataProvider = MovieListDataProvider()
    
    var searchController:UISearchController!
    var searchResultController = MovieSearchResult(nibName:"MovieSearchResult",bundle: nil)
    
    var q:String = ""
    
    var pullUpVC = PullUpViewController()
    
    var movieService = MovieService()
    let movieCellIndentify:String = "movieCell"
    
    var detailPage = MovieDetailPage(nibName:"MovieDetail",bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        do{
        movieService.listDelegate = self
        dataProvider.dataType = .Top250
        //        self.listData = top250
        //        self.dataSource = top250DataSource
        movieService.top250Movies()
        //        }catch MovieError.ListError{
        //            Util.alert("提示", message: "接口异常")
        //        }
        // Do any additional setup after loading the view.
        tableview.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: movieCellIndentify)
        tableview.dataSource = self
        tableview.delegate = self
        
        searchController = UISearchController(searchResultsController:nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        let searchBar = searchController.searchBar
        //        searchBar.hidden = true
        //        searchBar.prompt = " "
        searchBar.sizeToFit()
        searchBar.placeholder = "请输入电影信息"
        searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        tableview.tableFooterView = pullUpVC.view
        
        self.navigationItem.title = "TOP250"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearch")
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func showSearch(){
        dataProvider.dataType = .SearchResult
        tableview.reloadData()
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

extension MovieListPage:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let q = searchController.searchBar.text{
            guard q != "" && q.utf8.count > 3 else {
                return
            }
            self.q = q
        }
    }
}

extension MovieListPage:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        movieService.searchMovies(q)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        dataProvider.dataType = .Top250
        tableview.reloadData()
    }
}

extension MovieListPage:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.getData().movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
        cell.movie = dataProvider.getData().movies[indexPath.row]
        return cell
    }
}

extension MovieListPage:UITableViewDelegate,SearchResultDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Active
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //            print("didend dragging")
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Loading
            movieService.top250Movies(dataProvider.getData().pageIndex)
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
        movie = dataProvider.getData().movies[indexPath.row]
        jumpToDetailPage(movie.id)
    }
    
    func jumpToDetailPage(id: String) {
        detailPage.id = id
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

