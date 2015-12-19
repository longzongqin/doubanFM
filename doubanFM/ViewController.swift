//
//  ViewController.swift
//  doubanFM
//
//  Created by longzongqin on 15/12/8.
//  Copyright (c) 2015年 longzongqin. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate, HttpProtocol, SelectProtocol{

    @IBOutlet var iv: UIImageView!
    @IBOutlet var playTime: UILabel!
    @IBOutlet var palyProgress: UIProgressView!
    @IBOutlet var tv: UITableView!
    @IBOutlet var playImg: UIImageView!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet var nextBtn: UIButton!
    
    var eHttp:HttpController = HttpController()
    
    var indexDate:NSArray = NSArray()
    var selectData:NSArray = NSArray()
    var imageCache = Dictionary<String,UIImage>()
    var audioPlayer:MPMoviePlayerController = MPMoviePlayerController()
    var timer:NSTimer?
    var nowMusicUrl = "http://douban.fm/j/mine/playlist?channel=0"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        eHttp.delegate = self
        eHttp.onSearch("http://www.douban.com/j/app/radio/channels")
        eHttp.onSearch("http://douban.fm/j/mine/playlist?channel=0")
        iv.addGestureRecognizer(tap)
    }
    
    func onSelectData(selectID: String) {
        nowMusicUrl = "http://douban.fm/j/mine/playlist?channel=\(selectID)"
        eHttp.onSearch("http://douban.fm/j/mine/playlist?channel=\(selectID)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var selectView:SelectController = segue.destinationViewController as! SelectController
        selectView.delegate = self
        selectView.selectArr = self.selectData
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return indexDate.count
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "indexList")
        let rowData:NSDictionary = self.indexDate[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = rowData["title"] as? String
        cell.detailTextLabel?.text = rowData["artist"] as? String
        cell.imageView?.image = UIImage(named: "ic_song_related.png")
        
        let url:String! = rowData["picture"] as? String
        let image:UIImage! = self.imageCache[url!]
        
        if image == nil{
            
            let imgURL:NSURL? = NSURL(string:url)
            let request:NSURLRequest? = NSURLRequest(URL:imgURL!)
            NSURLConnection.sendAsynchronousRequest(request!, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                let img=UIImage(data:data)
                cell.imageView?.image=img
                self.imageCache[url]=img
            })
        }else{
            cell.imageView?.image = image
            println("哈哈哈哈")
        }
        
        if(indexPath.row == 0){
            var audioUrl:String = rowData["url"] as! String
            onSetAudio(audioUrl)
            onSetImage(url)
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        // tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var rowData: NSDictionary = self.indexDate[indexPath.row] as! NSDictionary
        var audioUrl:String = rowData["url"] as! String
        onSetAudio(audioUrl)
        let imgUrl:String=rowData["picture"] as! String
        onSetImage(imgUrl)
    }
    
    func didRecieveResults(results:NSDictionary){
        println("数据请求成功=============")
        if results["song"] != nil {
            self.indexDate=results["song"] as! NSArray
            self.tv.reloadData()
            
        }else if results["channels"] != nil{
            self.selectData=results["channels"] as! NSArray
            
        }

    }
    
    func onSetAudio(url:String){
        timer?.invalidate()
        playTime.text = "0:00"
        self.audioPlayer.stop()
        self.audioPlayer.contentURL=NSURL(string:url)
        self.audioPlayer.play()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onUpdate", userInfo: nil, repeats: true)
    }
    
    func onUpdate(){
        let nowTime = audioPlayer.currentPlaybackTime
        if nowTime > 0{
        let countTime = audioPlayer.duration
        let playScale = Float(nowTime / countTime)
        palyProgress.setProgress(playScale, animated: true)
        let all:Int = Int(nowTime)
        let m:Int = all / 60;
        let s:Int = all % 60;
            var mPre = ""
            var sPre = ""
            if m < 10{
                mPre = "0"
            }
            if s < 10{
                sPre = "0"
            }
            playTime.text = String("\(mPre)\(m):\(sPre)\(s)")
            
        }
    }
    
    func onSetImage(url:String){
        let image:UIImage? = self.imageCache[url]
        if image == nil{
            let imgURL:NSURL! = NSURL(string:url)
            let request:NSURLRequest=NSURLRequest(URL:imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
                let img=UIImage(data:data)
                self.iv.image=img
                self.imageCache[url]=img
                
            })
        }else {
            self.iv.image=image
        }
    }
    @IBAction func onPause(sender: UITapGestureRecognizer) {
        println("longzongqin")
        if sender.view == iv{
            println("iv")
            iv.removeGestureRecognizer(tap)
            playImg.addGestureRecognizer(tap)
            playImg.hidden = false
            audioPlayer.pause()
        }else if sender.view == playImg{
            println("playImg")
            playImg.removeGestureRecognizer(tap)
            iv.addGestureRecognizer(tap)
            playImg.hidden = true
            audioPlayer.play()
        }
    }
    
    @IBAction func nextMusic(sender: AnyObject) {
        eHttp.onSearch(nowMusicUrl)
    }
}

