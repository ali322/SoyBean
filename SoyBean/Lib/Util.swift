//
//  Util.swift
//  SoyBean
//
//  Created by chenli on 16/3/19.
//  Copyright © 2016年 chenli. All rights reserved.
//

import UIKit

struct Util{
    static func alert(title:String?,message:String?)->UIAlertController{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel) { (action) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(cancelAction)
        return alertController
    }
}
