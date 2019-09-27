//
//  CreateGroupViewController.swift
//  SocialMedia
//
//  Created by Mughees Musaddiq on 18/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CreateGroupViewController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var arrayCreateGroupOnlineFriends = [UserGetAllFriendsData]()
    var arrSelectedID = [Int]()
    var arrSelectedName = [String]()
    
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet var createGroup: UIButton!
    // MARK: - Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Group Members".localized
        txtGroupName.placeholder = "Group Name".localized
        
        createGroup.setTitle("Create Group".localized, for: .normal)
        addBackButton()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "CreateGroupCell", bundle: nil), forCellReuseIdentifier: "CreateGroupCell")
        tblView.separatorStyle = .none
        tblView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCreateGroupOnlineFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CreateGroupCell = tblView.dequeueReusableCell(withIdentifier: "CreateGroupCell", for: indexPath) as! CreateGroupCell

        let dictionaryArray = arrayCreateGroupOnlineFriends[indexPath.item]
        cell.lblName.text = dictionaryArray.fullName
        cell.imgViewProfilePic.sd_setImage(with: URL(string: dictionaryArray.profilePicturePath), placeholderImage: UIImage(named: "placeholder.png"))
        cell.selectionStyle = .none
        
        if (dictionaryArray.isSelect) {
            cell.viewCell.backgroundColor = UIColor.init(hex: AppColor.primaryBlue)
        } else {
            cell.viewCell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictionaryArray = arrayCreateGroupOnlineFriends[indexPath.item]
        
        if (dictionaryArray.isSelect) {
            dictionaryArray.isSelect = false
            arrSelectedID = arrSelectedID.filter{$0 != dictionaryArray.id}
            arrSelectedName = arrSelectedName.filter{ $0 != dictionaryArray.fullName }
            print(arrSelectedID)
            print(arrSelectedName)
        } else {
            dictionaryArray.isSelect = true
            arrSelectedID.append(dictionaryArray.id)
            arrSelectedName.append(dictionaryArray.fullName)
            print(arrSelectedID)
            print(arrSelectedName)
        }
        tblView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    @IBAction func createGroup(_ sender: UIButton) {
        if (txtGroupName.text?.isEmpty)! {
            showAlrt(message: "Please specify group name".localized)
        } else if (arrSelectedID.count == 0) {
            showAlrt(message: "Please select atleast one group member".localized)
        } else {
            //call Create Group API
            self.createGroupChat()
        }
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    //MARK: - Create Group API
    func createGroupChat (){
        self.showLoader()
        var parameters : [String: Any] = ["group_id" : "" , "image[0]": "0", "title" : txtGroupName.text!, "group_members" : arrSelectedID, "privacy" : "members_only"]
        var groupMemberDictionary = [String: Any]()
        
        if arrSelectedID.first != 0 {
            for (key, value) in arrSelectedID.enumerated(){
                print(key)
                
                groupMemberDictionary ["group_members[\(key)]"] =  String(value)
            }
            print("groupMemberDictionary",groupMemberDictionary)
            parameters.update(other: groupMemberDictionary)
        }
        else{
            parameters ["group_members[0]"] =  "0"
        }
        print(parameters)
        ConversationsHandler.createGroupChat(params: parameters as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if (successResponse.statusCode == 200){
                self.stopAnimating()
                self.segueToGroupChatController(obj: successResponse)
//                self.arrayOnlineFriends = success.data
//                if self.arrayOnlineFriends.count > 0{
//                    self.collectionView.reloadData()
//                }
//                else{
//
//
//                }
            }
            else{
                self.stopAnimating()
                self.displayAlertMessage(successResponse.message)
                
                
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
            self.showError(message: errorResponse!.message)
        }
    }
    
    func segueToGroupChatController(obj: CreateGroupChatModel) {
        let groupChatControleller : GroupChatViewController = UIStoryboard.mainStoryboard.instantiateViewController(withIdentifier: "GroupChatViewController") as! GroupChatViewController
        groupChatControleller.isHeroEnabled = true
        groupChatControleller.isMotionEnabled = true
        groupChatControleller.navigTitle = obj.data.title!
        groupChatControleller.groupId = obj.data.id!
//        groupChatControleller.groupChatDetail = obj
        groupChatControleller.participantsArray = arrSelectedName
        self.navigationController?.pushViewController(groupChatControleller, animated: true)
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
