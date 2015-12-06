//
//  StoreTableViewCell.swift
//  Heady Dropper
//
//  Created by Jackson Fiore on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeCityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var storePhotoImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
