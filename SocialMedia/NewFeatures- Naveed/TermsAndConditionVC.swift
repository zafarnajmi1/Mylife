//
//  TermsAndConditionVC.swift
//  SocialMedia
//
//  Created by My Technology on 20/12/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TermsAndConditionVC: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var myNavigationBar: UINavigationBar!
    
    
    //MARK: Properties
    var myrootModel = RootTermsModel()
    
    
    //MARK: controller Life cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms and Conditions".localized
        
        

        self.requestToGetTerms()
        
        print(self.myrootModel.toJSON())
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeBtnTapped(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
}


//MARK: - WebService Calls

extension TermsAndConditionVC {

    func requestToGetTerms() {
        TermsManager.shared.fetchTermsList { (error, rootModel) in
            if error == nil {
                self.myrootModel = rootModel!
                self.tableView.reloadData()
            }
            else {
                 self.showError(message: "Server is not Responding")
            }
        }
    }
    
    
}


//MARK: - tableView Delegate


extension TermsAndConditionVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.myrootModel.data != nil){
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Terms"
        case 1:
            return "Permissions"
        case 2:
            return "Privacy"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.myrootModel.data?.terms?.count ?? 0
        case 1:
            return self.myrootModel.data?.permissions?.count ?? 0
        case 2:
            return self.myrootModel.data?.privacy?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TermsAndConditionTableViewCell" ) as! TermsAndConditionTableViewCell
        
        
        switch indexPath.section {
        case 0:
            let model = self.myrootModel.data?.terms![indexPath.row]
            cell.myTitleLabel.text = model?.translation?.title!
            cell.myDetailLabel.text = model?.translation?.descriptionField
            return cell
        case 1:
            let model = self.myrootModel.data?.permissions![indexPath.row]
             cell.myTitleLabel.text = model?.translation?.title!
           cell.myDetailLabel.text = model?.translation?.descriptionField
             return cell
        case 2:
            let model = self.myrootModel.data?.privacy![indexPath.row]
            cell.myTitleLabel.text = model?.translation?.title!
            cell.myDetailLabel.text = model?.translation?.descriptionField
            return cell
        default:
            return cell
        }
        
    }
    
    
}


