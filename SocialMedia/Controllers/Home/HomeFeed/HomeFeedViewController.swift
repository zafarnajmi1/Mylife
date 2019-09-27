//
//  HomeFeedViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import IGListKit
import Material
import Hero

protocol FeedItemDelegate {
    func didSelectFeedItem(object: PostObject)
}

class HomeFeedViewController: UIViewController {
    
     let loader = JournalEntryLoader()
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
  
    var imageNameList : Array <NSString> = ["photo_1", "photo_2"]
   
    var data = [ListDiffable]()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var errorMessage: String? = "Please try again".localized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isMotionEnabled = true
        
        let storiesObject = FeedTypeStoriesObject()
        data.append(storiesObject)
        
        let statusObject = UpdateStatusObject()
        data.append(statusObject)
        
//        let object1 = FeedTypePicture()
//        object1.postBy = "Dexter"

//        let object2 = FeedTypeVideo()
        //let object3 = FeedTypePicture()
//        data.append(object4)
//        data.append(object3)
//        data.append(object1)
//        data.append(object2)
        
        loader.loadLatest()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let navigationController = self.navigationController as? NavigationController {
            navigationController.motionNavigationTransitionType = .auto
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // MARK: - API Calls
   
}

extension HomeFeedViewController: FeedItemDelegate {
    func didSelectFeedItem(object: ListDiffable) {
        motionTransitionType = .autoReverse(presenting: .zoom)
        
        if let navigationController = self.navigationController as? NavigationController {
            navigationController.motionNavigationTransitionType = .autoReverse(presenting: .zoom)
        }
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(ViewPostViewController.self)!
        let controller = MaterialNavigationController(rootViewController: postControleller)
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)
        controller.modalPresentationStyle = .overCurrentContext
        presentVC(controller)
        
        //segueTo(controller: .viewPostViewController)
        
    }
}

extension HomeFeedViewController: UpdateStatusDelegate {
    func onUpdateStatusClicked() {
        segueTo(controller: .updateStatusViewController)
    }
}

extension HomeFeedViewController: ViewPostDelegate {
    func didTapOnPost(at index: Int) {
        motionTransitionType = .autoReverse(presenting: .zoom)
        
        if let navigationController = self.navigationController as? NavigationController {
            navigationController.motionNavigationTransitionType = .autoReverse(presenting: .zoom)
        }
        
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(ViewPostViewController.self)!
        let controller = MaterialNavigationController(rootViewController: postControleller)
        controller.isMotionEnabled = true
        controller.motionTransitionType = .autoReverse(presenting: .auto)
        
        presentVC(controller)

    }
}

extension HomeFeedViewController: ViewFriendProfileDelegate {
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

extension HomeFeedViewController: SocialLabelTapDelegate {
    func didTapOnLikeLabel() {
        
    }
    
    func didTapOnCommenLabel() {
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(CommentsController.self)!
        postControleller.isMotionEnabled = true
        let controller = UINavigationController(rootViewController: postControleller)
        controller.view.backgroundColor = .white
        controller.isMotionEnabled = true
        
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.cover(direction: .up), dismissing: HeroDefaultAnimationType.uncover(direction: .down))
        
        presentVC(controller)
    }
    
    func didTapOnShareLabel() {
        
    }
}
//extension FeedViewController: IGListAdapterDataSource {
//    // 1
//    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
//        var items: [IGListDiffable] = pathfinder.messages
//        items += loader.entries as [IGListDiffable]
//        return items
//    }
//
//    // 2
//    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
//        if object is Message {
//            return MessageSectionController()
//        } else {
//            return
//                JournalSectionController()
//        }
//    }
//
extension HomeFeedViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var items: [ListDiffable] = data
        //items += loader.entries as [ListDiffable]
        return items
    }
    
    // Did select section
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is FeedTypeStoriesObject {
            return StoriesFeedSectionController()
        }
        else if object is UpdateStatusObject {
            let controller = UpdateStatusSectionController()
            controller.delegate = self
            
            return controller
        }
            //        else if object is FeedTypeSimple {
            //            return StoriesFeedSectionController()
            //
            //        }
        else {
            let pictureFeedController = PictureFeedSectionController()
            pictureFeedController.delegate = self
            pictureFeedController.viewPostDelegate = self
            pictureFeedController.viewFriendProfileDelegate = self
            pictureFeedController.socialTapDelegate = self
            
            return pictureFeedController
            //
        }
        //        else if object is FeedTypeVideo {
        //            let videoFeedController = VideoFeedSectionController()
        //            videoFeedController.delegate = self
        //            videoFeedController.viewPostDelegate = self
        //            videoFeedController.viewFriendProfileDelegate = self
        //            videoFeedController.socialTapDelegate = self
        //            return videoFeedController
        //        }
        //
        //        return PictureFeedSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return UIView()
    }
}

extension HomeFeedViewController: IGListAdapterDelegate {
    func listAdapter(_ listAdapter: ListAdapter, willDisplay object: Any, at index: Int) {
        
    }
    
    func listAdapter(_ listAdapter: ListAdapter, didEndDisplaying object: Any, at index: Int) {
        
    }
}

extension HomeFeedViewController: ViewStateProtocol {
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        
        self.errorMessage = "Please Try Again"
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}
