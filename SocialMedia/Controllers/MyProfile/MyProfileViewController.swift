//
//  MyProfileViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import IGListKit
import Material

extension SegueIdentifiable {
    static var myProfileController : SegueIdentifier {
        return SegueIdentifier(rawValue: MyProfileViewController.className)
    }
}

class MyProfileViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var data = [ListDiffable]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileHeaderObject = ProfileHeaderViewObject()
        data.append(profileHeaderObject)
        
        let statusObject = UpdateStatusObject()
        data.append(statusObject)
        
        
        let object1 = FeedTypePicture()
      //  let object2 = FeedTypeVideo()
        
        //data.append(object1)
       // data.append(object2)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Profile".localized
        addBackButton()
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

// MARK: UpdateStatusDelegate
extension MyProfileViewController: UpdateStatusDelegate {
    func onUpdateStatusClicked() {
        segueTo(controller: .updateStatusViewController)
    }
}

// MARK: ProfileHeaderDelegate
extension MyProfileViewController: ProfileHeaderDelegate {
 
    func openActivityLogController() {
        segueTo(controller: .activityLogController)
    }
    
    func openAboutController() {
        segueTo(controller: .aboutViewcontroller)
    }
    
    func openFriendsController() {
        segueTo(controller: .friendsController)
    }
    
    func openFollowersViewController() {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FollowersViewController") as? FollowersViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func openMyFollowingsViewController() {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyFollowingsViewController") as? MyFollowingsViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    func openEditProfileController() {
        segueTo(controller: .editProfileViewController)
    }
}

extension MyProfileViewController: FeedItemDelegate {
    func didSelectFeedItem(object: ListDiffable) {
        motionTransitionType = .autoReverse(presenting: .zoom)
        
        if let navigationController = self.navigationController as? NavigationController {
            navigationController.motionNavigationTransitionType = .autoReverse(presenting: .zoom)
        }
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(ViewPostViewController.self)!
        let controller = MaterialNavigationController(rootViewController: postControleller)
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)
        
        //Uncomment this
       // presentVC(controller)
    }
}


extension MyProfileViewController: ViewPostDelegate {
    func didTapOnPost(at index: Int) {
        motionTransitionType = .autoReverse(presenting: .zoom)
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(ViewPostViewController.self)!
        let controller = MaterialNavigationController(rootViewController: postControleller)
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)
        
        presentVC(controller)
        
    }
}

extension MyProfileViewController: SocialLabelTapDelegate {
    func didTapOnLikeLabel() {
        
    }
    
    func didTapOnCommenLabel() {
        segueTo(controller: .commentsController)
    }
    
    func didTapOnShareLabel() {
        
    }
}

extension MyProfileViewController: ViewFriendProfileDelegate {
    func didTapOnFriendProfile(profileId: Int) {
        motionTransitionType = .autoReverse(presenting: .push(direction: .left))
        
        if let navigationController = self.navigationController as? NavigationController {
            navigationController.motionNavigationTransitionType = .autoReverse(presenting: .push(direction: .left))
        }
        
        let controller = UIStoryboard.mainStoryboard.instantiateViewController(OtherProfileViewController.self)!
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .push(direction: .left))
        
        segueTo(controller: .otherProfileViewController)
    }
}


//MARK: ListAdapterDataSource
extension MyProfileViewController: ListAdapterDataSource {
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
            let pictureFeedController = PictureFeedSectionController()
            pictureFeedController.delegate = self
            pictureFeedController.viewPostDelegate = self
            pictureFeedController.viewFriendProfileDelegate = self
            pictureFeedController.socialTapDelegate = self
            
            return pictureFeedController
        } else if object is FeedTypeVideo {
            let videoFeedController = VideoFeedSectionController()
            videoFeedController.delegate = self
            videoFeedController.viewPostDelegate = self
            videoFeedController.viewFriendProfileDelegate = self
            videoFeedController.socialTapDelegate = self
            
            return videoFeedController
        }
        return StoriesFeedSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
