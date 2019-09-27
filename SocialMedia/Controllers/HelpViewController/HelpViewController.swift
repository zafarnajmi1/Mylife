//
//  HelpViewController.swift
//  SocialMedia
//
//  Created by Apple PC on 04/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import KMPlaceholderTextView

extension SegueIdentifiable {
    static var helpViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: HelpViewController.className)
    }
}

class HelpViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,NVActivityIndicatorViewable {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    weak var dataEntryCell: helpFrequentlyAskQyestions!
    
//    var sections = [ExpandableSection(name: "Help Center", items: ["Privacy and Safety", "", "Item1Item1", "Item1Item1"], collapsed: false),
//                    ExpandableSection(name: "Section", items: ["Item1", "Item1Item1", "Item1Item1"], collapsed: false)
   
//    var sections = [ExpandableSection(name: "Help Center", items: ["Privacy and Safety", "Using My Life", "Manage Your Account", "Policies and Reporting"], collapsed: false)
//    ]
    
    var sections = [ExpandableSection]()

    var dataArray = [FaqsData]()
    
    
    @IBOutlet var headerTextView: UITextView!
    
//    @IBOutlet var sendBtn: UIButton!
//    @IBOutlet var leaveUsMsgLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = tableView.rowHeight
        
       tableView.register(UINib(nibName: "FAQCell", bundle: nil), forCellReuseIdentifier: "FAQCell")
        tableView.register(UINib(nibName: "FAQOpenCell", bundle: nil), forCellReuseIdentifier: "FAQOpenCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
        self.title = "Help".localized
        addBackButton()
        headerTextView.text = "My life is an amazing social media application for people who love to celebrate their life in fun and collaboration. Have unique experience of getting friends and people and enjoy the aspects of a better social world. We provide scheduling your friends birthday’s also your own posts.".localized
        self.getAllFaqs()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
       
//        if dataArray.count > 0{
//            return dataArray.count + 1
//        }
//        else
//        {
            return 1
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
//        return 1 //
        if dataArray.count > 0{
            return dataArray.count + 1
        }
        return 1 //sections[section].items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        if indexPath.row < dataArray.count && dataArray.count > 0 {
            let objFaq = dataArray[indexPath.row]
            
            if objFaq.isOpen{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FAQOpenCell", for: indexPath) as! FAQOpenCell
                cell.loadCell(faq: objFaq)
                return cell
            }
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! FAQCell
                cell.loadCell(faq: objFaq)
                return cell
            }
            
            
            
            
            
            
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let objFaq = dataArray[indexPath.row]
////        title = objFaq.translation.question!
//        print(objFaq.translation.answer)
//        if(lang == "en"){
//
//        cell.textLabel?.text = objFaq.translation.answer //sections[indexPath.section].items
//        cell.textLabel?.font = UIFont.thin
//        cell.textLabel?.textColor = UIColor.darkGray
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.textAlignment = .left
//
//        cell.selectionStyle = .none
//        }
//        else
//        {
//
//                cell.textLabel?.text = objFaq.translation.answer //sections[indexPath.section].items
//                cell.textLabel?.font = UIFont.thin
//                cell.textLabel?.textColor = UIColor.darkGray
//                cell.textLabel?.numberOfLines = 0
//
//
//               cell.textLabel?.textAlignment = .right
//                cell.selectionStyle = .none
//            }
//       // cell.imageView?.image = UIImage(named: "FAQ")
//            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: helpFrequentlyAskQyestions.className, for: indexPath) as! helpFrequentlyAskQyestions
            
