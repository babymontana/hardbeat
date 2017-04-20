//
//  NoticiaTableViewCell.swift
//  hardbeat
//
//  Created by Emmanuel Paez on 05/03/17.
//  Copyright © 2017 emmanuel. All rights reserved.
//

import UIKit

class NoticiaTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var img: UIImageView!

    @IBOutlet weak var titulo: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
