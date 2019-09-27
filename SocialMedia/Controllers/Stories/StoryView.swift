//
//  CustomStoryView.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 16/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import Alamofire
import NVActivityIndicatorView
import UIKit
import AVFoundation


protocol StoryViewDelegate {
    func storyViewSegmentDidChange(AtIndex _index : Int)
    func storyViewSegmentFinish(_ _view : StoryView)
    func storyViewDidEnd(_ _view : StoryView)
    func loadNextStory()
    func loadPreviousStory()
}

class StoryView: UIView,NVActivityIndicatorViewable {
    
    private var view: UIView!
    @IBOutlet weak var imgStory: UIImageView!
    @IBOutlet weak var progressView: UIStackView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSaveStory: UIButton!
    @IBOutlet weak var btnDeleteStory: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    var flagtime = false
    fileprivate var timerIndex : Int = 0
    var player: AVPlayer?
    
    var player2 : AVAudioPlayer?
    
    
    fileprivate var timer : Timer?
    fileprivate let timerInterval : TimeInterval = 0.125
    var currentStoryId : Int?
    var delegate: StoryViewDelegate?
    var story : StoriesData? {
        willSet(newTotalSteps) {}
        didSet {
            for subview in progressView.arrangedSubviews {
                subview.removeFromSuperview()
            }
            
            if let _ = story, let _snaps = story?.snaps {
                for _ in _snaps {
                    let rect : CGRect = CGRect(x: 0, y: 0, width: 10, height: 4)
                    let linearProgressView : LinearProgressView = LinearProgressView(frame: rect)
                    linearProgressView.barColor = .lightGray
                    linearProgressView.trackColor = .white
                    linearProgressView.barInset = 0.5
                    linearProgressView.isCornersRounded = true
                    linearProgressView.maximumValue = 8.0
                    linearProgressView.minimumValue = 0.0
                    linearProgressView.setProgress(0.0, animated: false)
                    progressView.addArrangedSubview(linearProgressView)
                }
            }
        }
    }
    
