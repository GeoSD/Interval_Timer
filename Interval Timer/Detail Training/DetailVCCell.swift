//
//  DetailVCCell.swift
//  Interval Timer
//
//  Created by Алексей Пархоменко on 23/10/2018.
//  Copyright © 2018 Алексей Пархоменко. All rights reserved.
//

import UIKit

class DetailVCCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
