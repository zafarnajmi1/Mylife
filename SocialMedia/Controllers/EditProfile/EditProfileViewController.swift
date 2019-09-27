//
//  EditProfileViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
import NVActivityIndicatorView
import DatePickerDialog
import DropDown


extension SegueIdentifiable {
    static var editProfileViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: EditProfileViewController.className)
    }
}

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NVActivityIndicatorViewable {
    
    enum AddInfo: Int {
        case work = 400
        case education = 500
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = tableView.rowHeight
        }
    }
    
    
    var obj: UserLoginData?
    
    var privacy = ""
    
    var dateOfBirth = String()
    let dropDownHeaderMenu = DropDown()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        obj = UserHandler.sharedInstance.userData
        
        addBackButton()
        
        self.title = "Edit Profile".localized
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        obj = UserHandler.sharedInstance.userData
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    
    }
    
    @objc func btnRelationship(_ sender : UIButton) {
        dropDownHeaderMenu.anchorView = sender
        dropDownHeaderMenu.dataSource = ["Single".localized,"Engaged".localized, "Married".localized, "Widowed".localized, "Seperated".localized, "Divorced".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            if(item == "Single".localized){
                
                self.addUserInfo(index: 5, text: "single".localized)
            }
            
            if(item == "Engaged".localized){
                
                self.addUserInfo(index: 5, text: "engaged".localized)
            }
            
            if(item == "Married".localized){
                
                self.addUserInfo(index: 5, text: "married".localized)
            }
            
            if(item == "Widowed".localized){
                
                self.addUserInfo(index: 5, text: "widowed".localized)
            }
            
            if(item == "Seperated".localized){
                
                self.addUserInfo(index: 5, text: "seperated".localized)
            }
            
            if(item == "Divorced".localized){
                
                self.addUserInfo(index: 5, text: "divorced".localized)
            }
            
          //  self.addUserInfo(index: 5, text: item)
        }
    }
    
    @objc func btnBirthday(_ sender : UIButton) {
        self.datePickerFromWork()
    }
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    // MARK: - API Call Edit User Information
    func addUserInfo(index: Int, text:String)
    {
        self.showLoader()
        let parameters : [String: Any]
        if index == 0{
            parameters  = [
                "full_name": text
            ]
        }else if index == 1{
            parameters  = [
                "living_place": text
            ]
        }
        else if index == 2{
            parameters  = [
                "mobile": text
            ]
        }
        else if index == 3{
            parameters  = [
                "birthday": text
            ]
        }else if index == 4{
            parameters  = [
                "gender": text
            ]
        } else if index == 5{
            parameters  = [
                "relationship": text
            ]
        }
        else if index == 6{
            parameters  = [
                 "about_me": text
            ]
        }
        else if index == 7{
            parameters  = [
                "living_place_privacy": text
            ]
        }
            
        else if index == 8{
            parameters  = [
                "mobile_privacy": text
            ]
        }
      
        else if index == 9{
            parameters  = [
                "dob_privacy": text
            ]
        }
        else if index == 10{
            parameters  = [
                "relationship_privacy": text
            ]
        }
      
        else if index == 11{
            parameters  = [
                "about_me_privacy": text
            ]
        }
       
        else if index == 12{
            parameters  = [
                "work_privacy": text
            ]
        }
        
        else if index == 13{
            parameters  = [
                "education_privacy": text
            ]
        }else if(index == 14){
            parameters  = [
                "email_privacy": text
            ]
        }
        else{
            parameters  = [
                "text": text
            ]
        }
         
        
        
        print(parameters)
        UserHandler.editUserInfo(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200) {
                self.obj?.fullName = success.data.fullName
                self.obj?.livingPlace = success.data.livingPlace
                self.obj?.mobile = success.data.mobile
                self.obj?.birthday = success.data.birthday
              self.obj?.living_place_privacy = success.data.living_place_privacy
                
                self.obj?.email_privacy = success.data.email_privacy
                
                self.obj?.mobile_privacy = success.data.mobile_privacy

                self.obj?.dob_privacy = success.data.dob_privacy
                self.obj?.relationship_privacy = success.data.relationship_privacy
                self.obj?.about_me_privacy = success.data.about_me_privacy

                     self.obj?.work_privacy = success.data.work_privacy
                self.obj?.education_privacy = success.data.education_privacy

                self.obj?.gender = success.data.gender
                self.obj?.relationship = success.data.relationship
                self.obj?.aboutMe = success.data.aboutMe
                UserHandler.sharedInstance.userData = self.obj
                self.tableView.reloadData()
                self.stopAnimating()
            }
            else{
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
    // MARK: - API Call Delete Work Information
    func deleteWorkInformation (workId:String,indexId: Int, indexPathid: IndexPath) {
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            "work_id" : workId
        ]
        print(dictionaryForm)
        
        UserHandler.deleteWorkInfo(params: dictionaryForm as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.self.obj?.workDetails.remove(at: indexId)
                self.tableView.deleteRows(at: [indexPathid], with: .fade)
                self.stopAnimating()
                
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
        }
    }
    // MARK: - API Call Delete Education Information
    func deleteEducationInformation (educationId:String,indexId: Int, indexPathid: IndexPath) {
        self.showLoader()
        var dictionaryForm = Dictionary<String, String>()
        dictionaryForm = [
            "education_id" : educationId
        ]
        print(dictionaryForm)
        
        UserHandler.deleteEducationInfo(params: dictionaryForm as NSDictionary, success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.self.obj?.educationDetails.remove(at: indexId)
                self.tableView.deleteRows(at: [indexPathid], with: .fade)
                self.stopAnimating()
                
            }
        }) { (errorResponse) in
            print(errorResponse!)
            self.stopAnimating()
        }
    }
    
    // MARK: - Alert Edit User Information
    func editUserInformation(title:String,message:String,placeholder:String,textThatHasToBeEdit:String, index:Int)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = placeholder
            textField.text = textThatHasToBeEdit
            if index == 3{
                textField.keyboardType = UIKeyboardType.asciiCapableNumberPad
            }
            else{
                textField.keyboardType = UIKeyboardType.alphabet
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized, style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            
        }
        let saveAction = UIAlertAction(title: "Save".localized, style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            let firstTextField = alertController.textFields![0] as UITextField
            
            if index == 0{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
            }else if index == 1{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
                
            }else if index == 2{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
                
            }else if  index == 3{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
            }
            else if  index == 4{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
            }
            else if  index == 6{
                if !(firstTextField.text?.isEmpty)!{
                    self.addUserInfo(index: index, text:firstTextField.text!)
                }
                else{
                    self.displayAlertMessage("Textfield cannot be empty.".localized)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func btnDropdwon(_ sender : UIButton) {

        let indexpath = NSIndexPath(row: 0, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! UserInfoCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 7, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 7, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 7, text: "only_me".localized)
            }
          
          
          
           
        }
        
        
    }
    
    
    @objc func btnDropdwon22(_ sender : UIButton) {
        
        let indexpath = NSIndexPath(row: 2, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! UserInfoCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 14, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 14, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 14, text: "only_me".localized)
            }
            
            
            
            
        }
        
        
    }
    
    
    
    @objc func btnDropdwon2(_ sender : UIButton) {
        print(sender.frame)
        self.view.layoutSubviews()
         
        
        let indexpath = NSIndexPath(row: 3, section: 0)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! UserInfoCell

        let xAxis = cell.contentView.frame.size.width - 140
       let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
    cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
          
           
            if(item == "Public".localized){
             v.removeFromSuperview()
                
                self.addUserInfo(index: 8, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 8, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 8, text: "only_me".localized)
            }
          
           
        }
        
        
    }
    @objc func btnDropdwon3(_ sender : UIButton) {
        
        let indexpath = NSIndexPath(row: 0, section: 1)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! EditBirthdayAndGenderInformationCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
           
            
          
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 9, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 9, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 9, text: "only_me".localized)
            }
          
            
           
        }
        
        
    }
    @objc func btnDropdwon4(_ sender : UIButton) {
        
        let indexpath = NSIndexPath(row: 0, section: 2)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! EditRelationshipInformationCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            
            
          
            
           
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 10, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 10, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 10, text: "only_me".localized)
            }
          
          
        }
        
        
    }
    @objc func btnDropdwon5(_ sender : UIButton) {
        
        let indexpath = NSIndexPath(row: 0, section: 3)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! AboutEditCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            
            if(item == "Public".localized){
                v.removeFromSuperview()
                 self.addUserInfo(index: 11, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 11, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 11, text: "only_me".localized)
            }
            
           
            
        
         
        }
        
        
    }
    @objc func btnDropdwon6(_ sender : UIButton) {
        let row = sender.tag
        let indexpath = NSIndexPath(row: row, section: 4)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! AddInfoCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            
            
            
            
          
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 12, text: "public".localized)
            }
            
            if(item == "Friends"){
                v.removeFromSuperview()
                self.addUserInfo(index: 12, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 12, text: "only_me".localized)
            }
         
           
        }
        
        
    }
    @objc func btnDropdwon7(_ sender : UIButton) {
        
        let row = sender.tag
        let indexpath = NSIndexPath(row: row, section: 5)
        let cell = self.tableView.cellForRow(at: indexpath as IndexPath) as! AddInfoCell
        
        let xAxis = cell.contentView.frame.size.width - 140
        let v = UIView.init(frame: CGRect.init(x: xAxis , y:sender.frame.origin.y - 10 , w: sender.frame.size.width, h: sender.frame.size.height))
        cell.addSubview(v)
        dropDownHeaderMenu.anchorView = v
        dropDownHeaderMenu.dataSource = ["Public".localized,"Friends".localized, "Only Me".localized]
        dropDownHeaderMenu.show()
        dropDownHeaderMenu.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected Item \(item) at index: \(index)")
            
            
            
            
            
            
           
            if(item == "Public".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 13, text: "public".localized)
            }
            
            if(item == "Friends".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 13, text: "friend".localized)
            }
            
            if(item == "Only Me".localized){
                v.removeFromSuperview()
                self.addUserInfo(index: 13, text: "only_me".localized)
            }
           
        }
        
        
    }
    // MARK: - Datepicker
    func datePickerFromWork() {
        DatePickerDialog().show("DatePicker".localized, doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.dateOfBirth = String(dt.timeIntervalSince1970)
                self.addUserInfo(index: 3, text:self.dateOfBirth.localized)
//                obj = UserHandler.sharedInstance.userData
            }
        }
    }
    // MARK: - Tableview Delegates Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if obj?.email != nil
        {
            return 6
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.row == 1 {
//            return 200
//        }
        if (indexPath.section == 1 || indexPath.section == 2){
            return 80
        }
        if (indexPath.section == 4 || indexPath.section == 5 ){
            return 60
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.row == 1 {
//            return 200
//        }
        if (indexPath.section == 1 || indexPath.section == 2 ){
            return 80
        }
        if (indexPath.section == 4 || indexPath.section == 5 ){
            return 60
        }

        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else if section == 3{
            if (obj?.aboutMe) != nil{
                return 2
            }else{
                return 0
            }
        } else if section == 4{
            return ((obj?.workDetails.count)! + 1)
        } else if section == 5{
            return ((obj?.educationDetails.count)! + 1 )
        }
        else{
            return 0
        }
//        if section == 0{
//            return 4
//        }else if section == 1{
//            return ((obj?.workDetails.count)! + 1)
//        }else if section == 2{
//            return ((obj?.educationDetails.count)! + 1 )
//        }else if section == 3{
//            if (obj?.aboutMe) != nil{
//                return 2
//            }else{
//                return 0
//            }
//        }
//        else{
//            return 0
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: UserInfoCell.className, for: indexPath) as! UserInfoCell
            if indexPath.row == 0{
                cell.labelInfo.text = obj?.fullName
                cell.dropImage.isHidden = true
                cell.lblpublic.isHidden = true
                cell.dropbtn.isHidden = true
                cell.leftImage.image = #imageLiteral(resourceName: "profile")
                cell.hideEditButton = false
            }
            else if indexPath.row == 1 {
                cell.labelInfo.text = obj?.livingPlace
                cell.leftImage.image = #imageLiteral(resourceName: "address")
                cell.dropImage.isHidden = false
                cell.dropbtn.isHidden = false
                if(obj?.living_place_privacy == "public".localized){
                    
                     cell.lblpublic.text = "Public".localized
                   
                }
                
                if(obj?.living_place_privacy == "friend".localized){
                    
                       cell.lblpublic.text = "Friends".localized
                  
                }
                
                if(obj?.living_place_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized

                }
                
               
               
                cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon(_:)), for: .touchUpInside)
                cell.hideEditButton = false
            }
            else if indexPath.row == 2{
                cell.labelInfo.text = obj?.email
                cell.leftImage.image = #imageLiteral(resourceName: "email")
                cell.dropImage.isHidden = false
                cell.dropbtn.isHidden = false

                cell.lblpublic.isHidden = false
                 cell.hideEditButton = false
                
                if(obj?.email_privacy == "public".localized){
                    
                    cell.lblpublic.text = "Public".localized
                    
                }
                
                if(obj?.email_privacy == "friend".localized){
                    
                    cell.lblpublic.text = "Friends".localized
                    
                }
                
                if(obj?.email_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized
                    
                }
                
                
                
                cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon22(_:)), for: .touchUpInside)
               
                
                
            }
            else if indexPath.row == 3{
                let bd =  obj?.mobile
                cell.labelInfo.text = bd
                cell.dropImage.isHidden = false
                cell.dropbtn.isHidden = false
                if(obj?.mobile_privacy == "public".localized){
                    
                    cell.lblpublic.text = "Public".localized
                    
                }
                
                if(obj?.mobile_privacy == "friend".localized){
                    
                    cell.lblpublic.text = "Friends".localized
                    
                }
                
                if(obj?.mobile_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized
                    
                }
                
  cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon2(_:)), for: .touchUpInside)
