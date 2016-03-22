//
//  LoadMore.swift
//  SoyBean
//
//  Created by chenli on 16/3/21.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit
import Cartography

enum PullUpControlStyle:Int{
    case Inactive
    case Active
    case Loading
}

class PullUpViewController:UIViewController{
    var status:PullUpControlStyle = .Inactive{
        didSet{
            self.updateUI()
        }
    }
    var prompt:UILabel!
    var activityIndicator:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40)
        self.view.backgroundColor  = UIColor.redColor()
        prompt = UILabel(frame: CGRectMake(0,0,self.view.bounds.width,30))
        prompt.font = UIFont.systemFontOfSize(13)
        self.view.addSubview(prompt)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.view.addSubview(activityIndicator)
        constrain(prompt,activityIndicator){ prompt,activityIndicator in
            prompt.height == 30
            prompt.centerX == prompt.superview!.centerX
            activityIndicator.top == prompt.bottom
            align(centerX: prompt, activityIndicator)
        }
    }
    func updateUI(){
        //        print(status)
        if status == .Loading{
            prompt.text = "加载中"
            activityIndicator.startAnimating()
        }
        if status == .Inactive{
            prompt.text = ""
            if activityIndicator.isAnimating(){
                activityIndicator.stopAnimating()
            }
        }
        if status == .Active{
            prompt.text = "上拉加载"
        }
        
    }
}

//class PullUpControl:UIView{
//    var status:PullUpControlStyle = .Inactive{
//        didSet{
//            self.updateUI()
//        }
//    }
//    var prompt:UILabel!
//    var activityIndicator:UIActivityIndicatorView!
//    
//    func updateUI(){
//        print("updateUI")
//        switch status{
//        case .Dragging:
//            prompt.text = "松开加载更多"
//            activityIndicator.startAnimating()
//        case .Inactive:
//            prompt.text = "上拉加载"
//            activityIndicator.stopAnimating()
//        }
//    }
//    
//    override init(frame:CGRect){
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.whiteColor()
//        
//        prompt = UILabel(frame: CGRectMake(0,0,self.bounds.width,44))
//        prompt.backgroundColor = UIColor.grayColor()
//        prompt.tintColor = UIColor.redColor()
//        self.addSubview(prompt)
//        
//        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
//        activityIndicator.center = prompt.center
//        self.addSubview(activityIndicator)
//    }
//    convenience init(callback:()->Void){
//        self.init(frame:CGRectMake(0, 0, SCREEN_WIDTH, 50))
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//protocol PullUpDelegate:class{
//    //    func loadMore()->Void
//    var pullUpControl:PullUpControl{get}
//}
//
//extension PullUpDelegate{
//    var pullUpControl:PullUpControl{
//        return PullUpControl{
//            //            [weak self] in
//            print("pullUpControl init")
//            //            self?.loadMore()
//        }
//    }
//}
