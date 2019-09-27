//
//  ViewPostViewController.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 17/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import Material
import PullToDismiss
import Hero

extension SegueIdentifiable {
    static var viewPostViewController : SegueIdentifier {
        return SegueIdentifier(rawValue: ViewPostViewController.className)
    }
}

class ViewPostViewController: UIViewController {
    @IBOutlet var collectionView: CollectionView!
        
    fileprivate let photos = [
        "photo_1",
        "photo_2",
        "photo_3",
        "photo_4",
        ]
        
    var dataSourceItems = [DataSourceItem]()
    
    fileprivate var index: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = UIColor.black
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        addBackButton(backImage: Icon.cm.clear!.tint(with: UIColor.white)!)
        preparePhotos()
        prepareCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.barTintColor = .primary
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension ViewPostViewController: CollectionViewDataSource {
    
    fileprivate func prepareCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ViewPostItemCell.self, forCellWithReuseIdentifier: ViewPostItemCell.className)
    }
    
    fileprivate func preparePhotos() {
        photos.forEach { [weak self, w = view.bounds.width] in
            guard let image = UIImage(named: $0) else {
                return
            }
            
            self?.dataSourceItems.append(DataSourceItem(data: image, width: w))
        }
    }
    
    @objc
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewPostItemCell.className, for: indexPath)  as! ViewPostItemCell
        cell.socialDelagate = self
        cell.socialTapDelegate = self
        
        guard let image = dataSourceItems[indexPath.item].data as? UIImage else {
            return cell
        }
        
        cell.tag = indexPath.item
        cell.addImageViewWith(image: image)
        
        return cell
    }
}

extension ViewPostViewController: CollectionViewDelegate {
    
}

extension ViewPostViewController {
    func openCommentController() {
        let postControleller = UIStoryboard.mainStoryboard.instantiateViewController(CommentsController.self)!
        postControleller.isHeroEnabled = true
        let controller = UINavigationController(rootViewController: postControleller)
        controller.view.backgroundColor = .white
        controller.isMotionEnabled = true
        
        controller.isHeroEnabled = true
        controller.heroModalAnimationType = .selectBy(presenting: HeroDefaultAnimationType.cover(direction: .up), dismissing: HeroDefaultAnimationType.uncover(direction: .down))

        //controller.motionModalTransitionType = .autoReverse(presenting: .pull(direction: .up))
        
        presentVC(controller)
    }
}

extension ViewPostViewController: SocialButtonDelegate {
    func didTapOnLikeButton() {
        
    }
    
    func didTapOnCommentButton() {
        openCommentController()
    }
    
    func didTapOnShareButton() {
        
    }
}

extension ViewPostViewController: SocialLabelTapDelegate {
    func didTapOnLikeLabel() {
        
    }
    
    func didTapOnCommenLabel() {
        openCommentController()
    }
    
    func didTapOnShareLabel() {
        
    }
}
