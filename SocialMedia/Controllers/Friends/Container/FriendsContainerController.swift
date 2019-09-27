//
//  FriendsContainerController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import XLPagerTabStrip

extension SegueIdentifiable {
    static var friendsController : SegueIdentifier {
        return SegueIdentifier(rawValue: FriendsContainerController.className)
    }
}

class FriendsContainerController: ButtonBarPagerTabStripViewController {
    
    override func viewDidLoad() {
        
        prepareView()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Friends".localized
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
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let allFriendsController = UIStoryboard.viewController(identifier: AllFriendsController.className) as! AllFriendsController
        
        let recentFriendsController = UIStoryboard.viewController(identifier: RecentFriendsController.className) as! RecentFriendsController
        
        return [allFriendsController, recentFriendsController]
    }
}

extension FriendsContainerController {
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
