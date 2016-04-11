//
//  BookListViewController.swift
//  SoyBean
//
//  Created by chenli on 16/3/18.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

struct BookListDataProvider{
    struct DataRow{
        var books:[Book] = []
        var pageIndex:Int = 0
    }
    
    var data:DataRow = DataRow()
    
    mutating func purgeData(){
        var _data = self.data
        _data.books.removeAll()
        _data.pageIndex = 0
        self.data = _data
    }
}

class BookListPage: UIViewController {
    var dataProvider = BookListDataProvider()
    
    var bookService = BookService()
    
    var q:String = ""
    var tag:String = "经典"
    
    
    var pullVC = PullUpViewController()
    
    @IBOutlet weak var tableview:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookService.booklistDelegate = self
        bookService.findBook("", tag: tag)
        
        tableview.registerNib(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "BookCell")
        tableview.dataSource = self
        tableview.delegate = self
        tableview.tableFooterView = pullVC.view
        
        self.navigationItem.title = tag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BookListPage:UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("BookCell", forIndexPath: indexPath) as! BookCell
        cell.book = dataProvider.data.books[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.data.books.count
    }
}

extension BookListPage:UITableViewDelegate{
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pullVC.status = .Active
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y + scrollView.frame.height > scrollView.contentSize.height{
            pullVC.status = .Loading
            bookService.findBook(q, tag: tag, pageIndex: dataProvider.data.pageIndex)
        }
    }
}
