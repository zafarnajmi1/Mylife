//
//  MorePhotosViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 24/10/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit

class MorePhotosViewController: UIViewController {

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    
    let margin: CGFloat = 0
    let cellsPerRow = 2
    var arrayUserPhotoes = [UserPhotoesData]()
    var arryOfImages = [String]()
    var userObj: UserLoginData?
    var objOtherUser : AboutUserData?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userObj = UserHandler.sharedInstance.userData
        addBackButton()
        setupUserPhotoes()
        self.title = "Gallery"
        // Do any additional setup after loading the view.
    }

    //MARK:- APi Calls
    func setupUserPhotoes() {
        
        var uid = Int()
        if objOtherUser?.id != nil {
            uid = (objOtherUser?.id)!
        }else{
            uid = (userObj?.id)!
        }
        
        let parameters : [String: Any] = ["user_id" :  String(uid) ]
        
        UserHandler.getUserPhotoes(params: parameters as NSDictionary , success: { (success) in
            
            if(success.statusCode == 200)
            {
                self.arryOfImages.removeAll()
                self.arrayUserPhotoes = success.data
                
                
                for photoObject in self.arrayUserPhotoes.enumerated(){
                    for nestedPhotoObject in photoObject.element.postAttachmentData.enumerated(){
                        self.arryOfImages.append(nestedPhotoObject.element.path)
                    }
                }
                
                
                
                self.imagesCollectionView.reloadData()
            }
            else
            {
                self.displayAlertMessage(success.message)
            }
        })
        { (error) in
            print("error = ",error!)
            self.displayAlertMessage("Failed to Communicate with Server or Request is taking too much time! Please check your internet connection or wait for server to respond.".localized)
        }
    }

}

// MARK: CollectionView
extension MorePhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    fileprivate func collectionViewContent()
    {
        guard let flowLayout = imagesCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        flowLayout.estimatedItemSize = flowLayout.itemSize // CGSize(width: 50, height: 50)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arryOfImages.count //arrayUserPhotoes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: MorePhotosCell.className, for: indexPath) as! MorePhotosCell
        //let dictionaryArray = arrayUserPhotoes[indexPath.item]
       // print("dictionaryArraysss",dictionaryArray)
    //    cell.imgGallery.sd_setImage(with: URL(string: dictionaryArray.postAttachmentData[0].path), placeholderImage: UIImage(named: "placeHolderGenral"))

        cell.imgGallery.sd_setImage(with: URL(string: arryOfImages[indexPath.row]), placeholderImage: UIImage(named: "placeHolderGenral"))

        cell.imgGallery.sd_setShowActivityIndicatorView(true)
        cell.imgGallery.sd_setIndicatorStyle(.gray)
        cell.imgGallery.contentMode = .scaleAspectFill
        cell.imgGallery.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let objMessage = arryOfImages[indexPath.row]
        print(objMessage)
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "displayImageViewController") as! displayImageViewController
        controller.imageString = objMessage
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
class MorePhotosCell: UICollectionViewCell
{
    @IBOutlet weak var imgGallery: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
