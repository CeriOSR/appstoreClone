//
//  CategoryCell.swift
//  Appstore Clone Programmatic
//
//  Created by Rey Cerio on 2017-01-13.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //access to methods in FeaturedAppsController
    var featuredAppsController: FeaturedAppsController?
    
    //reference to the cell.heroCategory use to fill out the Category CollectionView
    var appCategory: AppCategory? {
        didSet{
            
            if let name = appCategory?.name {
                nameLabel.text = name
            }
            //reloading data when this var is set
            appsCollectionView.reloadData()
        }
    }
    
    let cellId = "cellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    //required by init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Mages"
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()
    
    let appsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4) //light gray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    func setupViews(){
        
        backgroundColor = .clear
        
        
        addSubview(appsCollectionView)
        addSubview(dividerLineView)
        addSubview(nameLabel)
        
        appsCollectionView.dataSource = self
        appsCollectionView.delegate = self
        
        appsCollectionView.register(AppCell.self, forCellWithReuseIdentifier: cellId)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-14-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": dividerLineView]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView]))
        
        //vertical constraints for both collectionView and dividerLine
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(30)][v0][v1(0.5)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": appsCollectionView, "v1": dividerLineView, "nameLabel": nameLabel]))
        
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = appCategory?.apps?.count {
            return count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        //assigning values to hero var in cell for didSet{} to kick in
        cell.app = appCategory?.apps?[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: frame.height - 32)
    }
    
    //inset margins
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        //14 pixels on the left and 14 on the right
        return UIEdgeInsetsMake(0, 14, 0, 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let app = appCategory?.apps?[indexPath.item]{
            featuredAppsController?.showAppDetailForApp(app: app)
            
        }
    }
    
}

class AppCell: UICollectionViewCell {
    
    //reference to Hero model used to fill the collectionView when didSet{}
    var app: App? {
        didSet{
            if let name = app?.name {
                nameLabel.text = name
                //this gives an estimated size of the app name, will be used to move the price and categories up and down to get rid of empty space
                let rect = NSString(string: name).boundingRect(with: CGSize(width: frame.width, height: 1000) , options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if rect.height > 20 {
                    //app name used 2 lines
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
                    
                }else{
                    //app name only used 1 line, move up these 2 labels
                    categoryLabel.frame = CGRect(x: 0, y: frame.width + 22, width: frame.width, height: 20)
                    priceLabel.frame = CGRect(x: 0, y: frame.width + 40, width: frame.width, height: 20)
                }
    
                nameLabel.frame = CGRect(x: 0, y: frame.width + 5, width: frame.width, height: 40)
                nameLabel.sizeToFit()   //only as long as the text needed
                
            }
            categoryLabel.text = app?.category ?? ""
            if let price = app?.price {
                priceLabel.text = "$\(price)"
            }else{
                priceLabel.text = ""
            }
            guard let image = app?.imageName else {return}
            imageView.image = UIImage(named: image)
            
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setupViews()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "celeste")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
        
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Celeste the all powerfull"
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 2
        return label
        
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Mage"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
        
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "3.99"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .darkGray
        return label
        
    }()

    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        nameLabel.frame = CGRect(x: 0, y: frame.width + 2, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: frame.width + 38, width: frame.width, height: 20)
        priceLabel.frame = CGRect(x: 0, y: frame.width + 56, width: frame.width, height: 20)
    }
    
}



