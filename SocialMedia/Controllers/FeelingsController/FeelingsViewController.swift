//
//  FeelingsViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 10/26/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class FeelingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NVActivityIndicatorViewable {

    @IBOutlet weak var viewSearch: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var dataArray = [FeelingsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "FeelingsCell", bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: "FeelingsCell")
        
        // Do any additional setup after loading the view.
        self.setupViews()
        self.showLoader()
        self.getFeelings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Custom
    func setupViews (){
        self.title = "Feelings".localized
        self.view.backgroundColor = UIColor.groupTableViewBackground
      //  self.viewSearch.backgroundColor = UIColor.groupTableViewBackground
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.separatorStyle = .none
        self.tblView.backgroundColor = UIColor.groupTableViewBackground
        
        //self.viewSearch.delegate = self
        addBackButton()
        
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }
    
    func showAlrt (message: String){
        let alert = CommonMethods.showBasicAlert(message: message)
        self.present(alert, animated: true,completion: nil)
    }

    // MARK: - UITableViewDelegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let feelingsCell = tableView.dequeueReusableCell(withIdentifier: "FeelingsCell", for: indexPath) as? FeelingsCell {
            feelingsCell.selectionStyle = .none
            feelingsCell.backgroundColor = UIColor.groupTableViewBackground
            
            let objFeelings = dataArray[indexPath.row]
            if let feelingImage = objFeelings.emoji{
                feelingsCell.imgFeeling.sd_setImage(with: URL(string: feelingImage), placeholderImage: UIImage(named: ""))
                feelingsCell.imgFeeling.sd_setShowActivityIndicatorView(true)
                feelingsCell.imgFeeling.sd_setIndicatorStyle(.gray)
                feelingsCell.imgFeeling.contentMode = .scaleAspectFill
                feelingsCell.imgFeeling.clipsToBounds = true
            }
            feelingsCell.lblTitle.text = objFeelings.translation.title
            
            return feelingsCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objFeelings = dataArray[indexPath.row]
        FeedsHandler.sharedInstance.objFeeling = objFeelings
        FeedsHandler.sharedInstance.isFeelingSelected = true
        
        onBackButtonClciked()
    }
    
    // MARK: - API Calls
    func getFeelings (){
        FeedsHandler.getFeelings(success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.dataArray = successResponse.data
                if self.dataArray.count > 0{
                    self.tblView.reloadData()
                    self.stopAnimating()
                }else{
                    self.stopAnimating()
                    self.showAlrt(message: successResponse.message)
                }
            }
        }) { (errorResponse) in
            print(errorResponse)
            self.stopAnimating()
            self.showAlrt(message: (errorResponse?.message)!)
        }
    }

}
