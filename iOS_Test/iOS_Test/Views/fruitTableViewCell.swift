//
//  fruitTableViewCell.swift
//  iOS_Test
//
//  Created by Aang on 31/07/24.
//

import UIKit

class fruitTableViewCell: UITableViewCell {
    
    @IBOutlet var fruitView: UIView!
    
    @IBOutlet var img: UIImageView!
    
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var subtitleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        fruitView.addBorder(cornerRadius: 16)
        img.addBorder(cornerRadius: 8)
    }

}
