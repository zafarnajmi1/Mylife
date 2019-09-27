//
//  BlockUserListVC.swift
//  SocialMedia
//
//  Created by My Technology on 21/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class BlockUserListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Properties
     var myRootModel = RootBlockedUserModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.title = "Blocked Contacts".localized
        
          addBackButton()
        
        self.requestToFetchBlockUserList()
    }

   
}

extension BlockUserListVC {
    
    func requestToFetchBlockUserList () {

        
        UserBlockManager.shared.fetchBlockUserList { (error, rootModel) in
            
         
           
            if error == nil {
                self.myRootModel = rootModel!
                
                if self.myRootModel.data?.count == 0 {
                    self.showSuccess(message: "No record found".localized)
                    return
                }
                self.tableView.reloadData()
               
                
            }
            else {
                self.showError(message: error!)
            }
        }
        
    }
}

extension BlockUserListVC: UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myRootModel.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlockUserTableViewCell") as! BlockUserTableViewCell
        cell.myController = self
        cell.delegate = self
        
        let model = self.myRootModel.data![indexPath.row]
        cell.setData(model: model)
        
        return cell
    }
    
    
}

extension BlockUserListVC: BlockUserTableViewCellDelegate {
    func refreshTablView() {
        self.requestToFetchBlockUserList()
    }
    
    
}
