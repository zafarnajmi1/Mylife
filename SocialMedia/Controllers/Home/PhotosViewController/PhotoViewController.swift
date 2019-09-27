/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material

class PhotoViewController: UIViewController {
    fileprivate var collectionView: CollectionView!
    
    var dataSourceItems = [DataSourceItem]()
    
    fileprivate let photos = [
        "photo_1",
        "photo_2",
        "photo_3",
        "photo_4",
    ]
    
    fileprivate var fabButton: FABButton!
    
    fileprivate var index: Int
    
    public required init?(coder aDecoder: NSCoder) {
        index = 0
        super.init(coder: aDecoder)
    }
    
    public init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        edgesForExtendedLayout = .top
        
        //AppDelegate.appDelegate.transparentNavigationBar()
        
        navigationController?.presentTransparentNavigationBar()
        
//        if let navigationbar = self.navigationController?.navigationBar {
//        
//        navigationbar.setBackgroundImage(UIImage(), for: .default)
//        navigationbar.shadowImage = UIImage()
//        navigationbar.backgroundColor = .clear
//        navigationbar.isTranslucent = false
//        navigationbar.tintColor = UIColor.white
//        
//        var fontSize: CGFloat = 18
//        
//        if UIDevice.isiPad {
//            fontSize = 22
//        }
//        
//        navigationbar.titleTextAttributes = [NSFontAttributeName: UIFont(name: Constants.Font.semiBold, size: fontSize)!, NSForegroundColorAttributeName : UIColor.white]
//        navigationbar.barTintColor = .clear
//            
//        }
        //transparetNavigationbarWithoutExtensing()
        
        navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.6)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        
        addBackButton()
        edgesForExtendedLayout = .top
        preparePhotos()
        prepareCollectionView()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = .primary

        //defaultNavigationbar()
    }
}

extension PhotoViewController {
    fileprivate func preparePhotos() {
        photos.forEach { [weak self, w = view.bounds.width] in
            guard let image = UIImage(named: $0) else {
                return
            }
            
            self?.dataSourceItems.append(DataSourceItem(data: image, width: w))
        }
    }
    
    fileprivate func prepareCollectionView() {
        collectionView = CollectionView()
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(ViewPostItemCell.self, forCellWithReuseIdentifier: ViewPostItemCell.className)

        view.layout(collectionView).center().width(view.bounds.width).height(view.bounds.height)
        
        collectionView.scrollRectToVisible(CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height), animated: false)
    }
}

extension PhotoViewController: CollectionViewDataSource {
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
        
        guard let image = dataSourceItems[indexPath.item].data as? UIImage else {
                    return cell
        }
        
        cell.tag = indexPath.item
        cell.addImageViewWith(image: image)
        
        return cell
    }
}

extension PhotoViewController: CollectionViewDelegate {

}
