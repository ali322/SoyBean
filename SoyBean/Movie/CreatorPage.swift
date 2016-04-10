//
//  CreatorPage.swift
//  SoyBean
//
//  Created by chenli on 16/4/8.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

class CreatorPage: UIViewController {
    var id:String?{
        didSet{
            if let _id = id{
                movieService.creator(_id)
            }
        }
    }
    
    var creator:CreatorDetail?{
        didSet{
            self.updateUI()
        }
    }
    
    var works:[CreatorMovie] = []{
        didSet{
            worksView.reloadData()
        }
    }
    
    var movieService = MovieService()
    
    @IBOutlet weak var avatar:UIImageView!
    @IBOutlet weak var name:UILabel!
    @IBOutlet weak var engName:UILabel!
    @IBOutlet weak var birth:UILabel!
    @IBOutlet weak var born:UILabel!
    @IBOutlet weak var professions:UILabel!
    @IBOutlet weak var worksView:UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieService.creatorDelegate = self
        if id != nil{
            movieService.creator(id!)
        }
        worksView.dataSource = self
        worksView.delegate = self
        worksView.registerClass(WorksViewCell.self, forCellWithReuseIdentifier: "WorksViewCell")
        worksView.collectionViewLayout = WorksViewLayout()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateUI(){
        if let _creator = creator{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let avatardata = NSData(contentsOfURL: NSURL(string: _creator.avatars["large"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.avatar.image = UIImage(data: avatardata)
                })
            })
            name.text = _creator.name
            self.works = _creator.works
            
            engName.attributedText = attributedStringFor("英文名:\(_creator.engName)")
            birth.attributedText = attributedStringFor("出生:\(_creator.birth)")
            born.attributedText = attributedStringFor("国家:\(_creator.born)")
            let _professionsStr = _creator.professions.joinWithSeparator("/")
            professions.attributedText = attributedStringFor("职业:\(_professionsStr)")
            
            self.navigationItem.title = _creator.name
        }
    }
    func attributedStringFor(labelText:String)->NSMutableAttributedString{
        let attrStr = NSMutableAttributedString(string: labelText)
        attrStr.addAttribute(NSKernAttributeName, value: 5, range: NSRange.init(location: 2, length: 1))
        return attrStr
    }
    
}

extension CreatorPage:UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return works.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = worksView.dequeueReusableCellWithReuseIdentifier("WorksViewCell", forIndexPath: indexPath) as! WorksViewCell
        cell.movie = works[indexPath.item]
        return cell
    }
}

extension CreatorPage:UICollectionViewDelegate{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let work = works[indexPath.item]
        let detailPage = MovieDetailPage(nibName:"MovieDetail",bundle: nil)
        detailPage.id = work.id
        self.navigationController?.pushViewController(detailPage, animated: true)
    }
}

class WorksViewLayout:UICollectionViewFlowLayout{
    override init() {
        super.init()
        self.estimatedItemSize = CGSizeMake(96, 167)
        self.minimumLineSpacing = 5.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class WorksViewCell:UICollectionViewCell{
    var movie:CreatorMovie?{
        didSet{
            self.updateUI()
        }
    }
    
    var title = UILabel()
    var cover = UIImageView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(title)
        self.addSubview(cover)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        title.frame = CGRectMake(0, 145, 96, 22)
        cover.frame = CGRectMake(0, 0, 96, 140)
    }
    
    func updateUI(){
        if let _movie = movie{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                let coverdata = NSData(contentsOfURL: NSURL(string: _movie.images["medium"]!)!)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.cover.image = UIImage(data: coverdata)
                })
            })
            let attributedTitle = NSAttributedString(string: _movie.title, attributes: [
                NSFontAttributeName:UIFont.systemFontOfSize(13)
                ])
            title.attributedText = attributedTitle
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init with coder")
    }
}
