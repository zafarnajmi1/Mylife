//
//  ActivityLogViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 11/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Contacts
import DropDown
import NVActivityIndicatorView


extension SegueIdentifiable {
    static var activityLogController : SegueIdentifier {
        return SegueIdentifier(rawValue: ActivityLogViewController.className)
    }
}

class ActivityLogViewController:  UIViewController, NVActivityIndicatorViewable ,UITableViewDataSource, UITableViewDelegate {
    
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet var lblContactsNotFound: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnMore: UIButton!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    let dropDown = DropDown()
    
    let selectedImage : UIImage? = UIImage(named: "SelectedCheckbox")
    let unSelectedImage : UIImage? = UIImage(named: "Checkbox")

    let activities = ModelGenerator.generateActivityModel()
    var store = CNContactStore()
    var dataSource : [Contactdata] = []
    var duplicateArray = [Contactdata]()
    var filteredArray = [Contactdata]()
    var ind = 0
    
    var contactsArray = [Contactdata]()
    var selectedContactsArray = [Contactdata]()

   // var manager:SocketManager!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        filteredArray.removeAll()
        duplicateArray.removeAll()
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        self.title = "Contacts".localized
        addBackButton()
//        self.getContacts()
        btnDelete.isHidden = true
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filteredArray.removeAll()
        
        duplicateArray.removeAll()
        //apiCall()
        addValuesToDataSource()
        
       //self.view.layoutIfNeeded()
        
//        let indexPath : IndexPath = IndexPath(row: sender.tag, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
       // tableView.reloadRows(at: [IndexPath], with: .automatic)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        duplicateArray.removeAll()
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addValuesToDataSource()
    {
        self.btnDelete.isHidden = true
       
        //guard let contacts = UserHandler.sharedInstance.userData?.contactsArray else {return}
        
        
        for cnt in Shared.sharedInfo.contacts {

            for (index,con) in dataSource.enumerated() {

                if con.fullName == cnt.fullName  {
                    if(Shared.sharedInfo.contactFlag == "true"){
                    duplicateArray.append(dataSource[index])
                        
                    }
                    else{
                        duplicateArray.removeAll()

                    }
                    //Shared.sharedInfo.contacts.remove(at: index)
                }
                else{
                   // self.tableView.reloadData()
                }
                
                
                
            }




        }
        
        ind = duplicateArray.count
        //filteredArray = duplicateArray
        
        
        UpdateDuplicateNum()
        
       
        
        //print(duplicateArray.count)
        
//        for id in (Shared.sharedInfo.userSocialModel?.data?.subscribedLeague)! {
//            for (index,Id) in self.leaguesArray.enumerated() {
//                if Id._id == id {
//                    self.filterLeague.append(self.leaguesArray[index])
//                }
//            }
//        }
        
        
        
        
        
    }
    