//                cell.labelInfo.text = convertDate(dateString: bd!)
                cell.leftImage.image = #imageLiteral(resourceName: "phone")
                cell.hideEditButton = false
            }
            
            cell.delegate = self as editUserInformation
            return cell
        }
        else if indexPath.section == 1
        {
            let cellBirthday = tableView.dequeueReusableCell(withIdentifier: EditBirthdayAndGenderInformationCell.className, for: indexPath) as! EditBirthdayAndGenderInformationCell
            let birthday = convertDate(dateString: (obj?.birthday.toDouble)!)
            cellBirthday.lblBirthday.text = birthday
            cellBirthday.lbl_birthday.text = "Birthday".localized
            cellBirthday.lbl_Gender.text = "Gender".localized
            cellBirthday.btnBirthday.addTarget(self, action: #selector(self.btnBirthday(_:)), for: .touchUpInside)
            cellBirthday.delegate = self
            cellBirthday.lbl_Male.text = "Male".localized
            cellBirthday.lbl_Female.text = "Female".localized
            //cellBirthday.btn_Male.setTitle(, for: .normal)
            //cellBirthday.btn_Female.setTitle("Female".localized, for: .normal)
            
            let gender = obj?.gender.localized
            if (gender == "male".localized) {
                cellBirthday.setMale()
                
            } else {
                cellBirthday.setFemale()
                
            }
          
            if(obj?.dob_privacy == "public".localized){
                
                cellBirthday.lblpublic.text = "Public".localized
                
            }
            
            if(obj?.dob_privacy == "friend".localized){
                
                cellBirthday.lblpublic.text = "Friends".localized
                
            }
            
            if(obj?.dob_privacy == "only_me".localized){
                
                cellBirthday.lblpublic.text = "Only Me".localized
                
            }

            cellBirthday.dropbtn.addTarget(self, action: #selector(self.btnDropdwon3(_:)), for: .touchUpInside)

            return cellBirthday
        }
        else if indexPath.section == 2{
            let cellBirthday = tableView.dequeueReusableCell(withIdentifier: EditRelationshipInformationCell.className, for: indexPath) as! EditRelationshipInformationCell
            let realtion = obj?.relationship.localized
            cellBirthday.btnRelationship.setTitle(realtion, for: .normal)
            cellBirthday.btnRelationship.addTarget(self, action: #selector(self.btnRelationship(_:)), for: .touchUpInside)
             cellBirthday.dropbtn.addTarget(self, action: #selector(self.btnDropdwon4(_:)), for: .touchUpInside)
        
            cellBirthday.relationship_Status.text! = "Relationship Status".localized
//            cellBirthday.lblpublic.text = obj?.relationship_privacy
//            self.privacy = "relationship_privacy"
            
            
            if(obj?.relationship_privacy == "public".localized){
                
                cellBirthday.lblpublic.text = "Public".localized
                
            }
            
            if(obj?.relationship_privacy == "friend".localized){
                
                cellBirthday.lblpublic.text = "Friends".localized
                
            }
            
            if(obj?.relationship_privacy == "only_me".localized){
                
                cellBirthday.lblpublic.text = "Only Me".localized
                
            }

            return cellBirthday
        }
        else if indexPath.section == 3{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutEditCell.className, for: indexPath) as! AboutEditCell
                cell.hideEditButton = false
                cell.delegate = self as EditAboutCell
               cell.lbl_About.text! = "About".localized

                if(obj?.about_me_privacy == "public".localized){
                    
                    cell.lblpublic.text = "Public".localized
                    
                }
                
                if(obj?.about_me_privacy == "friend".localized){
                    
                    cell.lblpublic.text = "Friends".localized
                    
                }
                
                if(obj?.about_me_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized
                    
                }
                 cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon5(_:)), for: .touchUpInside)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: AboutDetailCell.className, for: indexPath) as! AboutDetailCell
                cell.labelAbout.text = obj?.aboutMe
                
                return cell
            }
            
        } else if indexPath.section == 4{
            if (obj?.workDetails.count)! > indexPath.row{
                let cell = tableView.dequeueReusableCell(withIdentifier: EditWorkInformationCell.className, for: indexPath) as! EditWorkInformationCell
                cell.labelInfo.text = (obj?.workDetails[indexPath.row].position)! + " at " + (obj?.workDetails[indexPath.row].company)!
                cell.leftImage.image = #imageLiteral(resourceName: "work")
                cell.hideEditButton = false
                cell.delegate = self as editWorkInformation
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: AddInfoCell.className, for: indexPath) as! AddInfoCell
                cell.labelInfo.text = "Add work".localized
                cell.tag = 0
                cell.dropbtn.tag = indexPath.row
                cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon6(_:)), for: .touchUpInside)
               
                
                
                if(obj?.work_privacy == "public".localized){
                    
                    cell.lblpublic.text = "Public".localized
                    
                }
                
                if(obj?.work_privacy == "friend".localized){
                    
                    cell.lblpublic.text = "Friends".localized
                    
                }
                
                if(obj?.work_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized
                    
                }

                cell.delegate = self
                
                
                return cell
            }

        } else if indexPath.section == 5{
            if (obj?.educationDetails.count)! > indexPath.row{
                let cell = tableView.dequeueReusableCell(withIdentifier: EditEducationInformationCell.className, for: indexPath) as! EditEducationInformationCell
                cell.labelInfo.text = "Studied " + (obj?.educationDetails[indexPath.row].degree)! + " at " + (obj?.educationDetails[indexPath.row].school)!
                cell.leftImage.image = #imageLiteral(resourceName: "education")
                cell.hideEditButton = false
                cell.delegate = self as EditEducationInformation
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: AddInfoCell.className, for: indexPath) as! AddInfoCell
                cell.delegate = self
                cell.tag = 1
                cell.dropbtn.tag = indexPath.row
                cell.labelInfo.text = "Add education".localized
               
                
                if(obj?.education_privacy == "public".localized){
                    
                    cell.lblpublic.text = "Public".localized
                    
                }
                
                if(obj?.education_privacy == "friend".localized){
                    
                    cell.lblpublic.text = "Friends".localized
                    
                }
                
                if(obj?.education_privacy == "only_me".localized){
                    
                    cell.lblpublic.text = "Only Me".localized
                    
                }

                  cell.dropbtn.addTarget(self, action: #selector(self.btnDropdwon7(_:)), for: .touchUpInside)
                return cell
            }

            
        }
        
        return UITableViewCell()
    }
    // this method handles row deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 1{
            return true
            
        }else if indexPath.section == 2{
            return true
            
        }else{
            return false
        }
    }
    private func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1{
            if editingStyle == .delete {
                
                
                self.deleteWorkInformation(workId:String(describing: (obj?.workDetails[indexPath.row].id)!), indexId: indexPath.row,indexPathid: indexPath)
            }
        }else if  indexPath.section == 2{
            if editingStyle == .delete {
                self.deleteEducationInformation(educationId:String(describing: (obj?.educationDetails[indexPath.row].id)!), indexId: indexPath.row,indexPathid: indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        if indexPath.section == 1{
            return "Delete".localized
            
        }else if indexPath.section == 2{
            return "Delete".localized
        }
        else{
              return ""
        }
      
    }
    
}

extension EditProfileViewController: AddInfoCellDelegate {
    
    func didSelectAddInfoCell(_ tag: Int) {
        if tag ==  0
        {
            segueTo(controller: .addWorkController)
        }
        else if tag == 1
        {
            segueTo(controller: .addEducationController)
        }
        
    }
}
// MARK:- Edit UserInformation Cell Delegate Extension
extension EditProfileViewController: editUserInformation {
    func sendUserOtherInformationCell(cell: UserInfoOtherCell) {
        
    }
    
    func btnMaleClick() {
        self.addUserInfo(index: 4, text:"male".localized)
    }
    func btnFemaleClick() {
        self.addUserInfo(index: 4, text:"female".localized)
    }
    
    func sendUserInformationCell(cell: UserInfoCell) {
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        if item!.item == 0{
            editUserInformation(title:"Update User Information".localized,message:"Please edit username and then save it".localized,placeholder:"Enter username".localized,textThatHasToBeEdit:(obj?.fullName)!.localized, index:0)
        } else if item!.item == 1{
            editUserInformation(title:"Update User Information".localized,message:"Please edit location and then save it".localized,placeholder:"Enter location".localized,textThatHasToBeEdit:(obj?.livingPlace)!, index:1)
        } else if item!.item == 2{
            
           editUserInformation(title:"Update User Information".localized,message:"Please Edit email and then save it".localized,placeholder:"Enter location".localized,textThatHasToBeEdit:(obj?.email)!, index:2)
        } else if item!.item == 3{
            //self.datePickerFromWork()
             editUserInformation(title:"Update User Information".localized,message:"Please edit phone number and then save it".localized,placeholder:"Enter phone".localized,textThatHasToBeEdit:(obj?.mobile)!.localized, index:2)
        }
    }
}
// MARK:- Edit UserInformation Cell Delegate Extension
extension EditProfileViewController: EditAboutCell {
    func didSelecteditAboutCell(Cell: Int) {
        editUserInformation(title:"Update User Information".localized,message:"Please edit about and then save it".localized,placeholder:"Enter about you".localized,textThatHasToBeEdit:(obj?.aboutMe)!, index:Cell)
    }
}
// MARK:- Edit WorkInformation Cell Delegate Extension
extension EditProfileViewController: editWorkInformation {
    func sendWorkInformationCell(cell: EditWorkInformationCell) {
        
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddWorkController") as! AddWorkController
        controller.company = (obj?.workDetails[item!.item].company)!
        controller.postion = (obj?.workDetails[item!.item].position)!
        controller.city = (obj?.workDetails[item!.item].city)!
        controller.date_from = (obj?.workDetails[item!.item].dateFrom.toDouble)!
        controller.date_to = (obj?.workDetails[item!.item].dateTo.toDouble)!
        controller.workDescription = (obj?.workDetails[item!.item].descriptionField)!
        controller.workId = String(describing: (obj?.workDetails[item!.item].id)!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
// MARK:- Edit EducationInformation Cell Delegate Extension
extension EditProfileViewController: EditEducationInformation {
    func sendEducationInformationCell(cell: EditEducationInformationCell) {
        let item = tableView.indexPath(for: cell)
        print(item!.item)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddEducationController") as! AddEducationController
        controller.institute = (obj?.educationDetails[item!.item].school)!
        controller.degreeTitle = (obj?.educationDetails[item!.item].degree)!
        controller.FromDate = (obj?.educationDetails[item!.item].dateFrom)!
        controller.TToDate = (obj?.educationDetails[item!.item].dateTo)!
        controller.educationId = String(describing: (obj?.educationDetails[item!.item].id)!)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

protocol EditControllerCell { }

// MARK: - Video Delegates - Protocols
@objc protocol editUserInformation {
    
    func sendUserInformationCell(cell: UserInfoCell)
    func sendUserOtherInformationCell(cell: UserInfoOtherCell)
    @objc optional func btnMaleClick()
    @objc optional func btnFemaleClick()
}

extension EditControllerCell where Self: UITableViewCell { }

// MARK: - User Information Cell
class UserInfoCell: UITableViewCell, EditControllerCell {
    
    var delegate:editUserInformation!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropbtn: UIButton!

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var labelInfo: UILabel!
    
    @IBOutlet var buttonEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
        delegate?.sendUserInformationCell(cell: self)
    }
    
    var hideEditButton: Bool {
        set (hide) {
            buttonEdit.isHidden = hide
        }
        get {
            return buttonEdit.isHidden
        }
    }
}

class UserInfoOtherCell: UITableViewCell, EditControllerCell {
    
    var delegate:editUserInformation!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropbtn: UIButton!

    @IBOutlet var labelHeading: UILabel!
    @IBOutlet var labelInfo: UILabel!
    
    @IBOutlet var buttonEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
        delegate?.sendUserOtherInformationCell(cell: self)
    }
    
    var hideEditButton: Bool {
        set (hide) {
            buttonEdit.isHidden = hide
        }
        get {
            return buttonEdit.isHidden
        }
    }
}


protocol editWorkInformation {
    
    func sendWorkInformationCell(cell: EditWorkInformationCell)
}


// MARK: - Edit Work Information Cell
class EditWorkInformationCell: UITableViewCell {
    
    var delegate:editWorkInformation!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropbtn: UIButton!

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var labelInfo: UILabel!
    @IBOutlet var buttonEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
        
        delegate?.sendWorkInformationCell(cell: self)
        
    }
    
    var hideEditButton: Bool {
        set (hide) {
            buttonEdit.isHidden = hide
        }
        get {
            return buttonEdit.isHidden
        }
    }
}

protocol EditEducationInformation {
    
    func sendEducationInformationCell(cell: EditEducationInformationCell)
}


// MARK: - Edit Education Information Cell
class EditEducationInformationCell: UITableViewCell {
    
    var delegate:EditEducationInformation!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropbtn: UIButton!

    @IBOutlet var leftImage: UIImageView!
    @IBOutlet var labelInfo: UILabel!
    @IBOutlet var buttonEdit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
        delegate?.sendEducationInformationCell(cell: self)
    }
    
    var hideEditButton: Bool {
        set (hide) {
            buttonEdit.isHidden = hide
        }
        get {
            return buttonEdit.isHidden
        }
    }
}

class EditBirthdayAndGenderInformationCell: UITableViewCell {
    
    @IBOutlet var lbl_birthday: UILabel!
    var delegate:editUserInformation!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropImage: UIImageView!
    @IBOutlet var dropbtn: UIButton!

    @IBOutlet var lbl_Male: UILabel!
    @IBOutlet var lbl_Female: UILabel!
    @IBOutlet var lbl_Gender: UILabel!
    @IBOutlet var btn_Female: UIButton!
    @IBOutlet var btn_Male: UIButton!
    @IBOutlet var lblBirthday: UILabel!
    @IBOutlet var btnBirthday: UIButton!
    @IBOutlet var btnMale: CheckBox!{
        didSet {
            btnMale.isChecked = true
        }
    }
    @IBOutlet var btnFemale: CheckBox!{
        didSet {
            btnFemale.isChecked = false
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
//        delegate?.sendEducationInformationCell(cell: self)
    }
    
    func setMale() {
        btnMale.isChecked = true
        btnFemale.isChecked = false
        btnMale.setImage(UIImage(named: "selected-radio"), for: .normal)
        btnFemale.setImage(UIImage(named: "radio"), for: .normal)
        
        
    }
    
    func setFemale() {
        btnMale.isChecked = false
        btnFemale.isChecked = true
        btnMale.setImage(UIImage(named: "radio"), for: .normal)
        btnFemale.setImage(UIImage(named: "selected-radio"), for: .normal)
    }
    
    @IBAction func btnMale(_ sender: Any) {
        setMale()
//        delegate?.sendEducationInformationCell(cell: self)
        delegate?.btnMaleClick!()
    }
    
    @IBAction func btnFemale(_ sender: Any) {
        setFemale()
        delegate?.btnFemaleClick!()
        
    }
}

class EditRelationshipInformationCell: UITableViewCell {
    
    @IBOutlet var relationship_Status: UILabel!
    var delegate:EditEducationInformation!
    @IBOutlet var btnRelationship: UIButton!
    @IBOutlet var lblpublic: UILabel!
    @IBOutlet var dropbtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    @IBAction func buttonEditAction(_ sender: UIButton) {
        //        delegate?.sendEducationInformationCell(cell: self)
    }
    
//    var hideEditButton: Bool {
//        set (hide) {
////            buttonEdit.isHidden = hide
//        }
//        get {
////            return buttonEdit.isHidden
//        }
//    }
}


protocol AddInfoCellDelegate {
    func didSelectAddInfoCell(_ tag: Int)
}

class AddInfoCell: UITableViewCell {
    
    var delegate: AddInfoCellDelegate?
    @IBOutlet var dropbtn: UIButton!
    @IBOutlet var lblpublic: UILabel!

    @IBOutlet var buttonAdd: UIButton!
    
    @IBOutlet var labelInfo: UILabel!
    
    @IBAction func onButtonAddInfoClicked(_ sender: UIButton) {
        delegate?.didSelectAddInfoCell(self.tag)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}


protocol EditAboutCell {
    func didSelecteditAboutCell(Cell: Int)
}
class AboutEditCell: UITableViewCell, EditControllerCell {
    
    var delegate: EditAboutCell?
    @IBOutlet var dropbtn: UIButton!
    @IBOutlet var lblpublic: UILabel!

    @IBOutlet var lbl_About: UILabel!
    @IBOutlet var aboutBtn: UIButton!
    @IBOutlet var aboutHeader: UILabel!
    @IBOutlet var buttonRight: UIButton!
    
    var hideEditButton: Bool {
        set (hide) {
            buttonRight.isHidden = hide
        }
        get {
            return buttonRight.isHidden
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //aboutHeader.text = "About".localized
        selectionStyle = .none
    }
    @IBAction func onButtonEditAboutInfoClick(_ sender: Any) {
        delegate?.didSelecteditAboutCell(Cell: 6)
    }
}

class AboutDetailCell: UITableViewCell, EditControllerCell {
    
    @IBOutlet var labelAbout: UILabel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        //labelAbout.text = "About".localized
        //labelAbout.text = "About new"
        selectionStyle = .none
    }
}

class DocumentsCell: UITableViewCell, EditControllerCell {
    
    @IBOutlet var documentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
class SavedStoriesCell: UITableViewCell, EditControllerCell {
    
    @IBOutlet var savedStoriesLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
}
