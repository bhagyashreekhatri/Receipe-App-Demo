//
//  ReceipeListTableViewCell.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit

class ReceipeListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var receipeImageView: UIImageView!
    
    @IBOutlet weak var receipeNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
