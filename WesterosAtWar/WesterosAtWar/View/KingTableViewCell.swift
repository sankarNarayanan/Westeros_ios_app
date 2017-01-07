//
//  KingTableViewCell.swift
//  WesterosAtWar
//
//  Created by Sankar Narayanan on 07/01/17.
//  Copyright © 2017 Sankar Narayanan. All rights reserved.
//

import Foundation
import UIKit

class KingTableViewCell : UITableViewCell {

    @IBOutlet weak var kingIcon: UIImageView!
    @IBOutlet weak var kingName: UILabel!
    @IBOutlet weak var battleStrength: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    override func awakeFromNib() {
        self.kingIcon.layer.cornerRadius = self.kingIcon.frame.size.height / 2;
        self.kingIcon.clipsToBounds = true;
        self.kingName.adjustsFontSizeToFitWidth = true
        self.battleStrength.adjustsFontSizeToFitWidth = true
        self.rating.adjustsFontSizeToFitWidth = true
    }
    
}