            cell.delegate = self as sendFAQ
            dataEntryCell = cell
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < dataArray.count {
            dataArray[indexPath.row].isOpen = !dataArray[indexPath.row].isOpen
            tableView.beginUpdates()
            tableView.reloadData()
            tableView.endUpdates()
        }
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//
//        if section < dataArray.count{
//
//             return 50
//        }else{
//            return 0
//        }
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section < dataArray.count{
//            if dataArray[indexPath.section].isOpen {
//                return tableView.estimatedRowHeight
//            }
//            else {
//                return 0
//            }
//        }else{
//            return 250
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        if section < dataArray.count{
//
//                let header = ExpandableHeaderView()
//           // header.appearance().semanticContentAttribute = .forceRightToLeft
//                header.section = section
//               // header.newimage?.set(image: UIImage(named: "FAQ"), focusOnFaces: false)
//            var vlue: CGFloat = 0.0
//            if(lang == "en"){
//                vlue = 50
//            }
//            else{
//               vlue = 20
//            }
//
//
//                let headerLabel = UILabel(frame: CGRect(x: vlue, y: 0, width:tableView.bounds.size.width - 50, height: tableView.bounds.size.height))
//                 headerLabel.backgroundColor = UIColor.red
//                headerLabel.text = dataArray[section].translation.question!
//                headerLabel.numberOfLines = 0
//            headerLabel.sizeToFit()
//
//            if(lang == "en"){
//                headerLabel.textAlignment = .left
//                headerLabel.frame = CGRect(x: headerLabel.frame.origin.x, y: 10, width: headerLabel.frame.size.width, height: headerLabel.frame.size.height)
//                print(headerLabel.text ?? "")
//
//            }else
//            {
//              headerLabel.textAlignment = .right
//                headerLabel.frame = CGRect(x:headerLabel.frame.origin.x + 50  , y: 10, width: headerLabel.frame.size.width, height: headerLabel.frame.size.height)
//
//            }
////                headerLabel.sizeToFit()
//                header.addSubview(headerLabel)
//
//                header.delegate = self
//
//                let newImageView = UIImageView()
//              if(lang == "en")
//              {
//                newImageView.frame = CGRect(x: 8, y: 10, width: 30, height: 30)
//                newImageView.image = UIImage(named: "FAQ")
//
//                //header.addSubview(UIImageView(image: UIImage(named: "FAQ")))
//                header.addSubview(newImageView)
//            }else
//              {
//                newImageView.frame = CGRect(x: headerLabel.frame.origin.x + 270  , y: 10, width: 30, height: 30)
//                newImageView.image = UIImage(named: "FAQ")
//
//                //header.addSubview(UIImageView(image: UIImage(named: "FAQ")))
//                header.addSubview(newImageView)
//            }
//                return header
//
//        }else{
//            return UIView()
//        }
//
//    }
    
//    func toggleSection(header: ExpandableHeaderView, section: Int) {
//        //sections[section].collapsed = !sections[section].collapsed
//        dataArray[section].isOpen = !dataArray[section].isOpen
//        tableView.beginUpdates()
//
//
//
//        tableView.endUpdates()
//    }
    
    // MARK: - API calls
    func getAllFaqs (){
        UserHandler.getFaqs(success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.dataArray = successResponse.data
                
//                for item in self.dataArray {
//                    let objSection = ExpandableSection.init(name: item.translation.question, items: item.translation.answer, collapsed: false)
//                    self.sections.append(objSection)
//                }
                
                self.tableView.reloadData()
            }
        }) { (errorResponse) in
            
        }
    }

    func addUserInfo(name:String,email:String,description:String)
    {
        self.showLoader()
        let parameters : [String: Any]
        
        parameters  = [
            "name": name,
            "email": email,
            "description": description
        ]
        UserHandler.postFAQ(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200) {
                self.stopAnimating()
                let alertView = AlertView.prepare(title: "Success".localized, message: "Thankyou for contacting us, we'll get back to you soon!".localized, okAction: {
                    
                    self.dataEntryCell.txtName.text = ""
                    self.dataEntryCell.txtEmail.text = ""
                    self.dataEntryCell.textViewQuery.text = ""
                })
                self.present(alertView, animated: true, completion: nil)
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
    // MARK: - Custom
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    func validateForm(name:String,email:String,description:String) {
//        hideKeyboardOnTouch()
        
        if !(name.isEmpty){
            if !(email.isEmpty){
                if email.isValidEmail {
                    
                    if !(description.isEmpty){
                        addUserInfo(name:name,email:email,description:description)
                        
                    }else{
                        let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Your Question".localized, okAction: {
                            
                        })
                        self.present(alertView, animated: true, completion: nil)
                        
                        return
                    }
                }else{
                    let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Valid Email Address".localized, okAction: {
                        
                    })
                    self.present(alertView, animated: true, completion: nil)
    
                }
            }else{
                let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Email Address".localized, okAction: {
                    
                })
                self.present(alertView, animated: true, completion: nil)
                
                return
            }
            
        }else{
            let alertView = AlertView.prepare(title: "Error".localized, message: "Please Enter Your Name".localized, okAction: { 
                
            })
            self.present(alertView, animated: true, completion: nil)
            
            return
        }
    
        

    }
}

