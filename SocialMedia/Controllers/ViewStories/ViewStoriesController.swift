 //
 //  ViewStoriesController.swift
 //  SocialMedia
 //
 //  Created by iOSDev on 11/9/17.
 //  Copyright © 2017 My Technology. All rights reserved.
 //
 
 import UIKit
 import DSGradientProgressView
 import AVKit
 import NVActivityIndicatorView
 import Material
 import Kingfisher
 import Disk
 
 class ViewStoriesController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var viewVideos: UIView!
    @IBOutlet weak var oltClose: UIButton!
    @IBOutlet weak var viewGradient: DSGradientProgressView!
    
    @IBOutlet weak var oltPrevious: UIButton!
    @IBOutlet weak var oltNext: UIButton!
    
    var segmentedProgressBar: SegmentedProgressBar?
    
    //private var videoURL: URL
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    var snapsArray : [StoriesSnap]!
    
    let imageExtensions = ["png", "jpg", "gif"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentSnapIndex = 0

        viewGradient.barColor = UIColor.green
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.segmentedProgressBar?.removeFromSuperview()
        segmentedProgressBar = nil
        currentSnapIndex = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom
    var lastIndex = 0
    var urlArray = [String]()
    
    var currentSnapIndex = 0
    
    func setupViews() {
        let segmentedController = SegmentedProgressBar(numberOfSegments: snapsArray.count, duration: [TimeInterval]())
        segmentedController.layoutView()
        segmentedController.frame = CGRect(x: 15, y: 15, width: view.frame.width - 30, height: 4)
        view.addSubview(segmentedController)
        
        segmentedController.topColor = UIColor.white
        segmentedController.bottomColor = UIColor.white.withAlphaComponent(0.25)
        segmentedController.padding = 2
        
        segmentedController.delegate = self
        
        segmentedProgressBar = segmentedController
        
        
        /*
            if self.snapsArray.count > 1 {
        }*/
        
        for item in self.snapsArray {
            let itemUrl = item.media
            urlArray.append(itemUrl!)
            
            guard let url = URL(string: itemUrl!) else { return }
            let pathExtention = url.pathExtension
            if !imageExtensions.contains(pathExtention) {
                DispatchQueue.global().async {
                    //self.downloadVideo(url: url, name: item.id!.stringValue)
                }
            }
        }
        
        viewGradient.isHidden = true
        print(urlArray)
        
        currentSnapIndex = 0
        Timer.after(2) {
            self.loadMedia()
        }
    }
    
    func downloadVideo(url: URL, name: String) {
        let pathExtention = url.pathExtension
        let fileName = name + pathExtention
        
        if let retreivedURL = try? Disk.retrieve(fileName, from: .documents, as: URL.self) {
            print("yo url found ;\(retreivedURL)")
        } else if let retrievedData = try? Disk.retrieve(fileName, from: .documents, as: Data.self) {
            print("yo found previously \(retrievedData)")
        } else {
            
            do {
                let videoData = try Data(contentsOf: url, options: [])
                
                try Disk.save(videoData, to: .documents, as: fileName)
                
                let retrievedData = try Disk.retrieve(fileName, from: .documents, as: Data.self)
                print("yo \(retrievedData)")
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadMedia() {
        if currentSnapIndex < self.snapsArray.count && currentSnapIndex != -1 {
            let snap = self.snapsArray[currentSnapIndex]
            
            let snapURL = snap.media
            
            //let objStoryUrl = self.urlArray[lastIndex]
            
            guard let url = URL(string: snapURL!) else { return }
            
            print(url)
            let pathExtention = url.pathExtension
            if imageExtensions.contains(pathExtention) {
                print("Image URL: \(String(describing: url))")
                
                viewImage.isHidden = false
                viewVideos.isHidden = true
                //viewImage.sd_setImage(with: url as URL, placeholderImage: UIImage(named: ""))
                
                let resource = ImageResource(downloadURL: url, cacheKey: snap.id.stringValue)
                viewImage.kf.setImage(with: resource)
                self.segmentedProgressBar?.startAnimation()

                
//                viewImage.kf.setImage(with: resource, placeholder: UIImage(named: ""), options: nil, progressBlock: { (progress1, progress2) in
//                    
//                }, completionHandler: { (image, error, cache, url) in
//                })
//                
                //            viewImage.sd_setImage(with: url as URL, placeholderImage: UIImage(names: ""), options: [SDWebImageOptions.SDWebImageRetryFailed], completed: { (image, error, cache, url) in
                //                self.segmentedProgressBar.startAnimation()
                //            })
                //
                //            viewImage.sd_setShowActivityIndicatorView(true)
                //            viewImage.sd_setIndicatorStyle(.gray)
                viewImage.contentMode = .scaleAspectFill
                viewImage.clipsToBounds = true
                lastIndex = lastIndex + 1
                print(lastIndex)
                print(urlArray.count)
                
            } else {
                //self.showLoader()
                viewVideos.isHidden = false
                viewVideos.backgroundColor = .white
                viewImage.isHidden = true
                print("Movie URL: \(String(describing: url))")

                loadVideo(videoUrl: url as URL, name: snap.id.stringValue)
                /*
                 self.player = AVPlayer(url:url! as URL)
                 self.avpController = AVPlayerViewController()
                 self.avpController.player = self.player
                 avpController.view.frame = self.viewVideos.frame
                 self.avpController.showsPlaybackControls = false
                 self.addChildViewController(avpController)
                 
                 NotificationCenter.default.addObserver(self,
                 selector: #selector(ViewStoriesController.animationDidFinish(_:)),
                 name: .AVPlayerItemDidPlayToEndTime,
                 object: player?.currentItem)
                 
                 self.view.addSubview(avpController.view)
                 self.stopAnimating()
                 self.isPlayed = false
                 self.avpController.player?.play()*/
            }
        }
        
    }
    
    func loadVideo (videoUrl: URL, name: String) {
        let pathExtention = videoUrl.pathExtension
        let fileName = name + pathExtention
        
        if let retreivedURL = try? Disk.retrieve(fileName, from: .documents, as: URL.self) {
            player = AVPlayer(url: retreivedURL)
        } else {
            player = AVPlayer(url: videoUrl)
        }
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChild(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewStoriesController.animationDidFinish(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        player?.addObserver(self, forKeyPath: "rate", options: NSKeyValueObservingOptions.new, context: nil)
        
        player?.play()
        
        segmentedProgressBar?.superview?.bringSubviewToFront(segmentedProgressBar!)
        oltClose.superview?.bringSubviewToFront(oltClose)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "rate" {
            guard let player = self.player else { return }
            
            if player.rate > 0 || player.status == AVPlayer.Status.readyToPlay {
                print("video started")
                guard let cmTime = player.currentItem?.duration else { return }
                let duration = TimeInterval(CMTimeGetSeconds(cmTime))
                segmentedProgressBar?.startAnimation()
            }
        }
    }
    
    func animationDidFinish(_ notification: NSNotification) {
        //segmentedProgressBar.setDuration(duration: 5)
        //        lastIndex = lastIndex + 1
        //        print(lastIndex)
        //        print(self.urlArray.count)
        //
        //        if lastIndex == self.urlArray.count{
        //            self.dismiss(animated: false, completion: nil)
        //        }else{
        //            self.player = nil
        //            self.loadMedia()
        //        }
    }
    var isPlayed = false
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: CMTime.zero)
            self.player!.play()
        }
    }
    
    // MARK :- IBActions
    @IBAction func actionClose(_ sender: Any) {
        self.dismissVC {
            self.segmentedProgressBar = nil
            self.currentSnapIndex = 0
        }
    }
    
    @IBAction func actionPrevious(_ sender: Any) {
        print(urlArray.count)
        print(lastIndex)
        
        if lastIndex == 1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            lastIndex = lastIndex - 1
            if lastIndex == 1 {
                lastIndex = 0
            }
            loadMedia()
        }
    }
    
    @IBAction func actionNext(_ sender: Any) {
        if lastIndex == urlArray.count{
            self.dismiss(animated: true, completion: nil)
        } else {
            //lastIndex = lastIndex + 1
            loadMedia()
        }
    }
 }
 
 extension ViewStoriesController: SegmentedProgressBarDelegate {
    func didEndPlayingAnimtionAfterSkipped(as index: Int) {
        
    }
    
    func didEndPlayingAnimation(at index: Int) {
        
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
//        currentSnapIndex = index
//
//        if currentSnapIndex < snapsArray.count && currentSnapIndex != -1 {
//            loadMedia()
//        } else {
//            dismiss(animated: false, completion: nil)
//        }
    }
    
    func segmentedProgressBarFinished() {
       // dismiss(animated: false, completion: nil)
    }
    
    func segmentedProgressBarStartingAnimation() {
        
    }
    
    func segmentedProgressBarFinishedAnimation() {
        currentSnapIndex += 1
        
        if currentSnapIndex < snapsArray.count && currentSnapIndex != -1 {
            loadMedia()
        } else {
           // dismiss(animated: false, completion: nil)
        }
    }
 }
