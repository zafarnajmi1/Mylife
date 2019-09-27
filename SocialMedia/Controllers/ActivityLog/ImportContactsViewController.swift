//
//  ImportContactsViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 19/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Contacts
import NVActivityIndicatorView

extension SegueIdentifiable {
    static var importController : SegueIdentifier {
        return SegueIdentifier(rawValue: ImportContactsViewController.className)
    }
}


class ImportContactsViewController: UIViewController, NVActivityIndicatorViewable ,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet var btnTick: UIButton!
    var isAllSelected : Bool = false
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var dataSource : [Contactdata] = []
    
    let activities = ModelGenerator.generateActivityModel()
    var store = CNContactStore()
    
    var contactsArray = [Contactdata]()
    var contactsArray2 = [Contactdata]()
    var selectedContactsArray = [Contactdata]()
    var idArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.reloadData()
        self.title = "Import Contacts".localized
        btnSelectAll.setTitle("Select All".localized, for: .normal)
        addBackButton2()
        self.getContacts()
        
    }
    func addBackButton2(backImage: UIImage = #imageLiteral(resourceName: "back")) {
        hideBackButton()
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        var Arback = #imageLiteral(resourceName: "Ar-back")
        if lang == "ar" {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            tableView.semanticContentAttribute = .forceRightToLeft

             self.tableView.reloadData()
            let backButton = UIBarButtonItem(image: Arback, style: .plain, target: self, action: #selector(onBackButtonClciked2))
            navigationItem.leftBarButtonItem  = backButton
        }
        else {
            tableView.semanticContentAttribute = .forceLeftToRight
            let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(onBackButtonClciked2))
            navigationItem.leftBarButtonItem  = backButton
        }
        
        
        
    }
    
    @objc  func onBackButtonClciked2() {
        
        Shared.sharedInfo.contactFlag = "false"
        navigationController?.popViewController(animated: true)
        dismissVC(completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // Shared.sharedInfo.contacts.removeAll()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func getContacts (){
        
        var cnContacts = [CNContact]()
        
        let requestForContacts = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactPhoneNumbersKey as CNKeyDescriptor ,CNContactImageDataKey as CNKeyDescriptor,CNContactEmailAddressesKey as CNKeyDescriptor,CNContactBirthdayKey as CNKeyDescriptor])
        do {
            try self.store.enumerateContacts(with: requestForContacts) { contact, stop in
                print("contact:\(contact)")
                 cnContacts.append(contact)
               
                
            }
        } catch {
            print(error)
        }
      //  var i = -1
        
        for contact in cnContacts {
            print(contact)
            let firstName = contact.givenName
            print("first:\(firstName)")
            let lastName = contact.familyName
            print(lastName)
          //  i += 1
            var phoneNumber = ""
            if contact.phoneNumbers.count > 0{
                phoneNumber = ((contact.phoneNumbers[0].value).value(forKey: "digits") as? String)!
            }else{
                phoneNumber = "Not Available"
            }
            
            print(phoneNumber)
            
            var objContact : Contactdata = Contactdata()
            objContact.firstName = firstName
            objContact.lastName = lastName
//            objContact.fullName = "\(firstName)\(lastName)"
            objContact.fullName = firstName + " " + lastName
            objContact.phoneNumber = phoneNumber
            objContact.isSelected = false
            contactsArray.append(objContact)
            
//            for cn in self.dataSource {
//
//                print(objContact.fullName!)
//                print(cn.fullName!)
//
//                if objContact.fullName == cn.fullName! {
//                    contactsArray.remove(at: i)
//                    i -= 1
//                    //return
//                }
//                else {
//                   // return
//                    //contactsArray.append(objContact)
//                    //contactsArray.remove(at: i)
//                }
//            }
            
            //            let objContact = Contactdata.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            
            
            //            let emailAddress = contact.emailAddresses[0].value(forKey: "value")
            // emailAddressArray.append(emailAddress as! String)
        }
        
//        for (index,cn) in contactsArray.enumerated() {
//            print(index)
//        }
        
       
       
        
        for i in 0..<contactsArray.count {
                        for cn in self.dataSource {
            
                            //print(contactsArray[i].fullName)
                           // print(cn.fullName!)
            
                            if contactsArray[i].fullName == cn.fullName! {
                                idArray.append(i)
                            }
                            else {
                               // return
                                //contactsArray.append(objContact)
                                //contactsArray.remove(at: i)
                            }
                        }
        }
        
       
        print(idArray)
