//
//  Restaurant.swift
//  restaurants
//
//  Created by оля on 30.11.2020.
//

import Foundation
import UIKit

class Restaurant {
    
    var id: String
    var name: String
    var imageUrl: URL?
    var rating: String
    var averageCostforTwo: Int?
    var image: UIImage?
    var latitude: Double?
    var longitude: Double?
    
    init(id: String, name: String, imageUrl: URL?, rating: String, cost: Int? = nil, lat: Double? = nil, lon: Double? = nil, image: UIImage? = nil) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.rating = rating
        self.averageCostforTwo = cost
        self.latitude = lat
        self.longitude = lon
        self.image = image
    }
}

extension Restaurant {
    convenience init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
            let id = json["id"] as? String,
            let user_rating = json["user_rating"] as? [String: Any],
            let rating = user_rating["aggregate_rating"] as? String
        else {
            return nil
        }
        
        let cost = json["average_cost_for_two"] as? Int
        
        var imgUrl: URL?
        if let imgLink = json["featured_image"] as? String{
            imgUrl = URL(string: imgLink)
        }
        
        var latitude: Double?
        var longitude: Double?

        if let location = json["location"] as? [String: Any],
           let latStr = location["latitude"] as? String,
           let lonStr = location["longitude"] as? String{
                latitude = Double(latStr)
                longitude = Double(lonStr)
        }
           
        self.init(id: id, name: name, imageUrl: imgUrl, rating: rating, cost: cost, lat: latitude, lon: longitude)
    }
}


