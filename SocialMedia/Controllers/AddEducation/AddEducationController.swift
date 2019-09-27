//
//  AddEducationController.swift
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
extension SegueIdentifiable {
    static var addEducationController : SegueIdentifier {
        return SegueIdentifier(rawValue: AddEducationController.className)
    }
}

class AddEducationController: UIViewController, NVActivityIndicatorViewable {
    var seletedbtn = ""
    @IBOutlet var btnEdOnlyMe: DLRadioButton!
    @IBOutlet var lblEdOnlyMe: UILabel!
    @IBOutlet var btnEdFriends: DLRadioButton!
    @IBOutlet var lblEdFriends: UILabel!
    @IBOutlet var btnEdPublic: DLRadioButton!
    
    @IBOutlet var lblEdPublic: UILabel!
    var institute = String()
    var degreeTitle = String()
    var FromDate = Int()
    var TToDate = Int()
    var fromData = String()
    var toDate = String()
    var educationId = String()
    var fromEducationTimeIntervalData = String()
    var ToEducationTimeIntervalData = String()
    
    @IBOutlet weak var txtfield_institute: UITextField!
    @IBOutlet weak var txtField_degreeTitle: UITextField!
    @IBOutlet weak var txtfield_FromDate: UITextField!
    @IBOutlet weak var txtfield_ToDate: UITextField!
    @IBOutlet weak var btn_From: UIButton!
    @IBOutlet weak var btn_To: UIButton!
    
    
    // MARK: Properties
    var isKeyboardOpened = false
    
    
    @IBOutlet var lblHeaderEdCheck: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Education".localized
        let long = UserDefaults.standard.string(forKey: "i18n_language")
        
        self.lblEdOnlyMe.text = "Only Me".localized
        self.lblEdFriends.text = "Friends".localized
        self.lblEdPublic.text = "Public".localized
        self.lblHeaderEdCheck.text = "Privacy".localized
        
        if(long == "ar"){
            
            
            txtField_degreeTitle.textAlignment = .right
            txtfield_institute.textAlignment = .right
            txtfield_FromDate.textAlignment = .right
            txtfield_ToDate.textAlignment = .right
        
        }else{
            
            txtField_degreeTitle.textAlignment = .left
            txtfield_institute.textAlignment = .left
            txtfield_FromDate.textAlignment = .left
            txtfield_ToDate.textAlignment = .left
        }
            
        
        self.txtfield_institute.placeholder = "Your Institute".localized
        self.txtField_degreeTitle.placeholder = "Degree Title".localized
        self.txtfield_FromDate.placeholder = "From".localized
        self.txtfield_ToDate.placeholder = "To".localized
        
        
        if educationId != ""{
            txtfield_institute.text = institute
            txtField_degreeTitle.text = degreeTitle
            fromEducationTimeIntervalData = FromDate.toString
            fromData = self.convertDate(dateString: Double(FromDate))
            txtfield_FromDate.text = fromData
            ToEducationTimeIntervalData = TToDate.toString
            toDate = self.convertDate(dateString: Double(TToDate))
            txtfield_ToDate.text = toDate
        }

        
        txtfield_FromDate.isUserInteractionEnabled = false
        txtfield_ToDate.isUserInteractionEnabled = false
        
       // addRightButton()
        
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
extension AddEducationController {
    func validateForm() {
        guard let ed_Place = txtfield_institute.text,
            !ed_Place.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Where You Have Studied".localized , okAction: {
                    _ = self.txtfield_institute.becomeFirstResponder()
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        guard let position = txtField_degreeTitle.text,
            !position.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Your Education Title".localized , okAction: {
                    _ = self.txtField_degreeTitle.becomeFirstResponder()
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
        
        addEditEducationInfo()
    }
    
    // MARK: - API CALLS
    func addEditEducationInfo()
    {
        self.showLoader()
        if(self.btnEdOnlyMe.isSelected){
            self.seletedbtn = "Onlyme"
        }else if(self.btnEdPublic.isSelected){
            self.seletedbtn = "public"
        }else
        {
            self.seletedbtn = "Friends"
        }
        let parameters : [String: Any]
        
        if educationId == ""{
        parameters  = [
            "school": txtfield_institute.text!,
            "degree": txtField_degreeTitle.text!,
            "date_from": fromEducationTimeIntervalData,
            "date_to": ToEducationTimeIntervalData,
            "privacy": self.seletedbtn]
        }else{
          parameters  = [
            "id": educationId,
            "school": txtfield_institute.text!,
            "degree": txtField_degreeTitle.text!,
            "date_from": fromEducationTimeIntervalData,
            "date_to": ToEducationTimeIntervalData,
            "privacy": self.seletedbtn]
        }
        
        UserHandler.addEditEducationInfo(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.stopAnimating()
                // Post notification
                NotificationCenter.default.post(name: notificationName, object: nil)
                self.txtfield_institute.text = ""
                self.txtField_degreeTitle.text = ""
                self.txtfield_FromDate.text = ""
                self.txtfield_ToDate.text = ""
                // Create the alert controller
                let alertController = UIAlertController(title: "Success", message: success.message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: false)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error", message: success.message, okAction: nil)
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
extension AddEducationController {
    func addRightButton() {
        let editButton = UIBarButtonItem(image: #imageLiteral(resourceName: "tick"), style: .plain, target: self, action: #selector(ontickButtonClick))
        navigationItem.rightBarButtonItem  = editButton
    }
    @objc func ontickButtonClick() {
        
        validateForm()
    }
    func datePickerFromWork() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.fromEducationTimeIntervalData = String(dt.timeIntervalSince1970)
                let dd = formatter.string(from: dt)
                self.txtfield_FromDate.text = dd
            }
        }
    }
    func datePickerToWork() {
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                self.ToEducationTimeIntervalData = String(dt.timeIntervalSince1970)
                let dd = formatter.string(from: dt)
                self.txtfield_ToDate.text =  dd
            }
        }
    }

}
