//
//  ScreenShotCell.swift
//  Appstore Clone Programmatic
//
//  Created by Rey Cerio on 2017-01-21.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

//custom cell for the 2nd base CV in appdetail controller
class ScreenShotCell: BaseCell, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //when we get our screenshot array from appDetailController, we set the CV and reload the table
    var app: App? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    private let cellId = "cellId"
    //declaring a CV
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()
    
    let borderLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
    
    //BaseCell has the setupViews()
    override func setupViews() {
        super.setupViews()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        //implementing a CF within a CV
        addSubview(collectionView)
        addSubview(borderLine)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0][v1(0.5)]|", views: collectionView, borderLine)
        
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: borderLine)
        
        //registering a cell
        collectionView.register(ScreenShotImageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = app?.screenshots?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenShotImageCell
        
        if let image = app?.screenshots?[indexPath.item] {
            
            cell.imageView.image = UIImage(named: image)

        }
        
        
        return cell
    }
    //height of the ScreenShotImageCell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 240, height: frame.height - 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
}
//custom cell used for the CV within the base CV in AppDetailController
private class ScreenShotImageCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .green
        iv.layer.masksToBounds = true //put a space between images
        return iv
    }()
    
    fileprivate override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: imageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: imageView)
    }
    
}



