//
//  AddWorkController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 05/09/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
//import ActionSheetPicker_3_0
import NVActivityIndicatorView
import DatePickerDialog
import DLRadioButton

let notificationName = Notification.Name("NotificationIdentifier")

extension SegueIdentifiable {
    static var addWorkController : SegueIdentifier {
        return SegueIdentifier(rawValue: AddWorkController.className)
    }
}

class AddWorkController: UIViewController, NVActivityIndicatorViewable {
    var SeletectedBtn = ""
    @IBOutlet var lblheaderCheck: UILabel!
    @IBOutlet var btnOnlyMe: DLRadioButton!
    @IBOutlet var lblOnlyme: UILabel!
    @IBOutlet var btnFriends: DLRadioButton!
    @IBOutlet var lblFriends: UILabel!
    @IBOutlet var lblPublic: UILabel!
    @IBOutlet var btnpublic: DLRadioButton!
    var company = String()
    var postion = String()
    var city = String()
    var date_from = Double()
    var date_to = Double()
    var workDescription = String()
    var workId = String()
    var fromData = String()
    var ToData = String()
    var fromWorkTimeIntervalData = String()
    var ToWorkTimeIntervalData = String()
    
    @IBOutlet weak var txtfield_WhereDidYouWork: UITextField!
    @IBOutlet weak var txtField_poition: UITextField!
    @IBOutlet weak var txtfield_city: UITextField!
    @IBOutlet weak var txtfield_description: UITextField!
    @IBOutlet weak var txtfield_FromDate: UITextField!
    @IBOutlet weak var txtfield_ToDate: UITextField!
    @IBOutlet weak var btn_workFrom: UIButton!
    @IBOutlet weak var btn_workTo: UIButton!
    
    
    // MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.title = "Add Work".localized
        let long = UserDefaults.standard.string(forKey: "i18n_language")
        self.lblOnlyme.text = "Only Me".localized
        self.lblFriends.text = "Friends".localized
        self.lblPublic.text = "Public".localized
        self.lblheaderCheck.text = "Privacy".localized
        if(long == "ar"){
            txtfield_WhereDidYouWork.textAlignment = .right
            txtField_poition.textAlignment = .right
            txtfield_city.textAlignment = .right
            txtfield_FromDate.textAlignment = .right
            txtfield_ToDate.textAlignment = .right
            txtfield_description.textAlignment = .right
        }else{
            txtfield_WhereDidYouWork.textAlignment = .left
            txtField_poition.textAlignment = .left
            txtfield_city.textAlignment = .left
            txtfield_FromDate.textAlignment = .left
            txtfield_ToDate.textAlignment = .left
            txtfield_description.textAlignment = .left
            
        }
        
        if workId != ""{
            txtfield_WhereDidYouWork.text = company
            txtField_poition.text = postion
            txtfield_city.text = city
            fromWorkTimeIntervalData = date_from.toString
            fromData = self.convertDate(dateString: date_from)
            txtfield_FromDate.text = fromData
            ToWorkTimeIntervalData = date_to.toString
            ToData = self.convertDate(dateString: date_to)
            txtfield_ToDate.text = ToData
            txtfield_description.text = workDescription
        }
        self.txtfield_WhereDidYouWork.placeholder = "Where did you work?".localized
        self.txtField_poition.placeholder = "Position".localized
        self.txtfield_city.placeholder = "City".localized
        self.txtfield_ToDate.placeholder = "To".localized
        self.txtfield_FromDate.placeholder = "From".localized
        self.txtfield_description.placeholder = "Description".localized

        txtfield_FromDate.isUserInteractionEnabled = false
        txtfield_ToDate.isUserInteractionEnabled = false
       
        
      //  addRightButton()
        
        
        
