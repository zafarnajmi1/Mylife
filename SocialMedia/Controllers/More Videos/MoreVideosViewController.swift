//
//  MoreVideosViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import NVActivityIndicatorView

class MoreVideosViewController: UIViewController, NVActivityIndicatorViewable {
    
    let margin: CGFloat = 0
    let cellsPerRow = 2
    var arrayUserVideos = [UserVideosData]()
    var userObj: UserLoginData?
    var objOtherUser : AboutUserData?
    
    @IBOutlet weak var videoCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userObj = UserHandler.sharedInstance.userData
        setupUserVideos()
        self.title = "Videos".localized
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    //MARK:- Video Player
    func playVideo(url:String) {
        
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    //MARK:- APi Calls
    func setupUserVideos() {
        self.showLoader()
        var uid = Int()
        if objOtherUser?.id != nil {
            uid = (objOtherUser?.id)!
        }else{
            uid = (userObj?.id)!
        }

        let parameters : [String: Any] = ["user_id" :  String(uid) ]
        
        UserHandler.getUserVideos(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.arrayUserVideos = success.data
                self.videoCollectionView.reloadData()
                self.stopAnimating()
            }
            else
            {
                self.displayAlertMessage(success.message)
                self.stopAnimating()
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
    
    
}
// MARK: CollectionView
extension MoreVideosViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    fileprivate func collectionViewContent()
    {
        guard let flowLayout = videoCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        flowLayout.estimatedItemSize = flowLayout.itemSize // CGSize(width: 50, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayUserVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = videoCollectionView.dequeueReusableCell(withReuseIdentifier: MoreVideosCell.className, for: indexPath) as! MoreVideosCell
        let dictionaryArray = arrayUserVideos[indexPath.item]
        cell.ImageVideosGallery.sd_setImage(with: URL(string: dictionaryArray.postAttachmentData[0].thumbnail), placeholderImage: UIImage(named: "placeholder.png"))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objMessage = arrayUserVideos[indexPath.row]
        playVideo(url:objMessage.postAttachmentData[0].path)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}


class MoreVideosCell: UICollectionViewCell
{
    @IBOutlet weak var ImageVideosGallery: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
