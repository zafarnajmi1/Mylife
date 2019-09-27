//
//  StoriesViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 08/12/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Kingfisher
import Disk
import AVKit
import Material

class StoriesViewController: UIViewController {
    
    @IBOutlet weak var imageViewContainer: UIView! {
        didSet {
            imageViewContainer.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var imageViewSnap: UIImageView!
    
    @IBOutlet weak var videoContainer: UIView! {
        didSet {
            videoContainer.backgroundColor = .clear
        }
    }
    
    @IBOutlet weak var buttonCancel: UIButton! {
        didSet {
            // buttonCancel.backgroundColor = .black
        }
    }
    
    @IBAction func actionClose(_ sender: UIButton) {
        self.popVC()
        self.dismissVC(completion: nil)
    }
    
    @IBOutlet weak var controlsContainerView: UIView!
    @IBOutlet weak var imageViewUserProfile: UIImageView!
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelSnapTime: UILabel!
    
    @IBAction func actionPrevious(_ sender: UIButton) {
        let index = currentPlayingIndex - 1
        
        if index >= 0 {
            segmentedController.endAnimationPrevious()
            //loadStories(index: index)
        }
    }
    
    @IBAction func actionNext(_ sender: UIButton) {
        let index = currentPlayingIndex + 1
        
        if index < snapsArray.count {
            segmentedController.endAnimation()
            //loadStories(index: index)
        }
    }
    
    var isPrefetchingVideos = false
    var isPrefetchingImages = false
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    var snapsArray = [StoriesSnap]()
    var user: StoriesUser?
    
    var segmentedController = SegmentedProgressBar(numberOfSegments: 0, duration: [TimeInterval]())
    
    var defaultImageDuration: TimeInterval = 5
    
    let imageExtensions = ["png", "jpg", "gif"]
    
    var currentPlayingIndex = 0
    
    func dismissController() {
        self.dismissVC(completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            self.prefetchResources()
        }
        
        DispatchQueue.main.async {
            self.setupView()
        }
        
        Timer.after(0.4) {
            //self.loadStories(index: 0)
        }
    }
    
    func setupView() {
        segmentedController = SegmentedProgressBar(numberOfSegments: snapsArray.count, duration: [TimeInterval]())
        segmentedController.frame = CGRect(x: 15, y: 20, width: view.frame.width - 30, height: 4)
        view.addSubview(segmentedController)
        
        segmentedController.topColor = UIColor.white
        segmentedController.bottomColor = UIColor.white.withAlphaComponent(0.25)
        segmentedController.padding = 2
        
        segmentedController.delegate = self
        
        buttonCancel.setImage(Icon.cm.clear!.tint(with: UIColor.white)!, for: .normal)
        buttonCancel.superview?.bringSubviewToFront(buttonCancel)
        
        guard let user = self.user,
            let url = URL(string: user.image) else { return }
        
        let resource = ImageResource(downloadURL: url, cacheKey: user.image)
        imageViewUserProfile.kf.setImage(with: resource)
        
        labelUserName.text = user.fullName
    }
    
    func prefetchResources() {
        var resources = [Resource]()
        
        var videoUrls = [StoriesSnap]()
        
        for snap in snapsArray {
            guard let url = URL(string: snap.media) else { return }
            
            if imageExtensions.contains(url.pathExtension) {
                let resource = ImageResource(downloadURL: url, cacheKey: snap.id.stringValue)
                
                resources.append(resource)
            } else {
                videoUrls.append(snap)
            }
        }
        
        if !resources.isEmpty {
            self.isPrefetchingImages = true
            prefetchImages(resources: resources)
        }
        
        if !videoUrls.isEmpty {
            prefetchVideos(snaps: videoUrls)
        }
    }
    
    func prefetchImages(resources: [Resource]) {
        let prefetcher = ImagePrefetcher(resources: resources, options: nil, progressBlock: { (skipped, failed, completed) in
            print(skipped, failed, completed)
        }, completionHandler: { (skipped, failed, completed) in
            print("These resources are prefetched: \(completed)")
            
            self.isPrefetchingImages = false
            
            if !self.isPrefetchingVideos {
               self.loadStories(index: 0)
            }
        })
        
        prefetcher.start()
    }
    
    func prefetchVideos(snaps: [StoriesSnap]) {
        for snap in snaps {
            
            guard let url = URL(string: snap.media) else { return }
            
            let name = snap.id.stringValue
            let pathExtention = url.pathExtension
            let fileName = name + "." + pathExtention
            
            if let retreivedURL = try? Disk.retrieve(fileName, from: .documents, as: URL.self) {
                print("yo url found ;\(retreivedURL)")
                
                self.isPrefetchingVideos = false
                
                if !self.isPrefetchingImages {
                    self.loadStories(index: 0)
                }
                
            } else if let retrievedData = try? Disk.retrieve(fileName, from: .documents, as: Data.self) {
                print("yo found previously \(retrievedData)")
                
                self.isPrefetchingVideos = false
                
                if !self.isPrefetchingImages {
                    self.loadStories(index: 0)
                }
            } else {
                
                do {
                    let videoData = try Data(contentsOf: url, options: [])
                    
                    try Disk.save(videoData, to: .documents, as: fileName)
                    
                    let retrievedData = try Disk.retrieve(fileName, from: .documents, as: Data.self)
                    
                    self.isPrefetchingVideos = false
                    
                    if !self.isPrefetchingImages {
                        self.loadStories(index: 0)
                    }
                    print("yo \(retrievedData)")
                } catch (let error) {
                    
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadStories(index: Int) {
        currentPlayingIndex = index
        if snapsArray.indices.contains(index) {
            
            let snap = snapsArray[index]
            currentPlayingIndex = index
            
            guard let url = URL(string: snap.media!) else { return }
            
            let time = snap.createdAt
            
            //        if let date = Date(fromString: time, format: DateFormatType.custom("EEE, d MMM yyyy h:mm a")) {
            //            labelSnapTime.text = date.toString()
            //        }
            
            let date = Date(timeIntervalSince1970: TimeInterval(time!))
            let stringDate = date.toString(format: DateFormatType.custom("h:mm a EEEE"))
            
            labelSnapTime.text = stringDate
            
            let pathExtention = url.pathExtension
            if imageExtensions.contains(pathExtention) {
                print("Image URL: \(String(describing: url))")
                
                imageViewContainer.isHidden = false
                videoContainer.isHidden = true
                
                //viewImage.sd_setImage(with: url as URL, placeholderImage: UIImage(named: ""))
                
                let resource = ImageResource(downloadURL: url, cacheKey: snap.id.stringValue)
                imageViewSnap.kf.setImage(with: resource)
                
                self.segmentedController.animate(index: index, duration: defaultImageDuration)
                controlsContainerView.superview?.bringSubviewToFront(controlsContainerView)
                
            } else {
                videoContainer.isHidden = false
                imageViewContainer.isHidden = true
                
                loadVideo(index: index, videoUrl: url, name: snap.id.stringValue)
            }
        }
    }
    
    func loadVideo (index: Int, videoUrl: URL, name: String) {
        let pathExtention = videoUrl.pathExtension
        let fileName = name + "." + pathExtention
        
        var url: URL
        
        if let retreivedURL = try? Disk.retrieve(fileName, from: .documents, as: URL.self) {
            url = retreivedURL
        } else {
            url = videoUrl
        }
        
        player = AVPlayer(url: url)
        playerController = AVPlayerViewController()
        
        guard let player = self.player, let playerController = self.playerController else {
            return
        }
        
        playerController.showsPlaybackControls = false
        
        playerController.player = player
        self.addChild(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = view.frame
        //NotificationCenter.default.addObserver(self, selector: #selector(ViewStoriesController.animationDidFinish(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        player.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        
        player.play()
        
        let asset = AVAsset(url: url)
        let videoDuration = asset.duration
        let duration = TimeInterval(CMTimeGetSeconds(videoDuration))
        
        self.videoDuration = duration
        DispatchQueue.main.async {
            //self.segmentedController.animate(index: self.currentPlayingIndex, duration: duration)
        }
        segmentedController.superview?.bringSubviewToFront(segmentedController)
        controlsContainerView.superview?.bringSubviewToFront(controlsContainerView)
    }
    
    var videoDuration: TimeInterval = 10
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            
            guard let player = self.player else { return }
            print(player.status)
            if player.status == AVPlayer.Status.readyToPlay {
                DispatchQueue.main.async {
                    self.segmentedController.animate(index: self.currentPlayingIndex, duration: self.videoDuration)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension StoriesViewController: SegmentedProgressBarDelegate {
    func didEndPlayingAnimation(at index: Int) {
        let nextIndex = index + 1
        
        if nextIndex < snapsArray.count {
            loadStories(index: index+1)
        }
    }
    
    func didEndPlayingAnimtionAfterSkipped(as index: Int) {
        loadStories(index: index)
    }
    
    func segmentedProgressBarChangedIndex(index: Int) {
        print("segmentedProgressBar: index did changed \(index)")
        //loadStories(index: index)
    }
    
    func segmentedProgressBarFinished() {
        print("segmentedProgressBar finished")
    }
    
    func segmentedProgressBarStartingAnimation() {
        
    }
    
    func segmentedProgressBarFinishedAnimation() {
        
    }
    
}
