//
//  RegisterViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 03/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import Material
//import ActionSheetPicker_3_0
import NVActivityIndicatorView
import DatePickerDialog
import DropDown


extension SegueIdentifiable {
    static var registerController : SegueIdentifier {
        return SegueIdentifier(rawValue: RegisterViewController.className)
    }
}

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NVActivityIndicatorViewable {
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }
    @IBOutlet var registerHeaderLbl: UILabel!
    @IBOutlet var genderLbl: UILabel!
    // MARK: Properties
    var male_Female_Status = ""
     var dateOfBirth = String()
    let DatePicker = DatePickerDialog()
    let dayDropDown = DropDown()
    let monthDropDown = DropDown()
    let yearDropDown = DropDown()
    // MARK: Outlets
    var fcmToken = "0"

    @IBOutlet var arBackButton: UIButton!
    @IBOutlet weak var viewDay: UIView!
    @IBOutlet weak var viewMonth: UIView!
    @IBOutlet weak var viewYear: UIView!
    @IBOutlet weak var lblDropDownYear: UILabel!
    @IBOutlet weak var lblDropDownMonth: UILabel!
    @IBOutlet weak var lblDropDownDay: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var maleView: UIView!
    @IBOutlet weak var femaleView: UIView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    @IBOutlet var alreadyHaveAccount: UIButton!
    
    @IBOutlet var alreadeyAccountLbl: UIButton!
    @IBOutlet var maleLbl: UILabel!
    @IBOutlet var femaleLbl: UILabel!
    
    @IBOutlet var dateOfBirthLbl: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    
    @IBOutlet var termsAndCondtionCheckBtn: UIButton!
    @IBOutlet var IagreeBtn: UIButton!
    @IBOutlet var termsconditionBtn: UIButton!
    
    
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    @IBOutlet weak var textFieldName: UITextField! {
        didSet {
            textFieldName.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldEmail: UITextField! {
        didSet {
            textFieldEmail.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPhone: UITextField! {
        didSet {
            textFieldPhone.delegate = self
        }
    }
    
    @IBOutlet weak var textFieldPassword: UITextField! {
        didSet {
            textFieldPassword.delegate = self
        }
    }
    
    @IBOutlet var textFieldConfirmPassword: UITextField! {
        didSet {
            textFieldConfirmPassword.delegate = self
        }
    }
    
    @IBOutlet var buttonDateOfBirth: UIButton!
    
   
    
    @IBOutlet weak var buttonMale: CheckBox! {
        didSet {
            buttonMale.isChecked = true
        }
    }
    
    @IBOutlet weak var buttonFemale: CheckBox! {
        didSet {
            buttonFemale.isChecked = false
            
        }
    }
    
    @IBAction func actionMale(_ sender: Any) {
        
        
        if buttonMale.isChecked == false {
            buttonMale.isChecked = true
           
        }else{
           male_Female_Status = "male"
            buttonMale.isChecked = false
            buttonFemale.isChecked = true
            buttonFemale.setImage(UIImage(named: "radio"), for: .normal)
            buttonMale.setImage(UIImage(named: "selected-radio"), for: .normal)
        }
        
    }
    
    @IBAction func actionFemale(_ sender: Any) {
        
        if buttonFemale.isChecked == false{
            
            buttonFemale.isChecked = true
        }else{
           // privacyStatus = "close"
            male_Female_Status = "female"
            buttonMale.isChecked = true
            buttonFemale.isChecked = false
            buttonMale.setImage(UIImage(named: "radio"), for: .normal)
            buttonFemale.setImage(UIImage(named: "selected-radio"), for: .normal)
        }
    }
    
    
    @IBAction func actionTermsAndContionCheckBtn(_ sender: Any) {
        
        if self.termsAndCondtionCheckBtn.isSelected == false {
            print("selected")
            self.termsAndCondtionCheckBtn.isSelected = true
        }else{
            self.termsAndCondtionCheckBtn.isSelected = false
             print("not selected")
          
            
        }
    }
    
    @IBAction func actionReadTermsAndCondtion(_ sender: Any) {
        
       let storyboard = UIStoryboard(name: "Core", bundle: nil)
       let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
       self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var buttonRegister: UIButton!
    
    // MARK: Properties
    
    var imagePicker = UIImagePickerController()
    var userArray = [UserModel]()
    var blurredBackgroundLow: UIImage!
    var blurredBackgroundHigh: UIImage!
    let prefs = UserDefaults.standard
    var privacyStatus = ""
    // MARK: Application Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addBackButton() //menow
        if(lang == "ar")
        {
            backButton.semanticContentAttribute = .forceRightToLeft
            
            backButton.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
            
        }else
        {
            
            backButton.isHidden = false
        }
//        self.DatePicker.maximumDate = Date()
        privacyStatus = "open"
        prepareDayDropDown()
        prepareMonthDropDown()
        prepareYearDropDown()
        hideKeyboardOnTouch()
        //buttonMale.isChecked = true
        //male_Female_Status = "male"
    
        
        textFieldName.placeholder = "Name".localized
        textFieldEmail.placeholder = "Email".localized
        textFieldPhone.placeholder = "Phone".localized
        textFieldPassword.placeholder = "Password".localized
        textFieldConfirmPassword.placeholder = "Confirm Password".localized
        dateOfBirthLbl.text = "Date of Birth".localized
        lblDropDownDay.text = "Date".localized
        lblDropDownYear.text = "Year".localized
        lblDropDownMonth.text = "Month".localized
        genderLbl.text = "Gender".localized
        maleLbl.text = "Male".localized
        femaleLbl.text = "Female".localized
        buttonRegister.setTitle("Register".localized, for: .normal)
      
        registerHeaderLbl.text = "Register".localized
        alreadeyAccountLbl.setTitle("Already Have Account?".localized, for: .normal)
        
        self.IagreeBtn.setTitle("I agree with".localized, for: .normal)
        self.termsconditionBtn.setTitle("terms & conditions".localized, for: .normal)
        
        if lang == "ar" {
            textFieldName.textAlignment = .right
            textFieldEmail.textAlignment = .right
            textFieldPassword.textAlignment = .right
            textFieldPhone.textAlignment = .right
            textFieldConfirmPassword.textAlignment = .right
            
//            let paddingView = UIView(frame: CGRect(x :0, y :0,width:  -20, height: self.textFieldName.frame.height))
//            textFieldName.rightView = paddingView
//            textFieldName.rightViewMode = UITextFieldViewMode.always
//
            let paddingView1 = UIView(frame: CGRect(x :0, y :0,width:  -20, height: self.textFieldEmail.frame.height))
            textFieldEmail.rightView = paddingView1
            textFieldEmail.rightViewMode = UITextField.ViewMode.always
            
            let paddingView2 = UIView(frame: CGRect(x :0, y :0,width:  -20, height: self.textFieldPassword.frame.height))
            textFieldPassword.rightView = paddingView2
            textFieldPassword.rightViewMode = UITextField.ViewMode.always
            
            let paddingView3 = UIView(frame: CGRect(x :0, y :0,width:  -20, height: self.textFieldPhone.frame.height))
            textFieldPhone.rightView = paddingView3
            textFieldPhone.rightViewMode = UITextField.ViewMode.always
            
            let paddingView4 = UIView(frame: CGRect(x :0, y :0,width:  -20, height: self.textFieldConfirmPassword.frame.height))
            textFieldConfirmPassword.rightView = paddingView4
            textFieldConfirmPassword.rightViewMode = UITextField.ViewMode.always
            
            textFieldName.setRightPaddingPoints(20)
        }else
        {
            let paddingView = UIView(frame: CGRect(x :0, y :0,width:  20, height: self.textFieldName.frame.height))
            textFieldName.leftView = paddingView
            textFieldName.leftViewMode = UITextField.ViewMode.always
            
            let paddingView1 = UIView(frame: CGRect(x :0, y :0,width:  20, height: self.textFieldEmail.frame.height))
            textFieldEmail.leftView = paddingView1
            textFieldEmail.leftViewMode = UITextField.ViewMode.always
            
            let paddingView2 = UIView(frame: CGRect(x :0, y :0,width:  20, height: self.textFieldPassword.frame.height))
            textFieldPassword.leftView = paddingView2
            textFieldPassword.leftViewMode = UITextField.ViewMode.always
            
            let paddingView3 = UIView(frame: CGRect(x :0, y :0,width:  20, height: self.textFieldPhone.frame.height))
            textFieldPhone.leftView = paddingView3
            textFieldPhone.leftViewMode = UITextField.ViewMode.always
            
            let paddingView4 = UIView(frame: CGRect(x :0, y :0,width:  20, height: self.textFieldConfirmPassword.frame.height))
            textFieldConfirmPassword.leftView = paddingView4
            textFieldConfirmPassword.leftViewMode = UITextField.ViewMode.always
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        startObservingKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopObservingKeyboard()
    }
    // MARK: - Animation Loader
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    // MARK: - DropDown Views Configuration
    
    
    
    
    func prepareDayDropDown() {
        //postPrivacyDropDown.selectionBackgroundColor = .clear
        dayDropDown.textColor = UIColor.black.withAlphaComponent(0.8)
        dayDropDown.textFont = UIFont.thin
        dayDropDown.anchorView = self.viewDay
        
//        if lang == "ar" {
//            yearDropDown.anchorView = self.viewYear //self.viewDay
//        }
//        else {
//           dayDropDown.anchorView = self.viewYear
//        }
        
        if lang == "ar" {
            dayDropDown.anchorView = self.viewYear
        }
        else {
            dayDropDown.anchorView = self.viewDay
        }
        
        var items = [String]()
        if self.lblDropDownMonth.text=="February"{
            items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29"]
        }else{
             items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
        }
       
      
        
        dayDropDown.dataSource = items
        
        dayDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblDropDownDay.text = items[index]
            
            //self.selectedSharingType = index
        }
        
        dayDropDown.width = self.viewDay.plainView.bounds.width
        //dayDropDown.bottomOffset = CGPoint(x: 0, y: lblDropDownDay.plainView.bounds.height)
        dayDropDown.topOffset = CGPoint(x:0, y: -lblDropDownDay.plainView.bounds.height)
        dayDropDown.direction = .top
        dayDropDown.backgroundColor = .white
        dayDropDown.dismissMode = .automatic
    }
    
    func prepareMonthDropDown() {
        //postPrivacyDropDown.selectionBackgroundColor = .clear
        monthDropDown.textColor = UIColor.black.withAlphaComponent(0.8)
        monthDropDown.textFont = UIFont.thin
        monthDropDown.anchorView = self.viewMonth
        
        let items = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        
        monthDropDown.dataSource = items
        
        monthDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblDropDownMonth.text = items[index]
            self.prepareDayDropDown()
            //self.selectedSharingType = index
        }
        
        monthDropDown.width = self.viewMonth.plainView.bounds.width
        //dayDropDown.bottomOffset = CGPoint(x: 0, y: lblDropDownDay.plainView.bounds.height)
        monthDropDown.topOffset = CGPoint(x:0, y: -lblDropDownMonth.plainView.bounds.height)
        monthDropDown.direction = .top
        monthDropDown.backgroundColor = .white
        monthDropDown.dismissMode = .automatic
    }
    
    func prepareYearDropDown() {
        //postPrivacyDropDown.selectionBackgroundColor = .clear
        yearDropDown.textColor = UIColor.black.withAlphaComponent(0.8)
        yearDropDown.textFont = UIFont.thin
        yearDropDown.anchorView = self.viewYear
        
        if lang == "ar" {
            yearDropDown.anchorView = self.viewDay
        }
        else {
            yearDropDown.anchorView = self.viewYear
        }
        
        
        let items = ["2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975", "1974", "1973", "1972", "1971", "1970", "1969", "1968", "1967", "1966", "1965", "1964", "1963", "1962", "1961", "1960", "1959", "1958", "1957", "1956", "1955", "1954", "1953", "1952", "1951", "1950", "1949", "1948", "1947", "1946", "1945", "1944", "1943", "1942", "1941", "1940", "1939", "1938", "1937", "1936", "1935", "1934", "1933", "1932", "1931", "1930", "1929", "1928", "1927", "1926", "1925", "1924", "1923", "1922", "1921", "1920", "1919", "1918", "1917", "1916", "1915", "1914", "1913", "1912", "1911", "1910", "1909", "1908", "1907", "1906", "1905", "1904", "1903", "1902", "1901", "1900"]
        
        yearDropDown.dataSource = items
        
        yearDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblDropDownYear.text = items[index]
            //self.selectedSharingType = index
        }
        
        yearDropDown.width = self.viewYear.plainView.bounds.width
        //dayDropDown.bottomOffset = CGPoint(x: 0, y: lblDropDownDay.plainView.bounds.height)
        yearDropDown.topOffset = CGPoint(x:0, y: -lblDropDownMonth.plainView.bounds.height)
        yearDropDown.direction = .top
        yearDropDown.backgroundColor = .white
        yearDropDown.dismissMode = .automatic
    }
    
    // MARK: - IBActions

    @IBAction func dropDownDayAction(_ sender: UIButton) {
        dayDropDown.hide()
        dayDropDown.show()
    }
    
    @IBAction func dropDownMonthAction(_ sender: UIButton) {
        monthDropDown.hide()
        monthDropDown.show()
    }
    
    @IBAction func dropDownYearAction(_ sender: UIButton) {
        yearDropDown.hide()
        yearDropDown.show()
    }
    
    @IBAction func onButtonDateOfBirthClicked(_ sender: UIButton) {
       // datePicker()
    }
    
    @IBAction func datePickerbuttonAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func arBackButtonAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: false, completion: nil)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(controller, animated: false, completion: nil)
    }
    
    @IBAction func actionAlreadyHaveAnAccount(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func actionMale(_ sender: Any) {
//        if buttonFemale.isChecked==true{
//
//        }else{
//            privacyStatus = "close"
//            buttonMale.isChecked = false
//            buttonFemale.isChecked = true
//            buttonMale.setImage(UIImage(named: "radio"), for: .normal)
//            buttonFemale.setImage(UIImage(named: "selected-radio"), for: .normal)
//        }
//    }
//
//    @IBAction func actionFemale(_ sender: Any) {
//        if buttonFemale.isChecked==true{
//
//        }else{
//            privacyStatus = "close"
//            buttonMale.isChecked = false
//            buttonFemale.isChecked = true
//            buttonMale.setImage(UIImage(named: "radio"), for: .normal)
//            buttonFemale.setImage(UIImage(named: "selected-radio"), for: .normal)
//        }
//    }
    
    @IBAction func onRegisterButtonClciked(_ sender: UIButton) {
        // perform validation then move to home
//        appDelegate.pushToHomeController()
        validateForm()
        
    }
    
    @IBAction func onButtonAlreadyHaveAccountClciked(_ sender: UIButton) {
        
//        self.navigationController?.popViewController(animated: true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: false, completion: nil)
    }
    
}

//MARK:- TextField Delegates
extension RegisterViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textFieldPhone.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 15 // Bool
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textFieldName:
            _ = textFieldEmail.becomeFirstResponder()
            
            return true
        case textFieldEmail:
            _ = textFieldPhone.becomeFirstResponder()
            
            return true
            
        case textFieldPhone:
            _ = textFieldConfirmPassword.becomeFirstResponder()
            
            return true
            
        case textFieldPassword:
            _ = textFieldConfirmPassword.becomeFirstResponder()
            
            return true
            
        case textFieldConfirmPassword:
            dismissKeyboard()
            
            //datePicker()
            
            return true
            
        default:
            return true
        }
    }
}

