//
//  VariantTableViewCell.swift
//  Ecommerce
//
//  Created by Binita Patel on 25/06/20.
//  Copyright © 2020 Heady. All rights reserved.
//

import UIKit

class VariantTableViewCell: UITableViewCell {
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblColor: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