        let contactsButton = UIButton(type: .custom)
        contactsButton.setImage(#imageLiteral(resourceName: "tick"), for: .normal)
        contactsButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        contactsButton.addTarget(self, action: #selector(ontickButtonClick), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: contactsButton)
        
        menuItem.customView?.snp.makeConstraints({ (make) in
            make.width.equalTo(22)
            make.height.equalTo(22)
        })
        navigationItem.rightBarButtonItem  = menuItem

        
        addBackButton()
        
        // Do any additional setup after loading the view.
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
    
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    //MARK: - ACTIONS
    @IBAction func action_workFrom(_ sender: Any) {
        datePickerFromWork()

    }
    
    @IBAction func action_workTo(_ sender: Any) {
        datePickerToWork()
    }
}


// MARK: - Cusotm
extension AddWorkController {
    func validateForm() {
        guard let workPlace = txtfield_WhereDidYouWork.text,
            !workPlace.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Where Did You Work Details".localized , okAction: {
                    _ = self.txtfield_WhereDidYouWork.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let position = txtField_poition.text,
            !position.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Your Position".localized , okAction: {
                    _ = self.txtField_poition.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let city = txtfield_city.text,
            !city.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Your City".localized , okAction: {
                    _ = self.txtfield_city.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let description = txtfield_description.text,
            !description.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Description".localized , okAction: {
                    _ = self.txtfield_description.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let fromDate = txtfield_FromDate.text,
            !fromDate.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter From Date".localized , okAction: {
                    _ = self.txtfield_FromDate.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let toDate = txtfield_ToDate.text,
            !toDate.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter To Date".localized , okAction: {
                    _ = self.txtfield_ToDate.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        
        addEditWorkInfo()
    }
    
    // MARK: - API CALLS
    func addEditWorkInfo()
    {
        
        if(self.btnOnlyMe.isSelected){
            self.SeletectedBtn = "Onlyme"
        }else if(self.btnpublic.isSelected){
            self.SeletectedBtn = "public"
        }else
        {
            self.SeletectedBtn = "Friends"
        }
        
        self.showLoader()
        let parameters : [String: Any]
        if workId == ""{
            parameters  = [
                "company": txtfield_WhereDidYouWork.text!,
                "position": txtField_poition.text!,
                "city": txtfield_city.text!,
                "date_from": fromWorkTimeIntervalData,
                "date_to": ToWorkTimeIntervalData,
                "description": txtfield_description.text!,
                "privacy": self.SeletectedBtn]
        }else{
           parameters  = [
                
                "id": workId,
                "company": txtfield_WhereDidYouWork.text!,
                "position": txtField_poition.text!,
                "city": txtfield_city.text!,
                "date_from": fromWorkTimeIntervalData,
                "date_to": ToWorkTimeIntervalData,
                "description": txtfield_description.text!,
                "privacy": self.SeletectedBtn ]
        }
       
        
        UserHandler.addEditWorkInfo(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
//                LoginViewController().viewWillAppear(true)
              
                // Post notification
                NotificationCenter.default.post(name: notificationName, object: nil)
                self.stopAnimating()
                self.txtfield_WhereDidYouWork.text = ""
                self.txtField_poition.text = ""
                self.txtfield_city.text = ""
                self.txtfield_FromDate.text = ""
                self.txtfield_ToDate.text = ""
                self.txtfield_description.text = ""
               
                // Create the alert controller
                let alertController = UIAlertController(title: "Success".localized, message: success.message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                   self.navigationController?.popViewController(animated: false)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
               
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: nil)
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
            
        }
    }
}

//MARK: - SIMPLE FUNCTIONS
extension AddWorkController {
    func addRightButton() {
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(ontickButtonClick))
        
        navigationItem.rightBarButtonItem  = editButton
    }
    @objc  func ontickButtonClick() {
        
        validateForm()
    }
    
    func datePickerFromWork() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.fromWorkTimeIntervalData = String(dt.timeIntervalSince1970)
                let dd = formatter.string(from: dt)
                self.txtfield_FromDate.text = dd
            }
        }
    }
    func datePickerToWork() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.ToWorkTimeIntervalData = String(dt.timeIntervalSince1970)
                let dd = formatter.string(from: dt)
                self.txtfield_ToDate.text =  dd
            }
        }
    }
    
    
}