// MARK: Keyboard Observer
extension RegisterViewController: KeyboardObserver {
    
}

// MARK: - Cusotm
extension RegisterViewController {
    func validateForm() {
        guard let name = textFieldName.text,
            !name.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Name".localized , okAction: {
                    _ = self.textFieldName.becomeFirstResponder()
                })
                
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        
//        if name.characters.count < 4 {
//            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Valid Name".localized, okAction: { _ in
//                _ = self.textFieldName.becomeFirstResponder()
//
//            })
//            self.present(alertView, animated: true, completion: nil)
//            return
//        }
        
        guard let email = textFieldEmail.text,
            !email.isEmpty  else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter email".localized, okAction: { 
                    self.textFieldEmail.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        
//        if !email.isValidEmail {
//            let alertView = AlertView.prepare(title: "Error".localized, message: "Email is not valid".localized, okAction: { _ in
//                self.textFieldEmail.becomeFirstResponder()
//            })
//            self.present(alertView, animated: true, completion: nil)
//
//            return
//        }
        
        guard let phoneNumber = textFieldPhone.text,
            !phoneNumber.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter phone number".localized, okAction: {
                    self.textFieldPhone.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        if phoneNumber.count < 10 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Phone number, Minimum 10 Characters required".localized, okAction: {
                self.textFieldPhone.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        if phoneNumber.count > 15 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Phone number, should not be greater then 15 Characters".localized, okAction: {
                self.textFieldPhone.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        if !phoneNumber.isValidPhone {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Phone number is not valid".localized, okAction: {
                self.textFieldPhone.becomeFirstResponder()
            })
            
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
        guard let password = textFieldPassword.text,
            !password.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter password".localized, okAction: {
                    self.textFieldPassword.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        
        if password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password require minimum of 6 characters".localized, okAction: {
                self.textFieldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            
            return
        }
        
        guard let C_password = textFieldConfirmPassword.text,
            !C_password.isEmpty else {
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please enter confirm password".localized, okAction: {
                    self.textFieldConfirmPassword.becomeFirstResponder()
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
        }
        
        if C_password.count < 6 {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Confirm Password, Minimum 6 Characters required".localized, okAction: {
                self.textFieldConfirmPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        if C_password != password {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Password not match".localized, okAction: {
                self.textFieldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
        
//        if male_Female_Status == ""
//        {
//            let alertView = AlertView.prepare(title: "Error".localized, message: "Please select gender".localized, okAction: { _ in
//                self.textFieldPassword.becomeFirstResponder()
//            })
//            self.present(alertView, animated: true, completion: nil)
//
//            return
//        }
        
        
        
//        if lbldate.text?.isEmpty == true
//
//        {
//            let alertView = AlertView.prepare(title: "Error", message: "Please set date of birth", okAction: { _ in
//                self.textFieldPassword.becomeFirstResponder()
//            })
//            self.present(alertView, animated: true, completion: nil)
//
//            return
//        }
        
        let dtOB = "\(lblDropDownDay.text!)-\(lblDropDownMonth.text!)-\(lblDropDownYear.text!)"
        if let _dob = Date(fromString: dtOB, format: "yyyy-MM-dd") { //"dd-MM-yyyy"
            let formatter = DateFormatter()
            formatter.dateFormat =  "yyyy-MM-dd" //"dd-MM-yyyy"
            self.dateOfBirth = String(_dob.timeIntervalSince1970)
            print(self.dateOfBirth)
//            let dd = formatter.string(from: _dob)
//            self.lbldate.text =  dd
        } //else {
            //let alertView = AlertView.prepare(title: "Error".localized, message: "Please set date of birth".localized, okAction: { _ in
               // self.textFieldPassword.becomeFirstResponder()
            //})
            //self.present(alertView, animated: true, completion: nil)
            
            //return
        //}        //        var dob = Date(fromString: dtOB, format: "dd-MM-yyyy")
        
        
        
        if termsAndCondtionCheckBtn.isSelected == false {
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Accept Terms and Conditons to Processed".localized, okAction: {
                self.textFieldPassword.becomeFirstResponder()
            })
            self.present(alertView, animated: true, completion: nil)

            return
        }
        
        self.registration(name:name,email:email,password:password,C_password:C_password,phoneNumber:phoneNumber,male_Female_Status:male_Female_Status,dateOfBirth:dateOfBirth)
        
    }
    
    func datePicker() {
        
        DatePickerDialog().show("Date of Birth".localized, doneButtonTitle: "Done".localized, cancelButtonTitle: "Cancel".localized, datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd" //"dd-MM-yyyy"
                formatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
                self.dateOfBirth = String(dt.timeIntervalSince1970)
                let dd = formatter.string(from: dt)
                self.lbldate.text =  dd
                print(self.lbldate)
            }
        }
    }
    
    //MARK:- Api Calls
    func registration(name:String,email:String,password:String,C_password:String,phoneNumber:String,male_Female_Status:String,dateOfBirth:String){
        self.showLoader()
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
        }
        
        //        let finalText = self.lbldate.text!.replace(string: "-", replacement: "")=
        var parameters : [String: Any] = ["full_name" : name ,
                                          "email": email,
                                          "password": password,
                                          "password_confirmation": C_password,
                                          "mobile": phoneNumber,
                                          "city": "au",
                                          "address": "",
                                          "fcm_token": self.fcmToken
        ]
        
        if  dateOfBirth != "" {
            parameters.updateValue(dateOfBirth, forKey: "birthday")
        }
        if  male_Female_Status != "" {
            parameters.updateValue(male_Female_Status, forKey: "gender")
        }
        
        print(parameters)
        UserHandler.registerUser(params: parameters as NSDictionary , success: { (success) in
            if success.statusCode == 200{
                
                self.loginToHome(email:email,password:password)
                self.stopAnimating()
            }else{
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                })
                self.present(alertView, animated: true, completion: nil)
            }
        })
        { (error) in
            print("error = ",error!)
            self.stopAnimating()
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }
    func loginToHome(email:String,password:String){
        self.showLoader()
        if let getToken = UserDefaults.standard.value(forKey: "fcmToken") as? String {
            self.fcmToken = getToken
        }
        let parameters : [String: Any] = ["email" : email ,
                                          "password": password,
                                          "fcm_token": self.fcmToken
            
        ]
        
        UserHandler.loginUser(params: parameters as NSDictionary , success: { (success) in
            
            if(success.data != nil)
            {
                UserHandler.sharedInstance.userData = success.data
                self.prefs.set(email, forKey: "useremail")
                UserDefaults.standard.synchronize()
                self.prefs.set(password, forKey: "password")
                UserDefaults.standard.synchronize()
                self.stopAnimating()
                self.loginUser()
            }
            else
            {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Error".localized, message: success.message, okAction: {
                    _ = self.textFieldPassword.becomeFirstResponder()
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
    func convertDateFormatter(date: String) -> String
    {
        print(date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" //"MM-dd-yyyy HH:mm"// <- this is chnage format now //this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let newDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let timeStamp = dateFormatter.string(from: newDate!)
        
        return timeStamp
    }
//    func loginUser() {
//        let homeNavigationController = UIStoryboard.mainStoryboard.instantiateVC(HomeNavigationController.self)!
//        let leftViewController: LeftViewController = {
//            return UIStoryboard.mainStoryboard.instantiateVC(LeftViewController.self)!
//        }()
//        let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
//        let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
//        homeTabController.navigationDrawer = homeController
//        leftViewController.delegate = homeTabController
//
//        let navigationController = UINavigationController(rootViewController: homeController)
//        navigationController.navigationBar.isHidden = true
//
//        self.present(navigationController, animated: false, completion: nil)
//    }
    
    func loginUser() {
        
        
        let homeNavigationController = UIStoryboard.mainStoryboard.instantiateVC(HomeNavigationController.self)!
        let leftViewController: LeftViewController = {
            return UIStoryboard.mainStoryboard.instantiateVC(LeftViewController.self)!
        }()
        if lang == "ar" {
            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: nil, rightViewController: leftViewController)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: false, completion: nil)
        }
        else {
            let homeController = AppNavigationDrawerController(rootViewController: homeNavigationController, leftViewController: leftViewController, rightViewController: nil)
            let homeTabController = homeNavigationController.rootViewController as! MainHomeTabController
            homeTabController.navigationDrawer = homeController
            leftViewController.delegate = homeTabController
            
            let navigationController = UINavigationController(rootViewController: homeController)
            navigationController.navigationBar.isHidden = true
            self.present(navigationController, animated: false, completion: nil)
        }
        
        
    }
    
    
    
}


class TextField: UITextField {
    
//    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0);
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
}
extension UITextField {
    
    
    
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


