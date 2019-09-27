//
//  PostSearchController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 25/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

extension SegueIdentifiable {
    static var postSearchController : SegueIdentifier {
        return SegueIdentifier(rawValue: PostSearchController.className)
    }
}

class PostSearchController: UIViewController {
    var errorMessage: String? = "Please Try Again"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(getDataUpdate), name: NSNotification.Name(rawValue: Post_ScreenNotification), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        let userDefaults = UserDefaults.standard
        userDefaults.set("2", forKey: "searchKey")
        userDefaults.synchronize()
    }
    @objc private func getDataUpdate() {
        let searchType = (UserDefaults.standard.value(forKey: "searchString") as? String)
        print(searchType!)
        
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

extension PostSearchController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Posts")
    }
}

extension PostSearchController: ViewStateProtocol {
    @objc func handleTap(_ sender: UIView) {
        addView(withState: .loading)
        
        self.errorMessage = "Please Try Again"
        addView(withState: .error)
        
        addView(withState: .empty)
        
        removeAllViews()
    }
}
