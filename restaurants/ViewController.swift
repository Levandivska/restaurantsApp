//
//  ViewController.swift
//  restaurants
//
//  Created by оля on 30.11.2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    var currentLat:  Double? = nil
    var currentLon: Double? = nil
    
    var restaurants : [Restaurant] = []
    var requestCreator = CreateRequest()
    var queryService = QueryService()
    
    var costCompare = { (r1: Restaurant, r2: Restaurant) -> Bool in
        return r1.averageCostforTwo ?? 0 < r2.averageCostforTwo ?? 0 }
    
    var ratingCompare = { (r1: Restaurant, r2: Restaurant) -> Bool in
        return Double(r1.rating) ?? 0 > Double(r2.rating) ?? 0 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 600
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        guard let request = requestCreator.getRestaurants() else { return }

        loadDataAndSortByCost(request: request)
    }
    
    func loadDataAndSortByCost(request: URLRequest){
        queryService.getRestaurants(request: request) { [weak self] (results, errorMessage) in
            if let results = results {
                self?.restaurants = results
                self?.tableView.reloadData()
                
                for index in 0..<results.count {
                    if let imgUrl = self?.restaurants[index].imageUrl{
                        print(imgUrl)
                        self?.queryService.getData(from: imgUrl) { data, error in
                            if let data = data, error == nil{
                                self?.restaurants[index].image = UIImage(data: data)
                                self?.tableView.reloadData()
                                }
                            }
                        }
                    }
                self?.restaurants.sort(by: self?.costCompare ?? { (r1: Restaurant, r2: Restaurant) in return false})
                self?.tableView.reloadData()
                }
            }

    }
    
    func distanceCompare(r1: Restaurant, r2: Restaurant) -> Bool{
        if let userLat = self.currentLat,
           let userLon = self.currentLon,
           let r1Lat = r1.latitude,
           let r1Lon = r1.longitude,
           let r2Lat = r2.latitude,
           let r2Lon = r2.longitude {
            let r1Distance = findDistance(lat1: userLat, lon1: userLon, lat2: r1Lat, lon2: r1Lon)
            let r2Distance = findDistance(lat1: userLat, lon1: userLon, lat2: r2Lat, lon2: r2Lon)
            return r1Distance < r2Distance
        }
        else{

            return false
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex
        {
        case 0:
            self.restaurants.sort(by: costCompare)
        case 1:
            self.restaurants.sort(by: ratingCompare)
        case 2:
            self.restaurants = self.restaurants.sorted(by: distanceCompare)
        default:
            break
        }
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "ShowDetail"{
            guard
              let indexPath = tableView.indexPathForSelectedRow,
              let detailViewController = segue.destination as? DetailViewController
              else {
                return
            }
            
            let restaurant = restaurants[indexPath.row]
            detailViewController.id = restaurant.id
        }
    }
    
    // the correctness of the function is not checked
    func findDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double{
        let x = lat1 * lat2
        let y = lon1 * lon2
        let xy = x+y
        return xy
    }
        
}
    

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: RestaurantCell = self.tableView.dequeueReusableCell( withIdentifier: RestaurantCell.identifier) as! RestaurantCell

        let restaurant = restaurants[indexPath.row]
        cell.configure(restaurant: restaurant)

        return cell
    }
}

extension ViewController:  CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        
        let lastLocation = locations.last!
        print("loc: ", lastLocation.coordinate.latitude)
        
        self.currentLat = lastLocation.coordinate.latitude
        print("lat: ", self.currentLat ??  "")

        self.currentLon = lastLocation.coordinate.longitude
        print("lon: ", self.currentLon ?? "")
        
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
       if let error = error as? CLError, error.code == .denied {
          return
       }
    }
}
