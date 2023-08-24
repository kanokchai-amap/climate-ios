//
//  HeaderSectionView.swift
//  climate-ios
//
//  Created by Kanokchai Amaphut on 24/8/2566 BE.
//


import UIKit

class HeaderSectionView: UITableViewHeaderFooterView {
    @IBOutlet var mainLayoutView: UIView!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var actionButton: UIButton!
    
    static var identifier: String {
        return String(describing: self)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
