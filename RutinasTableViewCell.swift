//
//  RutinasTableViewCell.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 06/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit

class RutinasTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var fecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