struct ExpandableSection {
    var name : String
    var items : String//[String]
    var collapsed : Bool
    
    init (name: String, items: String, collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
    
}

class ExpandableHeaderView : UITableViewHeaderFooterView {
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    var delegate: ExpandableHeaderViewDelegate?
    var section: Int!
    var newimage: UIImageView? {
        didSet{
            self.backgroundView?.addSubview(UIImageView(image: UIImage(named: "FAQ")))
        }
    }
    var title: String? {
        didSet {
            //self.textLabel?.frame = CGRect(x:100,y: 10, width:200, height:40)
           
            self.textLabel?.text = ""
            self.textLabel?.numberOfLines = 0
            if (lang == "en")
            {
                self.textLabel?.textAlignment = .left
                
            }else
            {
               self.textLabel?.textAlignment = .right
            }
            
            
            
            var textLabelFrame = self.textLabel?.frame
            
          
           
        }
    }
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        delegate?.toggleSection(header: self, section: cell.section)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.textLabel?.textColor = UIColor.black.withAlphaComponent(0.8)
        self.textLabel?.font = UIFont.semiBold
        
        self.contentView.backgroundColor = UIColor.white
    }
}
// MARK:- Edit EducationInformation Cell Delegate Extension
extension HelpViewController: sendFAQ {
    func sendInformation(txtName: String, txtEmail: String, txtDescripotion: String) {
        self.validateForm(name:txtName,email:txtEmail,description:txtDescripotion)
    }
    
}

protocol sendFAQ {
    func sendInformation(txtName:String,txtEmail:String,txtDescripotion:String)
}
class helpFrequentlyAskQyestions: UITableViewCell,UITextViewDelegate {
    var delegate: sendFAQ?
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    @IBOutlet var leaveUsMsgLbl: UILabel!
    @IBOutlet var sendBtn: UIButton!
    @IBOutlet weak var txtName: TextField!
    @IBOutlet weak var txtEmail: TextField!
    @IBOutlet weak var textViewQuery: UITextView!{
        didSet{
            textViewQuery.layer.borderWidth = 1
            textViewQuery.layer.borderColor = UIColor.black.cgColor
            
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if lang == "ar" {
            leaveUsMsgLbl.textAlignment = .right
            txtName.textAlignment = .right
            txtEmail.textAlignment = .right
            textViewQuery.textAlignment = .right
            txtName.setRightPaddingPoints(10)
            txtEmail.setRightPaddingPoints(10)
            textViewQuery.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }else
        {
            txtName.setLeftPaddingPoints(10)
            txtEmail.setLeftPaddingPoints(10)
            textViewQuery.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        }
        
        
        txtName.placeholder = "Name".localized
        txtEmail.placeholder = "Email".localized
        sendBtn.setTitle("SEND".localized, for: .normal)
        leaveUsMsgLbl.text = "Leave us a message".localized
        textViewQuery.delegate = self
        textViewQuery.text = "Your query".localized
        textViewQuery.textColor = UIColor.lightGray
        selectionStyle = .none
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textViewQuery.textColor == UIColor.lightGray {
            textViewQuery.text = ""
            textViewQuery.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textViewQuery.text == "" {
            textViewQuery.contentInset = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
            textViewQuery.text = "Your query".localized
            textViewQuery.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func actionSend(_ sender: Any) {
        delegate?.sendInformation(txtName:(txtName.text)!,txtEmail:(txtEmail.text)!,txtDescripotion:(textViewQuery.text)!)
        
    }
    
    
}

