//
//  RestaurantCell.swift
//  restaurants
//
//  Created by оля on 02.12.2020.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    static let identifier = "RestaurantCell"

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        ratingLabel.numberOfLines = 0
    }
    
    func configure(restaurant: Restaurant){
        imgView?.image = restaurant.image
        nameLabel?.text = restaurant.name
        ratingLabel.text = "rating: " + restaurant.rating
    }
}

