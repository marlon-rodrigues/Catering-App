//
//  PriceItemsTableViewCell.swift
//  Catering App
//
//  Created by Marlon Geraldo Rodrigues Viana on 1/8/16.
//  Copyright © 2016 Marlon Geraldo Rodrigues Viana. All rights reserved.
//

import UIKit

class PriceItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImageLabel: UIImageView!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
