//
//  BookService.swift
//  SoyBean
//
//  Created by chenli on 16/4/11.
//  Copyright © 2016年 chenli. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol BookListDelegate{
    func findBookSuccess(data:NSData?)
    func findBookFail(err:NSError)
}

struct BookService{
    var booklistDelegate:BookListDelegate?
    
    func findBook(q:String = "",tag:String = "",pageIndex:Int = 0){
        let start = pageIndex * 6
        Alamofire.request(.GET, "\(API.searchBooks)",parameters:["q":q,"tag":tag,"start":start,"count":6]).responseData { (response) -> Void in
            if response.result.error != nil{
                self.booklistDelegate?.findBookFail(response.result.error!)
            }else{
                self.booklistDelegate?.findBookSuccess(response.result.value)
            }
        }
    }
}

extension BookListPage:BookListDelegate{
    func findBookFail(err: NSError) {
        print(err)
    }
    
    func findBookSuccess(data: NSData?) {
        if let _data = data{
            var listData = self.dataProvider.data
            let jsonData = JSON(data:_data)
            var _books:[Book] = []
            for (_,v):(String,JSON) in jsonData["books"]{
                let _book = Book()
                _books.append(_book.initWithJSON(v))
            }
            listData.books += _books
            listData.pageIndex += 1
            dataProvider.data = listData
            pullVC.status = .Inactive
            tableview.reloadData()
            
        }
    }
}