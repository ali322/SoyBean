//
//  MovieCell.swift
//  SoyBean
//
//  Created by chenli on 16/3/19.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MovieCell:UITableViewCell{
    var movie:Movie?{
        didSet{
            self.updateUI()
        }
    }
    
    @IBOutlet weak var poster:UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var rate:UILabel!
    @IBOutlet weak var actor:UILabel!
    
    func updateUI(){
        if let _movie = movie{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let posterData = NSData(contentsOfURL: NSURL(string: _movie.images["small"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.poster.image = UIImage(data: posterData)
                })
            })
            
            title.text = _movie.title
            rate.attributedText = attributedStringFor("评分:\(_movie.rate)")
            var _casts:[String] = []
            for _actor in _movie.casts{
                _casts.append(_actor.name)
            }
            let _castsStr = _casts.joinWithSeparator("/")
            actor.attributedText = attributedStringFor("演员:\(_castsStr)")
            
        }
    }
    
    func attributedStringFor(labelText:String)->NSMutableAttributedString{
        let attrStr = NSMutableAttributedString(string: labelText)
        attrStr.addAttribute(NSKernAttributeName, value: 5, range: NSRange.init(location: 2, length: 1))
        return attrStr
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}