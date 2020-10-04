//
//  CarTableViewCell.swift
//  CarDirectory
//
//  Created by Григорий Бойко on 01.10.2020.
//  Copyright © 2020 Grigory Boyko. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