//        var numRemoved: Int = 0
//        for index in idArray {
//            let indexToRemove = index - numRemoved
//            self.contactsArray.remove(at: indexToRemove)
//            numRemoved += 1
//        }
        
         //self.contactsArray.remove(at:[0, 1, 2, 3, 4, 5, 6])
//        for (index,id) in idArray.enumerated() {
//          self.contactsArray.remove(at: index)
//        }
        
        if self.contactsArray.count > 0 {
            self.tableView.reloadData()
        }else
        {
            let alert = CommonMethods.showBasicAlert(message: "No Contact found. Please Go to Settings and allow contacts in privacy settings".localized)
            self.present(alert, animated: true,completion: nil)
            
        }
        
        /*
         store.requestAccess(for: .contacts, completionHandler: {
         granted, error in
         
         guard granted else {
         let alert = UIAlertController(title: "Can't access contact", message: "Please go to Settings -> MyApp to enable contact permission", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alert, animated: true, completion: nil)
         return
         }
         
         let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
         let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
         
         do {
         try self.store.enumerateContacts(with: request){
         (contact, cursor) -> Void in
         self.cnContacts.append(contact)
         }
         self.tableView.reloadData()
         } catch let error {
         NSLog("Fetch contact error: \(error)")
         }
         
         /*
         NSLog(">>>> Contact list:")
         for contact in self.cnContacts {
         let fullName = CNContactFormatter.string(from: contact, style: .fullName) ?? "No Name"
         NSLog("\(fullName): \(contact.phoneNumbers.description)")
         }*/
         })
         */
    }
    
    @IBAction func btnTick(_ sender: UIButton)
    {
        let result = contactsArray.filter { (_data : Contactdata) -> Bool in
            return _data.isSelected
        }
        
        Shared.sharedInfo.contacts.removeAll()
        Shared.sharedInfo.contacts = result
        
        print(Shared.sharedInfo.contacts.count)
        print(result.count)
        
        if (result.count == 0)
        {
            
            
            let actionSheet: UIAlertController = UIAlertController(title: "Alert".localized, message: "No account select for import".localized, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok".localized, style: .default)
            { _ in
                self.navigationController?.popViewController(animated: true)
            }
            actionSheet.addAction(action)
            self.present(actionSheet, animated: true, completion: nil)
            return
        }
        else {
            //self.navigationController?.popViewController(animated: true)
        }
        
        importContactsService(result)
        print(result)
        
    }
    
    @IBAction func btnSelectAll(_ sender: Any) {
        isAllSelected = !isAllSelected
        let text : String = (isAllSelected == true) ? "UnSelect All".localized : "Select All".localized
        btnSelectAll.setTitle(text, for: .normal)
        for index in 0..<contactsArray.count {
            contactsArray[index].isSelected = isAllSelected
        }
        tableView.reloadData()
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
                self.navigationController?.popViewController(animated: true)
                //print(success.data!)
                
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
                
//                    let actionSheet: UIAlertController = UIAlertController(title: "Alert".localized, message: "Contacts is moving", preferredStyle: .alert)
//                    let action = UIAlertAction(title: "Ok".localized, style: .default)
//                    { _ in
//
//                    }
//                    actionSheet.addAction(action)
//                    self.present(actionSheet, animated: true, completion: nil)
                
            }
            else{
                                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: nil)
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
        
        if contactsArray.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No Contacts Found".localized
            noDataLabel.textColor     = UIColor.darkGray //(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            
            
            tableView.backgroundView  = noDataLabel
            
            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 190, width: 70, height: 70))
            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
            tableView.backgroundView?.addSubview(backgroundimageview)
            tableView.separatorStyle  = .none
            return 0
        }else{
            tableView.backgroundView = nil
            return 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLogTableViewCell.className, for: indexPath) as! ActivityLogTableViewCell
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let contact = self.contactsArray[indexPath.row]
        

        cell.labelNotification.text = contact.fullName
        cell.labelTime.text = contact.phoneNumber//activity.time.toString()
        cell.imageViewProfile.image = #imageLiteral(resourceName: "user")
        
        if (contact.isSelected) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.contactsArray[indexPath.row].isSelected = !self.contactsArray[indexPath.row].isSelected
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}




