//
//  MovieListViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

struct MovieListDataProvider{
    enum DataType:Int{
        case Top250
        case SearchResult
    }
    var dataType:DataType = .Top250
    
    struct DataRow{
        var movies = [Movie]()
        var pageIndex = 0
    }
    
    var dataRows = Array<DataRow>.init(count: 2, repeatedValue: DataRow())
    
    var data:DataRow{
        get{
            return self.dataRows[dataType.hashValue]
        }
        set{
            self.dataRows[dataType.hashValue] = newValue
        }
    }
    
    mutating func purgeData(){
        var _data = self.data
        _data.movies.removeAll()
        _data.pageIndex = 0
        self.data = _data
    }
}

class MovieListPage: UIViewController,UINavigationBarDelegate{
    @IBOutlet weak var tableview:UITableView!
    
    var dataProvider = MovieListDataProvider()
    
    var searchController:UISearchController!
    
    var q:String = ""
    var tag:String = ""
    
    var pullUpVC = PullUpViewController()
    
    var movieService = MovieService()
    let movieCellIndentify:String = "movieCell"
    
    var detailPage = MovieDetailPage(nibName:"MovieDetail",bundle: nil)
    
    var rightBarBtn:UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rightBarBtn = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearch")
        self.toggleSearchBar(true)
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
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
    func showSearch(){
        searchController.active = true
        toggleSearchBar()
        tableview.reloadData()
        //        self.presentViewController(self.searchController, animated: true, completion: nil)
    }
    
    func toggleSearchBar(disabled:Bool = false){
        if disabled{
            dataProvider.dataType = .Top250
            navigationItem.titleView = nil
            navigationItem.title = "Top250"
            navigationItem.rightBarButtonItem = rightBarBtn
            
        }else{
            dataProvider.dataType = .SearchResult
            navigationItem.titleView = searchController.searchBar
            navigationItem.title = "关键字:\(q)"
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MovieListPage:UISearchResultsUpdating{
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let q = searchController.searchBar.text{
            if q == "" && dataProvider.dataType == .SearchResult && dataProvider.data.movies.count > 0{
                //                print("purge")
                dataProvider.purgeData()
                tableview.reloadData()
            }
            guard q != "" && q.utf8.count > 1 else {
                return
            }
            self.q = q
        }
    }
}

extension MovieListPage:UISearchBarDelegate{
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        movieService.searchMovies(q, tag: tag)
        searchController.active = false
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchController.active = false
        self.toggleSearchBar(true)
        tableview.reloadData()
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchBar.text = q
    }
}

extension MovieListPage:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.data.movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieCell
        cell.movie = dataProvider.data.movies[indexPath.row]
        return cell
    }
}

extension MovieListPage:UITableViewDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Active
        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //            print("didend dragging")
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Loading
            if dataProvider.dataType == .Top250{
                movieService.top250Movies(dataProvider.data.pageIndex)
            }else{
                movieService.searchMovies(q, tag: tag, pageIndex: dataProvider.data.pageIndex)
            }
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
        if searchController.active{
            searchController.active = false
        }
        movie = dataProvider.data.movies[indexPath.row]
        jumpToDetailPage(movie.id)
    }
    
    func jumpToDetailPage(id: String) {
        detailPage.id = id
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

