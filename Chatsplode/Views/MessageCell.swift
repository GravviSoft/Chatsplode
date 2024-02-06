//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Beau Enslow on 1/31/24.
//  Copyright © 2024 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var msgBubble: UIView!
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var msgImg: UIImageView!
    @IBOutlet weak var leftImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        msgBubble.layer.cornerRadius = msgBubble.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
