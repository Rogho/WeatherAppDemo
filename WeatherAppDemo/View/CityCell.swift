//
//  CityCell.swift
//  WeatherAppDemo
//
//  Created by Rohan Ghorpade on 11/02/21.
//

import UIKit

class CityCell: UITableViewCell {
    @IBOutlet weak var cityName :  UILabel!
    @IBOutlet weak var timeZone :  UILabel!
    @IBOutlet weak var weather :  UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
