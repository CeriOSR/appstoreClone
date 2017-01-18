//
//  FeaturedAppsController.swift
//  Appstore Clone Programmatic
//
//  Created by Rey Cerio on 2017-01-13.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class FeaturedAppsController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    
    private let largeCellId = "largeCellId"
    
    private let headerId = "headerId"
    
    //featured apps var gives us access to banner category
    var featuredApps: FeaturedApps?
    var appCategories: [AppCategory]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Featured Apps"
        
        AppCategory.fetchFeaturedApps { (featuredApps) in
            
            //assigning the value of the appCategories returned by this completionHandler to the [appCategories] in this class to be used to fill the collectionView
            //first one will be called by header cell
            self.featuredApps = featuredApps
            self.appCategories = featuredApps.appCategories
            //this is why we need to be back on main thread
            self.collectionView?.reloadData()
        }
        
        collectionView?.backgroundColor = .white
        
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        //registering a second type of cell
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        //registering a header class as the header for a certain section
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //returning a different type of cell on the 3rd row
        if indexPath.item == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
            
            cell.appCategory = appCategories?[indexPath.item]
            //need to set featuredAppController to self so it doesnt return a nil
            cell.featuredAppsController = self

            return cell

        } else {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            //need to set featuredAppController to self so it doesnt return a nil
            cell.featuredAppsController = self
            return cell

        }
        
        

    }
    
//    func regularOrBannerCell(indexPath: NSIndexPath) {
//        
//        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath as IndexPath)
//
//        
//        //fix the redundant code in cellForItemAtIndexPath into this func
//        //returning a different type of cell on the 3rd row
//        if indexPath.item == 2{
//            cell as! LargeCategoryCell
//            
//            
////            return cell
//            
//        }else{
//        
////        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath as IndexPath) as! CategoryCell
//            cell as! CategoryCell
//        }
//        cell.appCategory = appCategories?[indexPath.item]
//        //set it to self here too for banners
//        cell.featuredAppsController = self
//        
//        return cell
//        
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = appCategories?.count else {return 0}
        return count
    }
    
    //conforms to UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 2 {
            
            return CGSize(width: view.frame.width, height: 160)
        }
        
        return CGSize(width: view.frame.width, height: 230)
    }
    
    //returning the size of the header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    //returning a view for our header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        
        //assigning the very first element of data
        header.appCategory = featuredApps?.bannerCategory
        
        return header
        
    }
    
        
    func showAppDetailForApp(app: App) {
        
        //CVs always needs a layout
        let layout = UICollectionViewFlowLayout()
        //push a new view controller, layout declared as parameter
        let appDetailController = AppDetailController(collectionViewLayout: layout)
        //pass the data via MVC, set the values of app to appDetailController.app to trigger the didSet{}
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)

        
    }
}

//Header, CV inside the first row of base CV (header or banners)
class Header: CategoryCell {
    
    let bannderCellId = "bannerCellId"
    
    //deleting super.setupViews() will get rid of the subviews in the background
    override func setupViews(){
        
        //need to set the delegate and datasource because we are adding the collectionView in here
        appsCollectionView.delegate = self
        appsCollectionView.dataSource = self
        
        appsCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: bannderCellId)
        
        //adding the collectionView and will be fill out by banner Apps
        addSubview(appsCollectionView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannderCellId, for: indexPath) as! AppCell
        
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    
    //getting rid of all the insets or margins by returning all 0s
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    //CVcell class for the secondary CV inside the base
    private class BannerCell: AppCell {
        
        //this here overrides AppCell.setupViews()
        override func setupViews() {
            //setting up the imageView
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            imageView.layer.cornerRadius = 0
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            
        }
    }
    
}

//this is the cell for the third row
class LargeCategoryCell: CategoryCell {
    
    private let largeAppCellId = "largeAppCellId"
    
    //setting up the views of this cell
    override func setupViews() {
        super.setupViews()
        appsCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: "largeAppCellId")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeAppCellId, for: indexPath) as! AppCell
        
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    //CVcell class for the secondary CV inside the base
    private class LargeAppCell: AppCell {
        
        //this here overrides AppCell.setupViews()
        override func setupViews() {
            //setting up the imageView
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[v0]-14-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
            
        }
    }
    
}


