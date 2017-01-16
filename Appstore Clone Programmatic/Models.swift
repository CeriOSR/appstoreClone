//
//  Models.swift
//  Appstore Clone Programmatic
//
//  Created by Rey Cerio on 2017-01-14.
//  Copyright © 2017 CeriOS. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    //this is called by the AppCategory.fetchFeaturedApps()
    override func setValue(_ value: Any?, forKey key: String) {
        
        //if key is categories then JSON the data under it
        if key == "categories" {
            
            appCategories = [AppCategory]()
            for dict in value as! [[String: AnyObject]] {
                
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
        //if key is banner then get banner data
        } else  if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: AnyObject])
            
        //else just do generic setValue
        }else {
        
            super.setValue(value, forKey: key)
        }
    }
}

//this is used to fill out the base collectionView that scrolls up and down
class AppCategory: NSObject {
    var name: String?
    var apps: [App]?
    var type: String?
    
    //we dont want the [App] to contain a dictionary because dictionary might not return the right key values. under "categories" is another dictionary called "apps" so when we hit that dictionary, thats when we assign the values
    override func setValue(_ value: Any?, forKey key: String) {
        //so when we hit the "apps" category in the json site
        if key == "apps" {
            //we assign the values in it to the parameters of App class model
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
                
            }
        }else{
            super.setValue(value, forKey: key)
        }
    }
    
    //we need to call a completionHandler to handle the parsed JSON, it needs an @escaping because its should not be inside the do/try/catch but we have no choice
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApps) -> ()) {
        
        let urlString = "http://www.statsallday.com/appstore/featured"
        
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            
            if error != nil {
                
                print(error ?? "Error")
                return
            }
            
            do {
                //in swift 3, you have to downcast to specif type that will match your loop
                let json = try (JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject])
                
                //banner categories
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeys(json)
    
                //dispatchQueue to bring us back to mainthread to update the CV, URLSession.dataTask is executed in the background thread
                DispatchQueue.main.async(execute: { 
                    completionHandler(featuredApps)
                })
                
            } catch let err {
                print(err)
            }
        }.resume()
    
    }
    
    //static func is a method that only works inside this class
    static func sampleAppCategories() -> [AppCategory] {
        
        //MAGES
        let mageCategory = AppCategory()
        mageCategory.name = "Mages"
        
        var allMagesCategory = [App]()
        
        //logic assigning values using MVC to build 1 hero
        let celesteHero = App()
        celesteHero.name = "Celeste"
        celesteHero.imageName = "celeste"
        celesteHero.category = "Mage"
        celesteHero.price = NSNumber(floatLiteral: 3.99)
        
        allMagesCategory.append(celesteHero)
        
        //adding the item to the category
        mageCategory.apps = allMagesCategory
        
        
        //WARRIORS
        let warriorCategory = AppCategory()
        warriorCategory.name = "Warriors"
        
        //building an array to hold all the warriors in the category
        var allWarriorsCategory = [App]()
        //building the hero
        let glaiveHero = App()
        glaiveHero.name = "Glaive"
        glaiveHero.imageName = "glaive"
        glaiveHero.category = "Warrior"
        glaiveHero.price = NSNumber(floatLiteral: 2.99)
        //append the hero into the [Hero]
        allWarriorsCategory.append(glaiveHero)
        
        //assigning [allWarriorsCategory] into the hero parameter of HeroCategory class
        warriorCategory.apps = allWarriorsCategory
        
        
        return [mageCategory, warriorCategory]

    }
}

//this is model is used to fill out the collectionView inside the base CV that scrolls left to right
class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
}
