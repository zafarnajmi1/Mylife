//
//  ProfileHeaderView.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit
import Popover

extension ProfileHeaderViewObject: Equatable {
    static public func ==(rhs: ProfileHeaderViewObject, lhs: ProfileHeaderViewObject) -> Bool {
        return lhs.id == rhs.id
    }
}

class ProfileHeaderViewObject: ListDiffable {
    var id = 0
    
    //
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: id)
    }
    //
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? ProfileHeaderViewObject else {
            return false
        }
        
        if id != object.id {
            return false
        }
        return self == object
    }
}


protocol ProfileHeaderDelegate {
    func openActivityLogController()
    func openAboutController()
    func openFriendsController()
    func openEditProfileController()
    func openMyFollowingsViewController()
    func openFollowersViewController()
}

class ProfileHeaderView: UICollectionViewCell, Xibable {
    let user_id = 0
    var delegate: ProfileHeaderDelegate?
    
    fileprivate var popover: Popover!
    
    fileprivate var popoverMenu = ["Followers", "My Followings"]
    fileprivate var popoverMenu2 = ["Follow", "Un Follow"]
    
    @IBOutlet var imageViewBanner: UIImageView!
    
    @IBOutlet var imageViewProfile: UIImageView! {
        didSet {
            imageViewProfile.round()
        }
    }
    
    @IBOutlet var textViewName: UILabel!
    
    @IBOutlet var buttonActivityLog: UIButton!
    
    @IBOutlet var buttonAbout: UIButton!
    
    @IBOutlet var buttonFriends: UIButton!
    
    @IBOutlet var buttonMenu: UIButton!
    
    
    @IBAction func onButtonActivityLogClicked(_ sender: UIButton) {
        delegate?.openActivityLogController()
        
    }
    
    @IBAction func onButtonAboutClicked(_ sender: UIButton) {
        delegate?.openAboutController()
    }
    
    @IBAction func onButtonShowfriendsClicked(_ sender: UIButton) {
        delegate?.openFriendsController()
    }
    
    
    @IBAction func onButtonMenuClicked(_ sender: UIButton) {
       // showPopover()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }
}

//MARK: Custom
/*
extension ProfileHeaderView {
    
    func showPopover() {
        var width = self.frame.width / 2
        var height: CGFloat = 95
        
        if UIDevice.isiPhone {
            width -= 20
        }
        
        if UIDevice.isiPad {
            height = 200
        }
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        
//        String(describing: str)
        if  String(describing: UserDefaults.standard.value(forKey: "userlocalId")!) != "-1"
        {
            let popoverOptions = [
                .type(.up),
                .animationIn(0.5),
                .animationOut(0.1),
                .sideEdge(4),
                .blackOverlayColor(UIColor(white: 0.0, alpha: 0.4))
                ] as [PopoverOption]
            
            popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
            popover.show(tableView, fromView: self.buttonMenu)
        }
        else
        {
            let popoverOptions = [
                .type(.up),
                .animationIn(0.5),
                .animationOut(0.1),
                .sideEdge(4),
                .blackOverlayColor(UIColor(white: 0.0, alpha: 0.4))
                ] as [PopoverOption]
            
            popover = Popover(options: popoverOptions, showHandler: nil, dismissHandler: nil)
            popover.show(tableView, fromView: self.buttonMenu)
        }
    }
    
}

extension ProfileHeaderView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popover.dismiss()
        
        let index = indexPath.row
        
        if index == 0 {
            delegate?.openFollowersViewController()
        } else if index == 1 {
            delegate?.openMyFollowingsViewController()
        }
    }
}

extension ProfileHeaderView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if String(describing: UserDefaults.standard.value(forKey: "userlocalId")!) != "-1"
        {
            return self.popoverMenu.count
        }
        else
        {
            return self.popoverMenu2.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        if  String(describing: UserDefaults.standard.value(forKey: "userlocalId")!) != "-1"
        {
        
            cell.textLabel?.text = self.popoverMenu[indexPath.row]
        }
        else{
            cell.textLabel?.text = self.popoverMenu2[indexPath.row]
        }
        cell.textLabel?.font = UIFont.thin(ofSize: 14)
        cell.selectionStyle = .none
        
        return cell
    }
    
    
}

*/
