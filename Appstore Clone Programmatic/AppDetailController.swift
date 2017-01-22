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
            //if you dont implement this, this will go in an infinite loop and do a memoryleak because we are also setting self.app = appDetail in this closure. So once we get our screenshots array we stop the loop.
            if app?.screenshots != nil {
                return
            }
            
            if let id = app?.id{
                let urlString = "http://www.statsallday.com/appstore/appdetail?id=\(id)"
                
                URLSession.shared.dataTask(with: URL(string: urlString)! , completionHandler: { (data, response, error) in
                    if error != nil {
                        
                        print(error ?? "Error")
                        return
                    }
                    
                    do {
                        //in swift 3, you have to downcast to specify type that will match your loop
                        let json = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject])
                        
                        let appDetail = App()
                        appDetail.setValuesForKeys(json)
                        
                        self.app = appDetail
                        
                        //dispatchQueue to bring us back to mainthread to update the CV, URLSession.dataTask is executed in the background thread
                        DispatchQueue.main.async(execute: {
                            self.collectionView?.reloadData()
                        })
                        
                    } catch let err {
                        print(err)
                    }
                    
                    
                }).resume()  //fire the session after the completion handler is executed
            }
        }
        
    }
    
    private let cellId = "cellId"
    private let headerId = "headerId"
    private let descriptionCellId = "descriptionCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        //registering the header cell
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView?.register(ScreenShotCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            
            //attributedText because the descriptionAttributedText() returns a NSAttributedString
            cell.textView.attributedText = descriptionAttributedText()
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenShotCell
        
        cell.app = app
        
        return cell
    }
    
    //adding attributes to the description string like FontSize, FontColor, Bold, etc etc
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description:\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]) // \n to add a space
        
        //adding spacing between the Description header and the paragraph
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        //adding a different attribute to the JSON extracted string
        if let descriptionText = app?.desc {
            attributedText.append(NSMutableAttributedString(string: descriptionText, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 11), NSForegroundColorAttributeName: UIColor.darkGray])
)         }
        return attributedText

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000) //dummy size, height is large and arbitrary. this is just for basis
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)  //basis for drawing of a imaginary rectangle basing on how big the paragraph is
            
            //this bounding is the drawing of an imaginary rect around the paragraph that calculates the size
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width: view.frame.width, height: rect.height + 30) //use the height of the imaginary rect + 30 because it cuts off the paragraph
        }
        
        
        return CGSize(width: view.frame.width, height: 200)
    }
    
    //instantiating a header cell, needed to show header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        
        //set the values of app to header.app to set the the didSet{} closure
        header.app = app
        return header
    }
    
    //Size of header, needs UICollectionViewDelegateFlowLayout, needed to show header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class AppDetailHeader: BaseCell {
    
    var app: App?{
        
        didSet{
            if let imageName = app?.imageName{
                imageView.image = UIImage(named: imageName)
                
            }
            nameLabel.text = app?.name
            if let appPrice = app?.price {
               buyButton.setTitle("$\(appPrice.stringValue)", for: .normal)
            }
        }
    }
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = .gray
        sc.selectedSegmentIndex = 0
        return sc
    
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let borderLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()
  
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(borderLine)
        
        //addConstraintS
        addConstraintsWithFormat(format: "H:|-14-[v0(90)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(90)]", views: imageView)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(34)]-8-|", views: segmentedControl)
        
        addConstraintsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        addConstraintsWithFormat(format: "V:[v0(32)]-56-|", views: buyButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: borderLine)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: borderLine)

    }
    
}

class AppDetailDescriptionCell: BaseCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "Sample"
        return tv
    }()
    
    let borderLine: UIView = {
        let line = UIView()
        line.backgroundColor = .gray
        return line
    }()

    override func setupViews() {
        super.setupViews()
        
        addSubview(textView)
        addSubview(borderLine)
        
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: textView)
        addConstraintsWithFormat(format: "H:|-14-[v0]|", views: borderLine)
        
        addConstraintsWithFormat(format: "V:|-4-[v0]-4-[v1(0.5)]|", views: textView, borderLine)
        
    }
}

//shorten the constraints, COPY AND PASTE THIS WHEN USING addConstraints withVisualFormat
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        //making the views dictionary
        var viewsDictionary = [String: UIView]()
        //loop through the views and assign a index to the views then stick that index to the string as the viewID
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        //adding the parameters into the addConstraints() method
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
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