    var storyIndex : Int = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    
    @IBAction func deleteStoryAction(_ sender: Any) {
        print("delete story button pressed")
        let alertController = UIAlertController(title:"Remove Story".localized,message:"Are you sure you want to remove this story?".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
            print("ok button pressed")
            self.serverCallForDeleteStoryPermanently(index:(self.story?.id)!)
        }
        let cancelAction = UIAlertAction(title:"Cancel".localized,style: .default){UIAlertAction in
            print("cancel button pressed")
        }
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    func serverCallForDeleteStoryPermanently(index:Int){
        self.showLoader()
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        //        let objUser = UserHandler.sharedInstance.userData
        //        var userID: Int = (objUser?.id)!
        //        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "story_id" : index
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.removeStoryFromTimeLine
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Deleted".localized)
                    print("success")
                    if let _delegate = self.delegate {
                        _delegate.storyViewDidEnd(self)
                    }
                    
                }
            //  self.stopAnimating()
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                //   self.stopAnimating()
                self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        //self.present(alert, animated: true,completion: nil)
        
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alert, animated: true, completion: nil)
        
        
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        //  startAnimating(size, message: "Loading...",messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    
    @IBAction func saveStoryPermanentlyButtonAction(_ sender: Any) {
        print("save story button pressed")
        
        
        let alertController = UIAlertController(title:"Save Story".localized,message:"Are you sure you want to save this story?".localized, preferredStyle: .alert)
        let OkAction = UIAlertAction(title:"OK".localized,style: .default){UIAlertAction in
            print("ok button pressed")
            self.serverCallForSaveStoryPermanently()
        }
        let cancelAction = UIAlertAction(title:"CANCEL".localized,style: .default){UIAlertAction in
            print("cancel button pressed")
        }
        alertController.addAction(OkAction)
        alertController.addAction(cancelAction)
        
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func serverCallForSaveStoryPermanently(){
        var headers: HTTPHeaders
        if let userToken = UserDefaults.standard.value(forKey: "userAuthToken") as? String {
            headers = [
                "Accept": "application/json",
                "Authorization" : userToken  //"Bearer \(userToken)"
            ]
        } else{
            headers = [
                "Accept": "application/json",
            ]
        }
        
        //        let objUser = UserHandler.sharedInstance.userData
        //        var userID: Int = (objUser?.id)!
        //        print("user id ",userID)
        
        var parameters : [String: Any]
        parameters = [
            "story_id" : story?.id! ?? 0
        ]
        print("parameters", parameters)
        let url = ApiCalls.baseUrlBuild +  ApiCalls.saveFavouriteStory
        
        print("save  favourtie story url",url)
        
        Alamofire.request(url, method: .post , parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON{ response in
            switch response.result {
            case .success:
                let responseDic : [String : Any] = response.value as! [String : Any]
                print("\(responseDic)")
                if(response.result.description == "SUCCESS") {
                    
                    self.showAlrt(message: "Successfully Saved".localized)
                    print("success")
                    
                    
                }
            case .failure(let error):
                print("RESPONSE ERROR: \(error)")
                // self.showAlrt(message: "RESPONSE ERROR: \(error)")
                
            }
        }
        
    }
    
    
    
    
    
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle.main
        let nib = UINib(nibName: "StoryView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
    }
    
    func showData() {
        //          story?.userId
        //            UserHandler.sharedInstance.userData?.id
        lblName.text = story?.user?.fullName
        
        if story?.userId == UserHandler.sharedInstance.userData?.id{
            
            btnSaveStory.isHidden=false
            btnDeleteStory.isHidden=false
        }else{
            btnDeleteStory.isHidden=true
            btnSaveStory.isHidden=true
        }
        
        let time = story?.createdAt // .createdAt
        //        let date = Date(timeIntervalSince1970: TimeInterval(time!))
        //        let stringDate = date.toString(format: DateFormatType.custom("h:mm a EEEE"))
        //        lblTime.text = stringDate
        
        let timeStream = NSDate(timeIntervalSince1970: TimeInterval((time?.toDouble)!))
        let date1 = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
        lblTime.text = "\(date1)"
        
        
        imgProfile.setImage(url: (story?.user?.image)!)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedView)))
        clearStoryViewProgress()
        storyIndex = 0
        showStoryDetail()
    }
    
    fileprivate func clearStoryViewProgress() {
        for subview in progressView.arrangedSubviews {
            let linearProgressView : LinearProgressView = subview as! LinearProgressView
            linearProgressView.setProgress(0.0, animated: false)
        }
        imgStory.image = UIImage()
    }
    
    fileprivate func showStoryDetail() {
        inValidateTime()
        if let _ = story, let _snaps = story?.snaps {
            let storyModel = _snaps[storyIndex]
            if let _type = storyModel.type {
                if(_type == "image") { // Show Image
                    if let _url = storyModel.media {
                        let url : URL = URL(string: _url)!
                        imgStory.sd_setImage(with: url, completed: { (img, error , cacheType , imgUrl) in
                            if let _img = img {
                                self.imgStory.image = _img
                                self.runTimer(ByUserInfo: 0.125)
                                self.player?.pause()
                                self.player = nil
                                let time = storyModel.createdAt
                                let timeStream = NSDate(timeIntervalSince1970: TimeInterval((time?.toDouble)!))
                                let date1 = CommonMethods.timeAgoSinceDate(date: timeStream, numericDates:true)
                                self.lblTime.text = "\(date1)"
                                
                                
                            }
                        })
                    }
                    
                } else { // Show Video
                    if let _url = storyModel.media {
                        CacheManager.shared.getFileWith(stringUrl: _url) { result in
                            switch result {
                            case .success(let videoUrl):
                                self.player = AVPlayer(url: videoUrl)
                                let playerLayer = AVPlayerLayer( player :  self.player)
                                playerLayer.frame = self.imgStory.bounds
                                self.imgStory.layer.addSublayer(playerLayer)
                                
                                self.player?.play()
                                self.runTimer(ByUserInfo: 0.125)
                                break
                            case .failure(_):
                                print("Un able to download video")
                                break
                                // handle errror
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func timerDidChange(_ sender : Timer) {
        let count : CGFloat = sender.userInfo as! CGFloat
        if (count > 8.0) {
            if let _ = story, let _snaps = story?.snaps {
                if (storyIndex >= (_snaps.count - 1)) {
                    if let _delegate = delegate {
                        _delegate.loadNextStory()
                    }
                    return
                }
            }
            storyIndex = storyIndex + 1
            if(flagtime){
                print("print")
            }
            else{
                showStoryDetail()
                
            }
            return
        }
        let linearProgressView : LinearProgressView = progressView.arrangedSubviews[storyIndex] as! LinearProgressView
        linearProgressView.setProgress(Float(count), animated: true)
        runTimer(ByUserInfo: (count + 0.125))
    }
    
    func runTimer(ByUserInfo _userInfo : CGFloat) {
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self,   selector: (#selector(self.timerDidChange(_:))), userInfo: (_userInfo), repeats: false)
    }
    
    func inValidateTime() {
        if let _timer = timer {
            if(flagtime){
                print("print")
            }
            else{
                _timer.invalidate()
                
            }
        }
    }
    
    @objc private func tappedView(_ sender : UITapGestureRecognizer) {
        let location : CGPoint = sender.location(in: self.view)
        let width : CGFloat = UIScreen.main.bounds.size.width
        if ((width/2) > location.x) {//Left
            if let _ = story, let _snaps = story?.snaps {
                if (_snaps.count > 0 && storyIndex == 0) {
                    if let _delegate = delegate {
                        _delegate.loadPreviousStory()
                    }
                } else {
                    if (storyIndex < (progressView.arrangedSubviews.count - 1)) {
                        let linearProgressView : LinearProgressView = progressView.arrangedSubviews[storyIndex] as! LinearProgressView
                        linearProgressView.setProgress(8.0, animated: false)
                    }
                    storyIndex = storyIndex - 1
                    showStoryDetail()
                }
                
            } else {
                if let _delegate = delegate {
                    _delegate.loadPreviousStory()
                }
            }
        } else if ((width/2) < location.x) {//Right
            if let _ = story, let _snaps = story?.snaps {
                if ((_snaps.count - 1) == storyIndex) {
                    if let _delegate = delegate {
                        _delegate.loadNextStory()
                    }
                } else {
                    if (storyIndex < (progressView.arrangedSubviews.count - 1)) {
                        let linearProgressView : LinearProgressView = progressView.arrangedSubviews[storyIndex] as! LinearProgressView
                        linearProgressView.setProgress(8.0, animated: false)
                    }
                    storyIndex = storyIndex + 1
                    showStoryDetail()
                }
                
            } else {
                if let _delegate = delegate {
                    _delegate.loadNextStory()
                }
            }
        }
    }
    
    func showImage(WithURL url : String?, AtIndex _index: Int) {
        if let _url = url {
            let url : URL = URL(string: _url)!
            imgStory.sd_setImage(with: url, completed: { (img, error , cacheType , imgUrl) in
                if let _img = img {
                    if (_index == 0) {
                        //                        self.progressBar.startAnimation()
                    }
                    self.imgStory.image = _img
                }
            })
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        if let _delegate = delegate {
            flagtime = true
            self.player?.pause()
            self.player = nil
            if(delegate != nil){
                _delegate.storyViewDidEnd(self)
            }
            
            _delegate.storyViewDidEnd(self)
            
            
        }
    }
    private func showVideo(WithURL url:String) {
        CacheManager.shared.getFileWith(stringUrl: url) { result in
            
            switch result {
            case .success(let videoUrl):
                self.player = AVPlayer(url: videoUrl)
                let playerLayer = AVPlayerLayer(player: self.player)
                playerLayer.frame = self.imgStory.bounds
                self.imgStory.layer.addSublayer(playerLayer)
                self.player?.play()
                break
            case .failure(_):
                print("Un able to download video")
                break
                // handle errror
            }
        }
        
    }
}

//extension StoryView : SegmentedProgressBarDelegate {
//    func segmentedProgressBarChangedIndex(index: Int) {
//        showImage(WithURL: story?.snaps![index].url, AtIndex: index)
//        print("segment change")
//        if let _delegate = delegate {
//            _delegate.storyViewSegmentDidChange(AtIndex: index)
//        }
//    }
//    func segmentedProgressBarFinished() {
//        print("segment finish")
//        if let _delegate = delegate {
//            _delegate.storyViewSegmentFinish(self)
//        }
//    }
//}
////
///
///
//
///
///
//


//protocol StoryViewDelegate {
//    func storyViewSegmentDidChange(AtIndex _index : Int)
//    func storyViewSegmentFinish(_ _view : StoryView)
//    func storyViewSegmentCancel()
//}
//
//class StoryView: UIView {
//
//    private var view: UIView!
//    @IBOutlet weak var imgStory: UIImageView!
//    @IBOutlet weak var progressView: UIView!
//    @IBOutlet weak var imgProfile: UIImageView!
//    @IBOutlet weak var btnCancel: UIButton!
//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var lblTime: UILabel!
//
//    fileprivate var timerIndex : Int = 0
//    fileprivate var timer : Timer?
//    fileprivate let timerInterval : TimeInterval = 0.125
//
//    var delegate: StoryViewDelegate?
//    var progressBar: CustomSegmentedProgressBar!
//    var story : StoriesData?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        xibSetup()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        xibSetup()
//    }
//
//    private func xibSetup() {
//        view = loadViewFromNib()
//        view.frame = bounds
//        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
//        addSubview(view)
//    }
//
//    private func loadViewFromNib() -> UIView {
//        let bundle = Bundle.main
//        //        let bundle = Bundle(forClass: type(of: self))
//        let nib = UINib(nibName: "StoryView", bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//        return view
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
//
//    override func draw(_ rect: CGRect) {
//    }
//
//    func showData() {
//        lblName.text = story?.user?.fullName
//        let time = story?.createdAt
//        let date = Date(timeIntervalSince1970: TimeInterval(time!))
//        let stringDate = date.toString(format: DateFormatType.custom("h:mm a EEEE"))
//        lblTime.text = stringDate
//
//        imgProfile.setImage(url: (story?.user?.image)!)
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedView)))
//        if let _ = story, let _snaps = story?.snaps {
//            if (_snaps.count == 0) { return }
//
//            progressBar = CustomSegmentedProgressBar(numberOfSegments: _snaps.count, duration: 5.0)
////            progressBar = CustomSegmentedProgressBar(numberOfSegments: _snaps.count, duration: [TimeInterval]())
//            progressBar.frame = CGRect(x: 0, y: 0, width: progressView.frame.width , height: progressView.frame.height)
//            progressBar.topColor = .white
//            progressBar.bottomColor = .gray
//            progressBar.padding = 4.0
//            progressBar.delegate = self
//            progressView.addSubview(progressBar)
//            if let _type = _snaps[0].type {
//                if (_type == "image") {
//                    showImage(WithURL: _snaps[0].media, AtIndex: 0)
//                } else if (_type == "video") {
//                    showImage(WithURL: _snaps[0].media, AtIndex: 0)
//                }
//            }
//        }
//    }
//
//    @objc private func tappedView(_ sender : UITapGestureRecognizer) {
//        let location : CGPoint = sender.location(in: self.view)
//        let width : CGFloat = UIScreen.main.bounds.size.width
//        if ((width/2) > location.x) {//Left
//            progressBar.rewind()
//        } else if ((width/2) < location.x) {//Right
//            progressBar.skip()
//        }
//        //        progressBar.isPaused = !progressBar.isPaused
//    }
//
//    func showImage(WithURL url : String?, AtIndex _index: Int) {
//        if let _url = url {
//            let url : URL = URL(string: _url)!
//            //            self.progressBar.isPaused = true
//            imgStory.sd_setImage(with: url, completed: { (img, error , cacheType , imgUrl) in
//                //                self.progressBar.isPaused = false
//                if let _img = img {
//                    if (_index == 0) {
//                        self.progressBar.startAnimation()
//                    }
//                    self.imgStory.image = _img
//                }
//            })
//        }
//    }
//
//    private func showVideo(WithURL url:String) {
//        //        progressBar.isPaused = true
//        CacheManager.shared.getFileWith(stringUrl: url) { result in
//
//            //            self.progressBar.isPaused = false
//            switch result {
//            case .success(let videoUrl):
//                let player = AVPlayer(url: videoUrl)
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = self.imgStory.bounds
//                self.imgStory.layer.addSublayer(playerLayer)
//                player.play()
//                break
//            // do some magic with path to saved video
//            case .failure(_):
//                print("Un able to download video")
//                break
//                // handle errror
//            }
//        }
//
//    }
//    @IBAction func btnCancel(_ sender: Any) {
//        if let _delegate = delegate {
//            _delegate.storyViewSegmentCancel()
//        }
//    }
//}
//
//extension StoryView : CustomSegmentedProgressBarDelegate {
//
//    func segmentedProgressBarChangedIndex(index: Int) {
////        showImage(WithURL: story?.snaps![index].url, AtIndex: index)
//        print("segment change")
//        if let _delegate = delegate {
//            _delegate.storyViewSegmentDidChange(AtIndex: index)
//        }
//    }
//    func segmentedProgressBarFinished() {
//        print("segment finish")
//        if let _delegate = delegate {
//            _delegate.storyViewSegmentFinish(self)
//        }
//    }
//}
//
class alert {
    func msg(message: String, title: String = "")
    {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
        UIApplication.shared.keyWindow?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
}
