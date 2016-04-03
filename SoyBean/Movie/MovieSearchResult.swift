//
//  SearchResultPage.swift
//  SoyBean
//
//  Created by chenli on 16/4/3.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

protocol SearchResultDelegate{
    func jumpToDetailPage(id:String)
}

class MovieSearchResult: UIViewController {
    var movies:[Movie] = []
    @IBOutlet weak var tableview:UITableView!
    
    var movieService = MovieService()
    let movieCellIndentify = "movieCell"
    
    var q:String = ""
    var pageIndexOfMovies = 0
    var pullUpVC = PullUpViewController()
    
    var delegate:SearchResultDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieService.listDelegate = self
        
        tableview.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: movieCellIndentify)
        tableview.dataSource = self
        tableview.delegate = self
        
        // Do any additional setup after loading the view.
        tableview.tableFooterView = pullUpVC.view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MovieSearchResult:UISearchResultsUpdating{
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

extension MovieSearchResult:UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier(movieCellIndentify, forIndexPath: indexPath) as! MovieCell
        cell.movie = movies[indexPath.row]
        return cell
    }
}

extension MovieSearchResult:UITableViewDelegate{
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
        pullUpVC.status = .Active
        //        }
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //        print("didend dragging")
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height + 50{
            pullUpVC.status = .Loading
            movieService.searchMovies(self.q,tag: "",pageIndex:pageIndexOfMovies)
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
        //        self.dismissViewControllerAnimated(true) { () -> Void in
        self.delegate?.jumpToDetailPage(movie.id)
        //        }
    }
}