    func apiCall () {
        
        if let _contacts = UserHandler.sharedInstance.userData?.contacts
        {
            if (_contacts.count == 0) {
                //lblContactsNotFound.isHidden = false
            } else {
                dataSource = []
                // lblContactsNotFound.isHidden = true
                
                print(_contacts)
                
                for object in _contacts {
                    let dict : NSDictionary = object as! NSDictionary
                    var contact : Contactdata = Contactdata()
                    contact.fullName =  dict.value(forKey: "name") as! String
                    contact.phoneNumber =  dict.value(forKey: "number") as! String
                    // contact.firstName = dict.value(forKey: "fname") as! String
                    //  contact.lastName = dict.value(forKey: "lname") as! String
                    
                    print(contact.fullName)
                    print(contact.phoneNumber)
                    print(contact.firstName)
                    print(contact.lastName)
                    
                    
                    dataSource.append(contact)
                }
                dataSource.append(contentsOf: filteredArray)
                if filteredArray.count == 0  {
                   tableView.reloadData()
                }
                else {
                    importContactsService(dataSource)
                }
                
                
                
                
                
            }
        } else {
            //            dataSource = []
                   //  tableView.reloadData()
        }
    }
    
    
    func importContactsService(_ contactsArray : [Contactdata])
    {
        print(contactsArray)
        self.showLoader()
        
        var parameters = [String: Any]()
        var contacts : [[String: Any]] = []
        
        //        for d in self.dataSource
        //        {
        //            flag = true
        //            for cnt in contactsArray
        //            {
        //                if d.fullName == cnt.fullName // replace previous
        //                {
        //                    var dict = [String: Any]()
        //                    dict["name"] = cnt.fullName
        //                    dict["number"] = cnt.phoneNumber
        //                    dict["isChecked"] = false
        //                    contacts.append(dict)
        //                }
        //            }
        //        }
        //
        //        for d in self.dataSource
        //        {
        //            flag = true
        //            for cnt in contactsArray
        //            {
        //                if cnt.fullName != d.fullName // replace previous
        //                {
        //                    var dict = [String: Any]()
        //                    dict["name"] = cnt.fullName
        //                    dict["number"] = cnt.phoneNumber
        //                    dict["isChecked"] = false
        //                    contacts.append(dict)
        //                }
        //            }
        //        }
        
        
        for d in self.dataSource
        {
            var dict = [String: Any]()
            dict["name"] = d.fullName!
            dict["number"] = d.phoneNumber!
            dict["isChecked"] = false
            contacts.append(dict)
        }
        
        print(self.contactsArray.count)
        
        
        
        for cnt in contactsArray
        {
            if(self.dataSource.count > 0)
            {
                var flag = false
                
                for d in self.dataSource
                {
                    if (cnt.fullName! == d.fullName!)
                    {
                        flag = true
                    }
                }
                
                if flag == false
                {
                    print("cnt \(cnt.fullName!)")
                    
                    var dict = [String: Any]()
                    dict["name"] = cnt.fullName!
                    dict["number"] = cnt.phoneNumber!
                    dict["isChecked"] = false
                    contacts.append(dict)
                }
                
            }
            else
            {
                var dict = [String: Any]()
                dict["name"] = cnt.fullName!
                dict["number"] = cnt.phoneNumber!
                dict["isChecked"] = false
                contacts.append(dict)
            }
            
        }
        
        
        let stringValue : String? = notPrettyString(from: contacts)
        parameters["contacts"] = stringValue
        print("\(parameters)")
        
        //        if contactsArray.count > 0
        //        {
        //            for data in contactsArray
        //            {
        //                var dict = [String: Any]()
        //                dict["name"] = data.fullName
        //                dict["number"] = data.phoneNumber
        //                dict["isChecked"] = false
        //                print(dict["name"])
        //                contacts.append(dict)
        //
        //
        //            }
        //
        //
        //        }
        
        UserHandler.editUserInfo(params: parameters as NSDictionary , success: { (success) in
            
            self.stopAnimating()
            if(success.statusCode == 200) {
                UserHandler.sharedInstance.userData = success.data
                
                print(success.data!)
                self.tableView.reloadData()
                
                // print(UserHandler.sharedInstance.userData?.contacts.count)
                //                for cnt in (UserHandler.sharedInstance.userData?.contacts)! {
                //                    print(success.data.contacts)
                //                    print(cnt)
                //                }
                
                //                let arr = UserHandler.sharedInstance.userData?.contacts as NSArray?
                //                let arr2 = success.data.contacts as NSArray?
                //
                //                print(arr![0])
                //                print(arr2!)
                
                //let output = arr?.filter((arr2?.contains{$0})!)
                //let output = arr?.filter{ (arr2?.contains($0))! }
                //print(output!)
                //let cntArray = UserHandler.sharedInstance.userData?.contacts! as! NSArray
                
                //let output = UserHandler.sharedInstance.userData?.contacts.filter(success.data.contacts.contains)
                
                //let arr1 = Set(arr)
                
                
                //                let commonElements: Array = Set<Array>(arr!).filter(Set(arr2!).contains)
                //                //let commonElements = Set(arr!).intersection(Set(arr2!))
                //                print("some")
                //
                //             //let output = fruitsArray.filter(vegArray.contains)
                //                    UserHandler.sharedInstance.userData = success.data
                
                let actionSheet: UIAlertController = UIAlertController(title: "Alert".localized, message: "Contacts are imported successfully".localized, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok".localized, style: .default)
                { _ in
                    //self.navigationController?.popViewController(animated: true)
                    //self.dismiss(animated: true, completion: nil)
                    
                }
                actionSheet.addAction(action)
                self.present(actionSheet, animated: true, completion: nil)
                
            }
            else{
                //                self.stopAnimating()
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
    
    func UpdateDuplicateNum() {
        
        
        if duplicateArray.count == 0 {
            
            
            apiCall()
            
            //self.importContactsService(self.dataSource)
             // tableView.reloadData()
            
//            print(selectedContacts.count)
//            print(filterArray.count)
//
//            if filterArray.count == 0 {
//                let errorAlert = UIAlertController(title: "Alert".localized, message: "Contacts Exports Successfully".localized, preferredStyle: .alert)
//                errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
//                    alert -> Void in
//                    //self.dismissVC(completion: nil)
//                    self.navigationController?.popViewController(animated: true)
//                }))
//                self.present(errorAlert, animated: true, completion: nil)
//            }
//            else {
//                for index in 0..<filterArray.count {
//                    let contact = CNMutableContact()
//
//                    contact.givenName = filterArray[index].fullName
//
//                    contact.phoneNumbers = [CNLabeledValue(
//                        label:CNLabelPhoneNumberiPhone,
//                        value:CNPhoneNumber(stringValue: filterArray[index].phoneNumber))]
//
//                    // Saving the newly created contact
//                    let store = CNContactStore()
//                    let saveRequest = CNSaveRequest()
//                    saveRequest.add(contact, toContainerWithIdentifier:nil)
//                    try! store.execute(saveRequest)
//
//                    let errorAlert = UIAlertController(title: "Alert".localized, message: "Contacts Exports Successfully".localized, preferredStyle: .alert)
//                    errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
//                        alert -> Void in
//                        //self.dismissVC(completion: nil)
//                        self.navigationController?.popViewController(animated: true)
//                    }))
//                    self.present(errorAlert, animated: true, completion: nil)
//                }
//
//
//
//            }
//
//        }
        }
        else {
            
            
            
            
            print(duplicateArray.count)
            
            
            for (index,cnt) in duplicateArray.enumerated() {
                
                
                
                let actionSheet: UIAlertController = UIAlertController(title: "Duplicate Contact Found".localized, message: "Following contact also exist on your device \(cnt.phoneNumber!) Do you want to update this contact? ", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Ok", style: .default)
                { _ in
                    
                    let alertController = UIAlertController(title: "Name".localized, message: "Please update name".localized, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Save".localized, style: .default, handler: {
                        alert -> Void in
                        let fNameField = alertController.textFields![0] as UITextField
                        if fNameField.text != ""
                        {
                            var newCnt = Contactdata()
                            newCnt.fullName = fNameField.text
                            newCnt.phoneNumber = cnt.phoneNumber
                           // self.filteredArray.append(self.duplicateArray.last!)
                            //self.filteredArray[index].fullName = fNameField.text!
                            //self.filteredArray[self.ind].fullName = fNameField.text!
                            
                            self.filteredArray.insert(newCnt, at: self.filteredArray.endIndex)
                            
                            
                            
//                            var newCnt = Contactdata()
//                            newCnt.fullName = fNameField.text
//                            if self.filteredArray.contains(where: {$0.fullName == newCnt.fullName})
//                            {
//
//                            }
//                            else {
//                                self.filteredArray.insertFirst(newCnt)
//                            }
                            
                          // self.filteredArray[index].fullName = fNameField.text
                            
                           
                            
                           
                            
                           // cnt.fullName = fNameField.text ?? ""
                            
                           // self.duplicateArray[index].fullName = fNameField.text ?? ""
                            
                            //self.duplicateArray.insert(<#T##newElement: Contactdata##Contactdata#>, at: <#T##Int#>)
                            
                            //self.filteredArray.insert(self.filteredArray[index], at: index)
//                            let store = CNContactStore()
//                            let contactToAdd = CNMutableContact()
//                            //contactToAdd.givenName = cnt.fullName!
//
//
//
//
//                            let mobileNumber = CNPhoneNumber(stringValue: (cnt.phoneNumber ?? ""))
//                            let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
//                            contactToAdd.phoneNumbers = [mobileValue]
//                            contactToAdd.givenName = fNameField.text ?? ""
//
//
//                            let saveRequest = CNSaveRequest()
//                            //saveRequest.update(contactToAdd)
//                            saveRequest.add(contactToAdd, toContainerWithIdentifier:nil)
//                            //                    saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
//                            do {
//                                try store.execute(saveRequest)
//                            } catch {
//                                print(error)
//                            }
//
//                            self.duplicateArray.remove(at: index)
//                            //print(duplicateArray.count)
//                            self.UpdateDuplicateNum()
                            //TODO: Save user data in persistent storage - a tutorial for another time
                            
                            
                            self.duplicateArray.remove(at: index)
                            self.UpdateDuplicateNum()
                            
                            
                        }
                            
                            
                        else
                        {
                            let errorAlert = UIAlertController(title: "Error".localized, message: "Please enter phone number".localized, preferredStyle: .alert)
                            errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
                                alert -> Void in
                                self.present(alertController, animated: true, completion: nil)
                            }))
                            self.present(errorAlert, animated: true, completion: nil)
                        }
                       
                        
                    }))
                    
                    alertController.addTextField(configurationHandler: { (textField) -> Void in
                        textField.placeholder = "Name".localized
                        textField.text = cnt.fullName!
                        textField.textAlignment = .center
                    })
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
                let actionCancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
                { _ in
                    // self.btnTick(self.btnTick)
                    //self.ind = 1
                    return
                }
                
                actionSheet.addAction(actionOk)
                actionSheet.addAction(actionCancel)
                self.present(actionSheet, animated: true, completion: nil)
            }
            
            
        }
        
       // print(filteredArray.count)
        
        
        
    }
    
    
    
    
    
    
    
//    func getContacts (){
//        var cnContacts = [CNContact]()
//
//        let requestForContacts = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactPhoneNumbersKey as CNKeyDescriptor ,CNContactImageDataKey as CNKeyDescriptor,CNContactEmailAddressesKey as CNKeyDescriptor,CNContactBirthdayKey as CNKeyDescriptor])
//        do {
//            try self.store.enumerateContacts(with: requestForContacts) { contact, stop in
//                print("contact:\(contact)")
//                cnContacts.append(contact)
//            }
//        } catch {
//            print(error)
//        }
//
//        for contact in cnContacts {
//            print(contact)
//            let firstName = contact.givenName
//            print("first:\(firstName)")
//            let lastName = contact.middleName
//            print(lastName)
//
//            var phoneNumber = ""
//            if contact.phoneNumbers.count > 0{
//                phoneNumber = ((contact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
//            }else{
//                phoneNumber = "Not Available"
//            }
//
//            print(phoneNumber)
//
//            var objContact : Contactdata = Contactdata()
//            objContact.firstName = firstName
//            objContact.lastName = lastName
//            objContact.phoneNumber = phoneNumber
//
//
//
////            let objContact = Contactdata.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
//            contactsArray.append(objContact)
//
////            let emailAddress = contact.emailAddresses[0].value(forKey: "value")
//           // emailAddressArray.append(emailAddress as! String)
//        }
//        if self.contactsArray.count > 0 {
//            //self.tableView.reloadData()
//        }else{
//            let alert = CommonMethods.showBasicAlert(message: "No Contacts found. Please Go to Settings and allow contacts in privacy settings")
//            self.present(alert, animated: true,completion: nil)
//
//        }
//
//        /*
//        store.requestAccess(for: .contacts, completionHandler: {
//            granted, error in
//
//            guard granted else {
//                let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//                return
//            }
//
//            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
//            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
//
//            do {
//                try self.store.enumerateContacts(with: request){
//                    (contact, cursor) -> Void in
//                    self.cnContacts.append(contact)
//                }
//                self.tableView.reloadData()
//            } catch let error {
//                NSLog("Fetch contact error: \(error)")
//            }
//
//            /*
//            NSLog(">>>> Contact list:")
//            for contact in self.cnContacts {
//                let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
//                NSLog("\(fullName): \(contact.phoneNumbers.description)")
//            }*/
//        })
//        */
//    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        let result : [Contactdata] = dataSource.filter { (_ data : Contactdata) -> Bool in
            if (data.isSelected == false) {
                
                return true
            }
            return false
        }
        
       // let result2 : [Contactdata] = [dataSource.remove(at: sender.tag)]
        deleteContactsService(result)
        tableView.reloadData()
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
        
        dropDown.localizationKeysDataSource = ["Import Contacts".localized,"Export Contacts".localized]
        dropDown.anchorView = self.navBar
       // dropDown.left = 10.0
        //dropDown.width = 300
        dropDown.direction = .any
        //dropDown.layoutSubviews()
        //dropDown.dataSource = ["Import Contacts".localized,"Export Contacts".localized]
        dropDown.show()
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if index == 0{
                Shared.sharedInfo.contactFlag = "true"
                self.showImportViewController()
            }
            else
            {
                Shared.sharedInfo.contactFlag = "false"

                self.showExportViewController()
            }
        }
    }
    
    
    
    func showImportViewController()
    {
        let controller = UIStoryboard.mainStoryboard.instantiateVC(ImportContactsViewController.self)!
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.dataSource = self.dataSource
        
        print(self.dataSource.count)
        for cn in self.dataSource {
            print(cn.fullName)
        }
        controller.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
       self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showExportViewController()
    {
        let controller = UIStoryboard.mainStoryboard.instantiateVC(ExportViewController.self)!
        controller.isMotionEnabled = true
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: .pageIn(direction: .up), dismissing: .pageOut(direction: .down))
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func notPrettyString(from object: Any) -> String? {
        if let objectData = try? JSONSerialization.data(withJSONObject: object, options: JSONSerialization.WritingOptions(rawValue: 0)) {
            let objectString = String(data: objectData, encoding: .utf8)
            return objectString
        }
        return nil
    }
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    @objc func btnContactDidSelect(_ sender : UIButton) {
        self.dataSource[sender.tag].isSelected = !self.dataSource[sender.tag].isSelected
        let result = dataSource.filter({ (_data : Contactdata) -> Bool in
            return _data.isSelected
        })
        
        if (result.count > 0) {
            btnDelete.tag = sender.tag
            btnDelete.isHidden = false
        } else {
            btnDelete.tag = sender.tag
            btnDelete.isHidden = true
        }
        let indexPath : IndexPath = IndexPath(row: sender.tag, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)

    }
    
    func deleteContactsService(_ contactsArray : [Contactdata])
    {
        self.showLoader()
        var parameters = [String: Any]()
        var contacts : [[String: Any]] = []
        
        if contactsArray.count > 0 {
            for data in contactsArray {
                
                var dict = [String: Any]()
                dict["name"] = data.fullName
                dict["fname"] = data.firstName
                dict["lname"] = data.lastName
                dict["number"] = data.phoneNumber
                dict["isChecked"] = false
                contacts.append(dict)
            }
            
            let stringValue : String? = notPrettyString(from: contacts)
            parameters["contacts"] = stringValue
            print("\(parameters)")
        }else{
            parameters["contacts"] = "[]"
           
            print("\(parameters)")
        }

        UserHandler.editUserInfo(params: parameters as NSDictionary , success: { (success) in

            self.stopAnimating()
            if(success.statusCode == 200) {
                UserHandler.sharedInstance.userData = success.data
                self.dataSource.removeAll()
                self.addValuesToDataSource()
                self.tableView.reloadData()
//                self.obj?.fullName = success.data.fullName
//                self.obj?.birthday = success.data.birthday
//                self.obj?.mobile = success.data.mobile
//                self.obj?.aboutMe = success.data.aboutMe
//                UserHandler.sharedInstance.userData = self.obj
//                self.tableView.reloadData()
//                self.stopAnimating()
            }
            else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: { 
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

    // MARK: - UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No Contacts Found".localized
            noDataLabel.textColor     = UIColor.darkGray //(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            
            
            tableView.backgroundView  = noDataLabel
            
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 220, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
            return 0
        }else{
            tableView.backgroundView = nil
            return 1
        }
        
//        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLogTableViewCell.className, for: indexPath) as! ActivityLogTableViewCell
        
        
        //let activity = activities[indexPath.row]
//        let contact = self.contactsArray[indexPath.row]
        let contact = dataSource[indexPath.row]

        //cell.btnSelect.isHidden = true
        cell.btnSelect.setBackgroundImage(unSelectedImage, for: .normal)
//        cell.labelNotification.text = contact.firstName + " " + contact.lastName//activity.activity
        cell.labelNotification.text = contact.fullName
        cell.labelTime.text = contact.phoneNumber//activity.time.toString()
        cell.imageViewProfile.image = #imageLiteral(resourceName: "user")
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(self.btnContactDidSelect(_:)), for: .touchUpInside)
        if (contact.isSelected) {
            cell.btnSelect.setBackgroundImage(selectedImage, for: .normal)
//            cell.accessoryType = .checkmark
        } else {
            cell.btnSelect.setBackgroundImage(unSelectedImage, for: .normal)
//            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
    }
}

class ActivityLogTableViewCell: UITableViewCell {
    
    
    
    
        override func layoutSubviews() {
            super.layoutSubviews()
            layoutIfNeeded()
        super.layoutSubviews()
    
        }
    @IBOutlet var imageViewProfile: UIImageView! {
        didSet {
            //imageViewProfile.roundWithClear()
        }
    }
    
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet var labelNotification: UILabel!
    
    @IBOutlet var labelTime: UILabel!
    
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
         layoutSubviews()
        selectionStyle = .none
    }
}



struct ActivityLogModel {
    var activity: String
    var time: Date
}


