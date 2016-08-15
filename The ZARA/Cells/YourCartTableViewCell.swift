//
//  YourCartTableViewCell.swift
//  The ZARA
//
//  Created by MAC on 10/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit

class YourCartTableViewCell: UITableViewCell {

    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
