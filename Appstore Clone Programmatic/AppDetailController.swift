//
//  AppDetailController.swift
//  Appstore Clone Programmatic
//
//  Created by Rey Cerio on 2017-01-18.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet{
            navigationItem.title = app?.name
        }
        
    }
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        //registering the header cell
        collectionView?.register(appDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    //instantiating a header cell, needed to show header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! appDetailHeader
        
        //set the values of app to header.app to set the the didSet{} closure
        header.app = app
        return header
    }
    
    //Size of header, needs UICollectionViewDelegateFlowLayout, needed to show header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class appDetailHeader: BaseCell {
    
    var app: App?{
        
        didSet{
            if let imageName = app?.imageName{
                imageView.image = UIImage(named: imageName)

            }
        }
    }
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
  
    override func setupViews() {
        super.setupViews()
        
//        imageView.backgroundColor = .yellow
        addSubview(imageView)
        
        //addConstraintS
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-14-[v0(100)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0" : imageView]))

    }
    
}

//base cell will be used multiple times because we'll have different variation of cells.
class BaseCell: UICollectionViewCell {
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        
    }
}
