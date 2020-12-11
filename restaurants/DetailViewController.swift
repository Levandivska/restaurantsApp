//
//  DetailViewController.swift
//  restaurants
//
//  Created by оля on 09.12.2020.
//

import UIKit

class DetailViewController: UIViewController {

    var requestCreator = CreateRequest()
    var queryService = QueryService()
    var id: String? = nil
    var restaurantInfo: [String: Any]? = nil
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisinesLabel: UILabel!
    @IBOutlet weak var timingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let id = id,
              let request = requestCreator.getRestaurantInfo(id: id)
        else { return }

        queryService.getRestaurantInfo(request: request) { [weak self] (result, errorMessage) in
            self?.restaurantInfo = result
            self?.setNameLabel()
            self?.setCuisinesLabel()
            self?.setTimingLabel()
        }
    }

    func setNameLabel(){
        guard let name = restaurantInfo?["name"] as? String else { return }
        nameLabel.text = "Name: " + name
    }
    
    func setCuisinesLabel(){
        guard let cuisines = restaurantInfo?["cuisines"] as? String else { return }
        cuisinesLabel.text = "Cuisines: " + cuisines
    }
    
    func setTimingLabel(){
        guard let timing = restaurantInfo?["timings"] as? String else { return }
        timingLabel.text = "Timing: " + timing
    }
    
}
