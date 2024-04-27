//
//  MyTableCell.swift
//  iOS Test
//
//  Created by Darshan Sonigara on 27/4/2024.
//

import UIKit

class MyTableCell: UITableViewCell {

    @IBOutlet var lblID: UILabel!
    @IBOutlet var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
