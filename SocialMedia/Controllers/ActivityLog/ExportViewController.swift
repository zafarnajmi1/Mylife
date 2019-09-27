//
//  ExportViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 19/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import Contacts

extension SegueIdentifiable {
    static var exportController : SegueIdentifier {
        return SegueIdentifier(rawValue: ExportViewController.className)
    }
}

class ExportViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet var btnTick: UIButton!
    var isAllSelected : Bool = false
    
    var dataSource : [Contactdata] = []
    var duplicateArray : [Contactdata] = []
    var selectedContacts : [Contactdata] = []
     var filterArray : [Contactdata] = []
    
    var flag = false
    
    var deviceContact : [Contactdata] = []
    var store = CNContactStore()
    var loopIndex : Int = -1
    @IBOutlet var lblNoContactFound: UILabel!
    
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let activities = ModelGenerator.generateActivityModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(lang == "ar")
        {
        tableView.semanticContentAttribute = .forceRightToLeft
        }else
        {
            tableView.semanticContentAttribute = .forceLeftToRight
        }
        btnSelect.setTitle("Select All".localized, for: .normal)
        self.title = "Export Contacts".localized
        addBackButton()
        getContacts() // get device contact from phone
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addValuesToDataSource()
    }
    
    func addValuesToDataSource() {
        
        if let _contacts = UserHandler.sharedInstance.userData?.contacts
        {
            if (_contacts.count == 0) {
                btnSelect.isHidden = true
                lblNoContactFound.isHidden = false
            } else {
                lblNoContactFound.isHidden = true
                btnSelect.isHidden = false
                dataSource = []
                for object in _contacts {
                    let dict : NSDictionary = object as! NSDictionary
                    var contact : Contactdata = Contactdata()
                    contact.fullName =  dict.value(forKey: "name") as! String
                    contact.phoneNumber =  dict.value(forKey: "number") as! String
                    dataSource.append(contact)
                }
                tableView.reloadData()
            }
        } else {
            dataSource = []
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getContacts ()
    {
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
        
        for contact in cnContacts
        {
            print(contact)
            let firstName = contact.givenName
            print("first:\(firstName)")
            let lastName = contact.familyName
            print(lastName)
            
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
            objContact.fullName = "\(firstName) \(lastName)"
            objContact.phoneNumber = phoneNumber
            objContact.isSelected = false
            
            //            let objContact = Contactdata.init(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
            deviceContact.append(objContact)
            
            //            let emailAddress = contact.emailAddresses[0].value(forKey: "value")
            // emailAddressArray.append(emailAddress as! String)
        }
        if self.deviceContact.count == 0 {
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
    
    @IBAction func btnSelectAll(_ sender: Any) {
        isAllSelected = !isAllSelected
        let text : String = (isAllSelected == true) ? "Select All".localized : "UnSelect All".localized
        btnSelect.setTitle(text, for: .normal)
        for index in 0..<dataSource.count {
            dataSource[index].isSelected = isAllSelected
        }
        tableView.reloadData()
    }
    @IBAction func btnTick(_ sender: UIButton) {
        
       
        
         selectedContacts = dataSource.filter
        {
            (_ data : Contactdata) -> Bool in
            print(data.fullName)
            print(data.isSelected)
            return data.isSelected
        }
        
        for name in selectedContacts {
            print(name.fullName)
        }
        
        for index in 0..<selectedContacts.count
        {
           // print(index)
//            if (loopIndex <= index)
//            {
//                continue
//            }
//            else
//            {
//                  print(index)
//            }
            
            
            
//            if (checkDuplicate(ContactName: selectedContacts[index]))
//            {
//                flag = true
//                loopIndex = index
//                print(index)
//                print(selectedContacts[index].fullName)
//                updateDuplicate(ContactName : selectedContacts[index])
//                return
//            }
            
            
            if (checkDuplicate(ContactNumber: selectedContacts[index]))
            {
                flag = true
                loopIndex = index
                
                duplicateArray.append(selectedContacts[index])
                
                //selectedContacts.remove(at: index)
                //updateDuplicate(ContactNumber : selectedContacts[index])
               // return
            }
            else {
                filterArray.append(selectedContacts[index])
                
            }
            
            
            
            //if(flag == false)
            
                
            
               
                
            
            
            
            
           
        }
        
        
           UpdateDuplicateNum()

//
        
        
    }
    
    
    
    func UpdateDuplicateNum() {
        if duplicateArray.count == 0 {
            
            print(selectedContacts.count)
            print(filterArray.count)
            
            if filterArray.count == 0 {
                let errorAlert = UIAlertController(title: "Alert".localized, message: "Contacts Exports Successfully".localized, preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
                    alert -> Void in
                    //self.dismissVC(completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(errorAlert, animated: true, completion: nil)
            }
            else {
                for index in 0..<filterArray.count {
                    let contact = CNMutableContact()
                    
                    contact.givenName = filterArray[index].fullName
                    
                    contact.phoneNumbers = [CNLabeledValue(
                        label:CNLabelPhoneNumberiPhone,
                        value:CNPhoneNumber(stringValue: filterArray[index].phoneNumber))]
                    
                    // Saving the newly created contact
                    let store = CNContactStore()
                    let saveRequest = CNSaveRequest()
                    saveRequest.add(contact, toContainerWithIdentifier:nil)
                    try! store.execute(saveRequest)
                    
                    let errorAlert = UIAlertController(title: "Alert".localized, message: "Contacts Exports Successfully".localized, preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
                        alert -> Void in
                        //self.dismissVC(completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
            }
            
            
            
        }
        
        }
        else {
            
                // Creating a mutable object to add to the contact
                
//                for index in 0..<selectedContacts.count {
//                    let contact = CNMutableContact()
//
//                    contact.givenName = selectedContacts[index].fullName
//
//                    contact.phoneNumbers = [CNLabeledValue(
//                        label:CNLabelPhoneNumberiPhone,
//                        value:CNPhoneNumber(stringValue: selectedContacts[index].phoneNumber))]
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
                                
                                let store = CNContactStore()
                                let contactToAdd = CNMutableContact()
                                //contactToAdd.givenName = cnt.fullName!
                                
                                
                                
                                
                                let mobileNumber = CNPhoneNumber(stringValue: (cnt.phoneNumber ?? ""))
                                let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
                                contactToAdd.phoneNumbers = [mobileValue]
                                contactToAdd.givenName = fNameField.text ?? ""
                                
                                
                                let saveRequest = CNSaveRequest()
                                //saveRequest.update(contactToAdd)
                                saveRequest.add(contactToAdd, toContainerWithIdentifier:nil)
                                //                    saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
                                do {
                                    try store.execute(saveRequest)
                                } catch {
                                    print(error)
                                }
                                
                                self.duplicateArray.remove(at: index)
                                //print(duplicateArray.count)
                                self.UpdateDuplicateNum()
                                //TODO: Save user data in persistent storage - a tutorial for another time
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
                    }
                    
                    actionSheet.addAction(actionOk)
                    actionSheet.addAction(actionCancel)
                    self.present(actionSheet, animated: true, completion: nil)
                }
                
            
            }
            
    }
    
    
//    func updateDuplicate(ContactName _contact : Contactdata) {
//
//        let actionSheet: UIAlertController = UIAlertController(title: "Duplicate Contact Found".localized, message: "Following contact also exist on your device \(_contact.fullName!)\(_contact.phoneNumber!) Do you want to update this contact? ", preferredStyle: .alert)
//        let actionOk = UIAlertAction(title: "Ok".localized, style: .default)
//        { _ in
//
//              let alertController = UIAlertController(title: "Name", message: "Please update name".localized, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Save".localized, style: .default, handler: {
//                alert -> Void in
//                let fNameField = alertController.textFields![0] as UITextField
//                if fNameField.text != "" {
//
//                    let store = CNContactStore()
//                    let contactToAdd = CNMutableContact()
//                    contactToAdd.givenName = fNameField.text ?? ""
//
//                    let mobileNumber = CNPhoneNumber(stringValue: (_contact.phoneNumber ?? ""))
//                    let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
//                    contactToAdd.phoneNumbers = [mobileValue]
//
//
//
//                    let saveRequest = CNSaveRequest()
//                    //saveRequest.update(contactToAdd)
//                    saveRequest.add(contactToAdd, toContainerWithIdentifier:nil)
////                    saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
//                    do {
//                        try store.execute(saveRequest)
//                    } catch {
//                        print(error)
//                    }
//                    self.btnTick(self.btnTick)
//                    //TODO: Save user data in persistent storage - a tutorial for another time
//                } else {
//                    let errorAlert = UIAlertController(title: "Error".localized, message: "Please enter full name".localized, preferredStyle: .alert)
//                    errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
//                        alert -> Void in
//                        self.present(alertController, animated: true, completion: nil)
//                    }))
//                    self.present(errorAlert, animated: true, completion: nil)
//                }
//            }))
//
//            alertController.addTextField(configurationHandler: { (textField) -> Void in
//                textField.placeholder = _contact.fullName!
//                textField.textAlignment = .center
//            })
//
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//        let actionCancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
//        { _ in
//            //self.btnTick(self.btnTick)
//        }
//
//        actionSheet.addAction(actionOk)
//        actionSheet.addAction(actionCancel)
//        self.present(actionSheet, animated: true, completion: nil)
//    }
//
//    func updateDuplicate(ContactNumber _contact : Contactdata) {
//
//        let actionSheet: UIAlertController = UIAlertController(title: "Duplicate Contact Found".localized, message: "Following contact also exist on your device \(_contact.phoneNumber!) Do you want to update this contact? ", preferredStyle: .alert)
//        let actionOk = UIAlertAction(title: "Ok", style: .default)
//        { _ in
//
//            let alertController = UIAlertController(title: "Name".localized, message: "Please update name".localized, preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Save".localized, style: .default, handler: {
//                alert -> Void in
//                let fNameField = alertController.textFields![0] as UITextField
//                if fNameField.text != ""
//                {
//
//                    let store = CNContactStore()
//                    let contactToAdd = CNMutableContact()
//                    contactToAdd.givenName = _contact.fullName!
//
//                    let mobileNumber = CNPhoneNumber(stringValue: (fNameField.text ?? ""))
//                    let mobileValue = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: mobileNumber)
//                    contactToAdd.phoneNumbers = [mobileValue]
//
//                    let saveRequest = CNSaveRequest()
//                    //saveRequest.update(contactToAdd)
//                    saveRequest.add(contactToAdd, toContainerWithIdentifier:nil)
//                    //                    saveRequest.add(contactToAdd, toContainerWithIdentifier: nil)
//                    do {
//                        try store.execute(saveRequest)
//                    } catch {
//                        print(error)
//                    }
//                    self.btnTick(self.btnTick)
//                    //TODO: Save user data in persistent storage - a tutorial for another time
//                }
//                else
//                {
//                    let errorAlert = UIAlertController(title: "Error".localized, message: "Please enter phone number".localized, preferredStyle: .alert)
//                    errorAlert.addAction(UIAlertAction(title: "OK".localized, style: .cancel, handler: {
//                        alert -> Void in
//                        self.present(alertController, animated: true, completion: nil)
//                    }))
//                    self.present(errorAlert, animated: true, completion: nil)
//                }
//            }))
//
//            alertController.addTextField(configurationHandler: { (textField) -> Void in
//                textField.placeholder = "Name".localized
//                textField.text = _contact.fullName!
//                textField.textAlignment = .center
//            })
//
//            self.present(alertController, animated: true, completion: nil)
//        }
//
//        let actionCancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
//        { _ in
//           // self.btnTick(self.btnTick)
//        }
//
//        actionSheet.addAction(actionOk)
//        actionSheet.addAction(actionCancel)
//        self.present(actionSheet, animated: true, completion: nil)
//    }
    
    func checkDuplicate(ContactName _contact : Contactdata) -> Bool {
        for object in deviceContact
        {
            if (object.fullName == _contact.fullName) {
                return true
            }
        }
        return false
    }
    
    func checkDuplicate(ContactNumber _contact : Contactdata) -> Bool {
        for object in deviceContact {
            if (object.phoneNumber == _contact.phoneNumber) {
                return true
            }
        }
        return false
    }
    
    // MARK: - UITableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
       
        if dataSource.count == 0
        {
            btnSelect.isHidden = true
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
        }else
        {
             btnSelect.isHidden = false
            tableView.backgroundView = nil
            return 1
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityLogTableViewCell.className, for: indexPath) as! ActivityLogTableViewCell
        
        cell.labelNotification.text = dataSource[indexPath.row].fullName
        cell.labelTime.text = dataSource[indexPath.row].phoneNumber
        cell.imageViewProfile.image = #imageLiteral(resourceName: "user")

        if (dataSource[indexPath.row].isSelected) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dataSource[indexPath.row].isSelected = !self.dataSource[indexPath.row].isSelected
        print(self.dataSource[indexPath.row].isSelected)
        print(self.dataSource[indexPath.row].fullName)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

