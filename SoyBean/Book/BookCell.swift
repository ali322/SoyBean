//
//  BookCell.swift
//  SoyBean
//
//  Created by chenli on 16/4/11.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class BookCell:UITableViewCell{
    var book:Book?{
        didSet{
            self.updateUI()
        }
    }
    
    @IBOutlet weak var cover:UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var author:UILabel!
    @IBOutlet weak var rating:UILabel!
    
    func updateUI(){
        if let _book = book{
            let queue = NSOperationQueue()
            let operation = NSBlockOperation(block: { () -> Void in
                let coverData = NSData(contentsOfURL: NSURL(string: _book.images["medium"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cover.image = UIImage(data: coverData)
                })
            })
            queue.addOperation(operation)
            title.text = _book.title
            let _authors = _book.author.joinWithSeparator("/")
            author.attributedText = attributedStringFor("作者:\(_authors)")
            rating.attributedText = attributedStringFor("评分:\(_book.rating)")
        }
    }
    
    func attributedStringFor(labelText:String)->NSAttributedString{
        let attributedStr = NSMutableAttributedString(string: labelText)
        attributedStr.addAttribute(NSKernAttributeName, value: 5, range: NSRange.init(location: 2, length: 1))
        return attributedStr
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
