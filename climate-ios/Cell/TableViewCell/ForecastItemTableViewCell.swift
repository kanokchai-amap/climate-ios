//
//  ForecastItemTableViewCell.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 23/8/2566 BE.
//

import UIKit

class ForecastItemTableViewCell: UITableViewCell {
    
    @IBOutlet private var mainLayoutView: UIView!
    @IBOutlet private var backgroudImage: UIImageView!
    @IBOutlet private var cityLabel: UILabel!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var weatherLabel: UILabel!
    @IBOutlet private var degreeLabel: UILabel!
    @IBOutlet private var minMaxDegreeLabel: UILabel!
    
    let isCelsius: Bool = unwrapped(UserDefaultService.getIsCelsius(), with: false)
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        mainLayoutView.layer.cornerRadius = 16
        self.selectionStyle = .none
    }
    
    func setupDataDegree() {
        if isCelsius {
            degreeLabel.text = "30°C"
            minMaxDegreeLabel.text = "H: 31°C L:24°C"
        } else {
            degreeLabel.text = "30°F"
            minMaxDegreeLabel.text = "H: 31°F L:24°F"
        }
    }
}
