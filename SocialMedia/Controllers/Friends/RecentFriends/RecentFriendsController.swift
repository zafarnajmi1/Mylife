//
//  RecentFriendsController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class RecentFriendsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let friends = ModelGenerator.generateRequestModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Friends".localized
        addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AllFriendsCell.className, for: indexPath) as! AllFriendsCell

        let friend = friends[indexPath.row]
        cell.labelName.text = friend.name
        cell.labelMutualFriends.text = friend.mutalFriends.toString + " mutual friends"
        
        return cell
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

extension RecentFriendsController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Recent")
    }
}

