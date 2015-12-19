//
//  SelectController.swift
//  doubanFM
//
//  Created by longzongqin on 15/12/8.
//  Copyright (c) 2015年 longzongqin. All rights reserved.
//

import UIKit

protocol SelectProtocol{
    func onSelectData(selectID:String)
}
class SelectController: UIViewController ,UITableViewDataSource, UITableViewDelegate{
    
    var selectArr:NSArray = NSArray()
    var delegate:SelectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectArr.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "selectList")
        let rowData:NSDictionary = selectArr[indexPath.row] as! NSDictionary
        cell.textLabel?.text = rowData["name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let rowData:NSDictionary = self.selectArr[indexPath.row] as! NSDictionary
        let selectID:AnyObject = rowData["channel_id"]! as AnyObject
        delegate?.onSelectData("\(selectID)")
        println("longzongqin")
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    
}
