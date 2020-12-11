//
//  CreateRequest.swift
//  restaurants
//
//  Created by оля on 08.12.2020.
//

import Foundation


class CreateRequest{
    
    let apiKey = "427e2868c5eb62fc1700aa6ee96d51ce"
    let restaurantsListLink = "https://developers.zomato.com/api/v2.1/search"
    let restaurantInfoLink = "https://developers.zomato.com/api/v2.1/restaurant"

    func getRestaurants() -> URLRequest?{
        
        guard let url = URL(string: restaurantsListLink) else {
             return nil
         }
    
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func getRestaurantInfo(id: String) -> URLRequest?{
        
        let restaurantLink = restaurantInfoLink + "?res_id=" + id
        guard let url = URL(string: restaurantLink) else {
             return nil
         }
    
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "user-key")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        
        return request
    }
}
