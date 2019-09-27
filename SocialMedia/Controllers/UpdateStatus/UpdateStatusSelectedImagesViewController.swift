//
//  UpdateStatusSelectedImagesViewController.swift
//  SocialMedia
//
//  Created by Imran Jameel on 1/19/18.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit

class UpdateStatusSelectedImagesViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
  
    
    @IBOutlet weak var imagesTableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UpdateStatusController.arrayOfImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateStatusSelectedImagesViewControllerTableViewCell", for: indexPath) as! UpdateStatusSelectedImagesViewControllerTableViewCell
        
        cell.selectedImageView.image = UpdateStatusController.arrayOfImages[indexPath.row]
        cell.deleteButton.tag=indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(UpdateStatusSelectedImagesViewController.deleteButtonPressed(_:)), for:.touchUpInside)
        
        cell.showImageForZoomButton.tag = indexPath.row
        cell.showImageForZoomButton.addTarget(self, action: #selector(btnShowImageForZoom(_:)), for: .touchUpInside)
        
        return cell
        
    }
    
    @objc func btnShowImageForZoom(_ sender : UIButton) {
        var url : String = ""
        print(sender.tag)
        if UpdateStatusController.arrayOfImagesURLS.count != 0{
             url = String(describing: UpdateStatusController.arrayOfImagesURLS[sender.tag])
        }else{
             url = String(describing: EditMySchedulePostViewController.arrayOfImagesURLS[sender.tag])
        }
       
        
        let zoomableImageDisplayViewController =  storyboard?.instantiateViewController(withIdentifier: DisplayZoomableImageViewController.className) as! DisplayZoomableImageViewController
        // zoomableImageDisplayViewController.imageView.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
        
        zoomableImageDisplayViewController.urlString = url
        
        
        present(zoomableImageDisplayViewController, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let height = screenBounds.height
        return height
    
    }
    
    @objc func deleteButtonPressed(_ sender : UIButton) {
        print("Delete button pressed",sender.tag)
        UpdateStatusController.arrayOfImages.remove(at: sender.tag)
        if  EditMySchedulePostViewController.arrayOfImagesURLS.count != 0 {
            EditMySchedulePostViewController.arrayOfImagesURLS.remove(at: sender.tag)
        }
        
        
        if  EditMySchedulePostViewController.arrayOfImages.count != 0 {
            EditMySchedulePostViewController.arrayOfImages = UpdateStatusController.arrayOfImages
        }
       // UpdateStatusController.arrayOfImagesURLS.remove(at: sender.tag)
        imagesTableView.reloadData()
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: MySchedulesViewController.className) as! MySchedulesViewController
        if MySchedulesViewController.isCameFromMySchedulePostViewController==true{
            MySchedulesViewController.isCameFromMySchedulePostViewController=false
            
        }
        if  EditMySchedulePostViewController.arrayOfImages.count != 0 {
            UpdateStatusController.arrayOfImages.removeAll()
            for image in EditMySchedulePostViewController.arrayOfImages{
                UpdateStatusController.arrayOfImages.append(image)
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonAction(_ sender: Any) {
        print("back button pressed")
        self.dismiss(animated: true, completion: nil)
    }
    

}
