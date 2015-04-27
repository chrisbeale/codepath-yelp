//
//  Business.swift
//  Yelp
//
//  Created by Chris Beale on 4/21/15.
//  Copyright (c) 2015 Chris Beale. All rights reserved.
//

import UIKit

class Business: NSObject {
    
    var imageUrl: String?
    var name: String?
    var ratingImageUrl: String?
    var numberOfReviews: NSInteger?
    var address: String?
    var distance: CGFloat?
    var categories: String?
    
    required init(dictionary: NSDictionary) {
        super.init()
        
        println("\(dictionary)")
        
        name = dictionary["name"] as? String
        imageUrl = dictionary["image_url"] as? String
        ratingImageUrl = dictionary["rating_img_url"] as? String
        numberOfReviews = dictionary["review_count"] as? NSInteger

        var fullAddress = ""
        if let streetAddress = dictionary.valueForKeyPath("location.address") as? [String] {
            if streetAddress.count > 0 {
                fullAddress = "\(streetAddress[0]), "
            }
        }
        if let neighbourhoods = dictionary.valueForKeyPath("location.neighborhoods") as? [String] {
            if neighbourhoods.count > 0 {
                fullAddress += neighbourhoods[0]
            }
        }
        address = fullAddress
        
        if let filter_categories = dictionary["categories"] as? [[String]] {
            var count = 1
            let categoryString = reduce(filter_categories, "") {
                wholeString, category in
                let comma = count++ < filter_categories.count ? ", " : ""
                return "\(wholeString)\(category[0])\(comma)"
            }

            categories = categoryString
        }
        
        if let dist = dictionary["distance"] as? CGFloat {
            distance =  floor(dist)/1000.0
        }        
    }
    
    static func businessesWithDictionaries(dictionaries: [NSDictionary]) -> [Business] {
        
        var businesses = Array<Business>()
        for dictionary in dictionaries {
            var business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        
        return businesses
    }
}
