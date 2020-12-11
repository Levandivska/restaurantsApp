//
//  QueryService.swift
//  restaurants
//
//  Created by оля on 30.11.2020.
//

import Foundation
import UIKit

class QueryService {
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var errorMessage = ""
    var restaurants : [Restaurant] = []
        
    
    func getData(from url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
        
            guard let data = data, error == nil else {
                self?.errorMessage += "Error getting responce \n"
                return
            }
            
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        dataTask?.resume()
    }

    func getRestaurants(request: URLRequest, completion: @escaping ([Restaurant]?, String?) -> Void) {
        self.restaurants = []
        
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                self?.errorMessage += "Error getting responce \n"
                return
            }
            
            guard let json = self?.makeJson(data: data) else { return }
            
            guard let array = json["restaurants"] as? [Any] else {
                self?.errorMessage += "Dictionary does not contain results key\n"
                return
            }
        
            for restaurantDictionary in array {
                if let restaurantDictionary = restaurantDictionary as? [String: Any],
                   let restaurantJson = restaurantDictionary["restaurant"] as? [String: Any],
                   let restaurant = Restaurant(json: restaurantJson){
                        self?.restaurants.append(restaurant)
                    }
                }
            
            DispatchQueue.main.async {
                completion(self?.restaurants, self?.errorMessage)
            }
        }
        
        dataTask?.resume()
        
    }
    
    func getRestaurantInfo(request: URLRequest, completion: @escaping ([String: Any]?, String?) -> Void) {
        self.restaurants = []
        
        dataTask = defaultSession.dataTask(with: request) { [weak self] data, response, error in
            
            guard let data = data, error == nil else {
                self?.errorMessage += "Error getting responce \n"
                return
            }
            
            guard let json = self?.makeJson(data: data) else { return }

            DispatchQueue.main.async {
                completion(json, self?.errorMessage)
            }
        }
        
        dataTask?.resume()
        
    }
    
    func makeJson(data: Data) -> [String: Any]? {
        var response: [String: Any]?
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseError as NSError {
            self.errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
          return nil
        }
        
        return response
    }

}
