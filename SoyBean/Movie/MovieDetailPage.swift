//
//  MovieDetailPage.swift
//  SoyBean
//
//  Created by chenli on 16/3/29.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class MovieDetailPage: UIViewController{
    var id:String?{
        didSet{
            if let _id = id{
                movieService.movieDetail(_id)
            }
        }
    }
    var movie:MovieDetail?{
        didSet{
            self.updateUI()
        }
    }
    
    var casts:[Creator] = []{
        didSet{
            castsView.reloadData()
        }
    }
    
    @IBOutlet weak var cover:UIImageView!
    @IBOutlet weak var movietitle:UILabel!
    @IBOutlet weak var rating:UILabel!
    @IBOutlet weak var countries:UILabel!
    @IBOutlet weak var durations:UILabel!
    @IBOutlet weak var year:UILabel!
    @IBOutlet weak var castsView:UICollectionView!
    @IBOutlet weak var summary:UITextView!
    
    var movieService = MovieService()
    override func viewDidLoad() {
        super.viewDidLoad()
        movieService.detailDelegate = self
        if id != nil{
            movieService.movieDetail(id!)
        }
        castsView.dataSource = self
        castsView.collectionViewLayout = CastViewLayout()
        castsView.registerClass(CastCell.self, forCellWithReuseIdentifier: "CastCell")
    }
    
    func updateUI(){
        if let _movie = movie{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let coverdata = NSData(contentsOfURL: NSURL(string: _movie.images["large"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cover.image = UIImage(data: coverdata)
                })
            })
            movietitle.text = _movie.title
            
            casts = _movie.casts
            
            rating.attributedText = attributedStringFor("评分:\(_movie.rate)")
            year.attributedText = attributedStringFor("上映:\(_movie.year)")
            let _countriesStr = _movie.countries.joinWithSeparator("/")
            countries.attributedText = attributedStringFor("国家:\(_countriesStr)")
            let _durationsStr = _movie.durations.joinWithSeparator("/")
            durations.attributedText = attributedStringFor("片长:\(_durationsStr)")
            summary.text = "\(_movie.summary)"
            
            self.navigationItem.title = _movie.title
        }
    }
    
    func attributedStringFor(labelText:String)->NSMutableAttributedString{
        let attrStr = NSMutableAttributedString(string: labelText)
        attrStr.addAttribute(NSKernAttributeName, value: 5, range: NSRange.init(location: 2, length: 1))
        return attrStr
    }
}

extension MovieDetailPage:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = castsView.dequeueReusableCellWithReuseIdentifier("CastCell", forIndexPath: indexPath) as! CastCell
        cell.cast = casts[indexPath.item]
        return cell
    }
}

class CastViewLayout:UICollectionViewFlowLayout{
    override init() {
        super.init()
        self.estimatedItemSize = CGSizeMake(80, 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CastCell:UICollectionViewCell{
    var cast:Creator?{
        didSet{
            self.updateUI()
        }
    }
    
    var castBtn:UIButton = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(castBtn)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        castBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
        castBtn.frame = self.bounds
    }
    
    func updateUI(){
        let attributedTitle = NSAttributedString(string: cast!.name, attributes: [
            NSFontAttributeName:UIFont.systemFontOfSize(13)
            ])
        castBtn.setAttributedTitle(attributedTitle, forState: .Normal)
        //        castBtn.setTitle(cast?.name, forState: .Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder")
    }
}
