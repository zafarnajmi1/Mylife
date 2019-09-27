//
//  SearchViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

extension SegueIdentifiable {
    static var searchViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: SearchContainerViewController.className)
    }
}

class SearchContainerViewController: ButtonBarPagerTabStripViewController, sendPostId {
    
    // search delegate property
    
    override func viewDidLoad() {
        
        prepareView()
        super.viewDidLoad()
        registerDelegate()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Search Here".localized
        addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func registerDelegate()
    {
//        SearchContainerViewController.registerDelegate =  self
    }
    internal func postId(postId:Int){
        print("delegate Success")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let allSearchController = UIStoryboard.viewController(identifier: AllSearchController.className) as! AllSearchController
        
//        let postSearchController = UIStoryboard.viewController(identifier: PostSearchController.className) as! PostSearchController
        
        let peopleSearchController = UIStoryboard.viewController(identifier: PeopleSearchController.className) as! PeopleSearchController
        
        let photosSearcController = UIStoryboard.viewController(identifier: PhotosSearchController.className) as! PhotosSearchController
        
        let videosViewController = UIStoryboard.viewController(identifier: VideoSearchController.className) as! VideoSearchController
        
        return [allSearchController, peopleSearchController, photosSearcController, videosViewController]
    }
}

extension SearchContainerViewController {
    override func prepareView() {
        super.prepareView()
        
        setupXLPagerTab()
    }
    
    func setupXLPagerTab() {
        // change selected bar color
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = .primary
        settings.style.buttonBarItemFont = .semiBold
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .gray
            newCell?.label.textColor = .primary
           
        }
    }
}
