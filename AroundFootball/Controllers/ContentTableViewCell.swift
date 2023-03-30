//
//  ContentTableViewCell.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/04/25.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var chattingButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tapChattingButton(_ sender: UIButton) {
        
    }
}
