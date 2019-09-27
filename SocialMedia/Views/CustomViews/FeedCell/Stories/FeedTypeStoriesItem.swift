//
//  FeedCellType1.swift
//  SocialMedia
//
//  Created by Muhammad Umer on 15/08/2017.
//  Copyright © 2017 My Technology. All rights reserved.
//

import Foundation
import UIKit
import IGListKit

extension FeedTypeStoriesObject: Equatable {
    static public func ==(rhs: FeedTypeStoriesObject, lhs: FeedTypeStoriesObject) -> Bool {
        return lhs.id == rhs.id
    }
}

class FeedTypeStoriesObject: ListDiffable {
    var id = 0
    
    func diffIdentifier() -> NSObjectProtocol {
        return NSNumber(value: id)
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? FeedTypeStoriesObject else {
            return false
        }
        
        if id != object.id {
            return false
        }
        
        return self == object
    }
}

class FeedTypeStoriesItem: UICollectionViewCell, Xibable {
    @IBOutlet var collectionViewContainer: UIView!
    
    @IBOutlet var collectionView: UICollectionView! {
        didSet {
            collectionView.register(FeedTypeStotiesItemCollectionViewCell.self, forCellWithReuseIdentifier: FeedTypeStotiesItemCollectionViewCell.className)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
        }
    }
    
    var stories = [StoriesData]() //ModelGenerator.generateStoryModel()
    
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
        self.getStories()
    }
    func getStories (){
        FeedsHandler.getStories(success: { (successResponse) in
            print(successResponse)
            if successResponse.statusCode == 200 {
                self.stories = successResponse.data
                if self.stories.count > 0 {
                    self.collectionView.reloadData()
                }
            }
        }) { (errorResponse) in
            print(errorResponse!)
        }
    }
}

extension FeedTypeStoriesItem: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTypeStotiesItemCollectionViewCell.className, for: indexPath) as! FeedTypeStotiesItemCollectionViewCell
        let objUser = UserHandler.sharedInstance.userData

        if indexPath.section == 0 {
            cell.buttonAddStory.isHidden = false
            cell.labelUserName.text = objUser?.fullName
        } else {
            if stories.count > 0 {
                let objStory = stories[indexPath.row]
                if objStory.userId != objUser?.id{
                    cell.buttonAddStory.isHidden = true
                    cell.labelUserName.text = objStory.user.fullName
                }
            }
        }
        return cell
    }
}

struct StoryModel {
    var name: String
}
