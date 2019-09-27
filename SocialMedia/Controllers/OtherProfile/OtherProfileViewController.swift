//
//  OtherProfileViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 31/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import IGListKit
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var otherProfileViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: OtherProfileViewController.className)
    }
}

class OtherProfileViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet var collectionView: UICollectionView!
    
    var data = [ListDiffable]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileHeaderObject = ProfileHeaderViewObject()
        data.append(profileHeaderObject)
        
        let object1 = FeedTypePicture()
        let object2 = FeedTypeVideo()
        
        data.append(object1)
        data.append(object2)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Profile"
        addBackButton()
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
    
    // MARK: - API Calls
    func followTheUser(id: String)
    {
        self.showLoader()
        let parameters : [String: Any] = ["following_id" : id]
        
        FriendsHandler.followTheUser(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.stopAnimating()
                self.displayAlertMessage("Successfully Followed")
                
                
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
            
        }
    }
    
    // MARK: - API Calls
    func unFollowTheUser(id: String){
        self.showLoader()
        let parameters : [String: Any] = ["following_id" : id]
        
        FriendsHandler.unFollowTheUser(params: parameters as NSDictionary , success: { (success) in
            if(success.statusCode == 200){
                self.stopAnimating()
                self.displayAlertMessage("Successfully Un-Followed")
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        }){ (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            self.stopAnimating()
        }
    }
}

// MARK: UpdateStatusDelegate
extension OtherProfileViewController: UpdateStatusDelegate {
    func onUpdateStatusClicked() {
        segueTo(controller: .updateStatusViewController)
    }
}

// MARK: ProfileHeaderDelegate
extension OtherProfileViewController: ProfileHeaderDelegate {
    func openActivityLogController() {
        segueTo(controller: .activityLogController)
    }
    
    func openAboutController() {
        //        segueTo(controller: .aboutViewcontroller)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func openFriendsController() {
        
    }
    
    func openFollowersViewController() {
        
        followTheUser(id:"20")
    }
    
    func openMyFollowingsViewController() {
        
        unFollowTheUser(id: "20")
    }
    
    func openEditProfileController() {
        segueTo(controller: .editProfileViewController)
    }
}

//MARK: ListAdapterDataSource
extension OtherProfileViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is ProfileHeaderViewObject {
            let controller = ProfileHeaderSectionController()
            controller.delegate = self
            
            return controller
        } else if object is UpdateStatusObject {
            let controller = UpdateStatusSectionController()
            controller.delegate = self
            
            return controller
        } else if object is FeedTypeSimple {
            return StoriesFeedSectionController()
        } else if object is FeedTypePicture {
            return PictureFeedSectionController()
        } else if object is FeedTypeVideo {
            return VideoFeedSectionController()
        }
        
        return ProfileHeaderSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
