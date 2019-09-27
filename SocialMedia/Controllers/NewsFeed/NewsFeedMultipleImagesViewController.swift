//
//  NewsFeedMultipleImagesViewController.swift
//  SocialMedia
//
//  Created by My Technology on 22/01/2018.
//  Copyright © 2018 My Technology. All rights reserved.
//

import UIKit
import ImageScrollView

class NewsFeedMultipleImagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    
    
    var newFeedData : NewsFeedData?
    var timelineFeedData : TimelineData?

    @IBOutlet weak var oltShowImageForZoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.title = "Pictures"
        tableview.separatorStyle = .none
        tableview.tableFooterView = UIView(frame: CGRect.zero)
        tableview.delegate = self
        tableview.dataSource = self
        
        self.title = "Post Detail".localized
        
        addBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (newFeedData != nil) {
            if let _ = newFeedData ,let _data = newFeedData?.postAttachmentData {
                return _data.count
            }
        } else {
            if let _ = timelineFeedData ,let _data = timelineFeedData?.postAttachmentData {
                return _data.count
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellFeedMultipleImagesDeail", for: indexPath) as! CellFeedMultipleImagesDeail
        
        cell.selectionStyle = .none
        
        var url : String = ""
        if (newFeedData != nil) {
            url = (newFeedData?.postAttachmentData[indexPath.row].path)!
        } else {
            url = (timelineFeedData?.postAttachmentData[indexPath.row].path)!
        }
        
        cell.imgDetailImage.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
        
//        let imageeView = UIImageView()
//        imageeView.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
//
        
        
        cell.imgDetailImage.sd_setShowActivityIndicatorView(true)
        cell.imgDetailImage.sd_setIndicatorStyle(.gray)
        //cell.imgDetailImage.contentMode = .scaleAspectFill
        cell.imgDetailImage.clipsToBounds = true
       
        
        cell.imgScrollView.display(image: cell.imgDetailImage.image!)
        cell.imgScrollView.sd_setShowActivityIndicatorView(true)
        cell.imgScrollView.sd_setIndicatorStyle(.gray)
        cell.imgScrollView.clipsToBounds = true
        
        
        
        cell.oltDownloadImage.tag = indexPath.row
        cell.oltDownloadImage.addTarget(self, action: #selector(self.btnDownloadImage(_:)), for: .touchUpInside)
        cell.showImageForZoomButton.tag = indexPath.row
        cell.showImageForZoomButton.addTarget(self, action: #selector(self.btnShowImageForZoom(_:)), for: .touchUpInside)
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        //getting the index path of selected row
//        let indexPath = tableView.indexPathForSelectedRow
//        let currentCell = tableView.cellForRow(at: indexPath!)! as UITableViewCell
//      // currentCell.imageView?.image
//
//        let zoomableImageDisplayViewController =  storyboard?.instantiateViewController(withIdentifier: DisplayZoomableImageViewController.className) as! DisplayZoomableImageViewController
//        zoomableImageDisplayViewController.imageView.image = currentCell.imageView?.image
//        present(zoomableImageDisplayViewController, animated: false, completion: nil)
       
    }
    
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenBounds = UIScreen.main.bounds
        let height = screenBounds.height
        return height
    }
    
    
    @objc func btnShowImageForZoom(_ sender : UIButton) {
        var url : String = ""
        if (newFeedData != nil) {
            url = (newFeedData?.postAttachmentData[sender.tag].path)!
        } else {
            url = (timelineFeedData?.postAttachmentData[sender.tag].path)!
        }
        
        let zoomableImageDisplayViewController =  storyboard?.instantiateViewController(withIdentifier: DisplayZoomableImageViewController.className) as! DisplayZoomableImageViewController
       // zoomableImageDisplayViewController.imageView.sd_setImage(with: URL(string: String(describing: url)), placeholderImage: UIImage(named: "placeHolderGenral"))
        
       zoomableImageDisplayViewController.urlString = url

        
        present(zoomableImageDisplayViewController, animated: false, completion: nil)
        
    }
    
    
    @objc func btnDownloadImage(_ sender : UIButton) {
        var url : String = ""
        if (newFeedData != nil) {
            url = (newFeedData?.postAttachmentData[sender.tag].path)!
        } else {
            url = (timelineFeedData?.postAttachmentData[sender.tag].path)!
        }
        
        let imageView : UIImageView = UIImageView()
        imageView.sd_setImage(with: URL(string: String(describing: url)), completed: { (img, error , cacheType , imgUrl) in
            if img != nil {
                UIImageWriteToSavedPhotosAlbum(img!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        })
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error".localized, message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!".localized, message: "Picture has been saved to your photos".localized, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK".localized, style: .default))
            present(ac, animated: true)
        }
    }
}
