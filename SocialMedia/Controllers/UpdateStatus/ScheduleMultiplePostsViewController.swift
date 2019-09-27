//
//  ScheduleMultiplePostsViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/15/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import NVActivityIndicatorView

class ScheduleMultiplePostsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {
    

    @IBOutlet var scdulePostTitle: UILabel!
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var doneBtn: UIButton!
    var arrayOfDates = [String]()
    var arrayOfDatesInInteger = [Int]()
    @IBOutlet weak var multipleScheduleTimesTableView: UITableView!
    let lang = UserDefaults.standard.string(forKey: "i18n_language")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scdulePostTitle.text = "Schedule Post".localized
        doneBtn.setTitle("Done".localized, for: .normal)
        if lang == "ar" {
            
            backButton.setImage(#imageLiteral(resourceName: "Ar-back"), for: .normal)
        }
        else {
            backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        
        let userDefaults = UserDefaults.standard
        let newarrayOfDates =  userDefaults.value(forKey: "scheduledDates") as? [String] ?? [String]()
        if  newarrayOfDates.count != 0{
            arrayOfDates=newarrayOfDates
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func addButtonAction(_ sender: Any) {
        print("add button pressed")
        showDatePicker()
    }
    
    @IBAction func doneButtonAction(_ sender: Any) {
         print("done button pressed")
        self.showLoader()
        MySchedulesViewController.isCameFromMySchedulePostViewController=false
        let userDefaults = UserDefaults.standard
        userDefaults.set(arrayOfDatesInInteger, forKey: "scheduledIntegerDates")
        userDefaults.set(arrayOfDates, forKey: "scheduledDates")
        // print("seleted date string",stringOfDates)
        self.dismiss(animated: true) {
            self.stopAnimating()
        }
//        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        print("back button pressed")
        self.dismiss(animated: true, completion: nil)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfDates.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayOfDates.count == 0{
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 0
            noDataLabel.text          = "No Schedules Added".localized + "\n" + "To add a new schedule please click on plus icon".localized
            noDataLabel.textColor     = UIColor.darkGray //(red:172/255,green:172/255,blue:172/255, alpha: 1)
            noDataLabel.font = CommonMethods.getFontOfSize(size: 16)
            noDataLabel.textAlignment = .center
            
            
            multipleScheduleTimesTableView.backgroundView  = noDataLabel
            
//            let backgroundimageview = UIImageView(frame: CGRect(x: tableView.bounds.size.width/2.5, y: 190, width: 70, height: 70))
//            backgroundimageview.image = #imageLiteral(resourceName: "refresh")
//            multipleScheduleTimesTableView.backgroundView?.addSubview(backgroundimageview)
            multipleScheduleTimesTableView.separatorStyle  = .none
        }else{
            multipleScheduleTimesTableView.backgroundView = nil
        }
        return 1
    }
    
    
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
        //self.stopAnimating()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "schedulemutiplepoststableviewcell", for: indexPath) as! ScheduleMutiplePostsTableViewCell
        cell.selectedDateLabel.text = arrayOfDates[indexPath.row]
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action:#selector(removeButtonAction(sender:)), for: .touchUpInside)
       
        return cell
    }
    
    @objc func removeButtonAction(sender: UIButton){
        arrayOfDates.remove(at: sender.tag)
        self.multipleScheduleTimesTableView.reloadData()
    }
    
    
    
    func showDatePicker() {
        let datePicker = ActionSheetDatePicker(title: "Schedule Post", datePickerMode: UIDatePicker.Mode.dateAndTime, selectedDate: Date(), doneBlock: {
            picker, value, index in
            
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.medium
            dateformatter.timeStyle = DateFormatter.Style.medium
            let date = dateformatter.string(from: value as! Date)
           
            let integerDate =   value as! Date
            let timeInterval = integerDate.milliseconds //.milliseconds  //.timeIntervalSince1970
            
            let myIntegerDate = Int(timeInterval)/1000
            print("mili seconds ...", timeInterval)
            print("integer date ", myIntegerDate)

            //let newseconds = myIntegerDate * 1000
//            print("new sendddd",newseconds)
           

            
            self.arrayOfDatesInInteger.append(myIntegerDate)
            self.arrayOfDates.append(date)
            self.multipleScheduleTimesTableView.reloadData()
            
            return
        }, cancel: { ActionStringCancelBlock in return },
           origin: (self.view as AnyObject).superview!?.superview)
        
        datePicker?.minimumDate = Date()
        
        datePicker?.show()
    }
    
}

