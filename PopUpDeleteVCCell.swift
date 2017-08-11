//
//  PopUpDeleteVCCell.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 6/14/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit

class PopUpDeleteVCCell: UITableViewCell {

    @IBOutlet weak var labelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.contentView.layer.backgroundColor = UIColor.black.cgColor
        
        self.layer.shadowOpacity = 1.0
        
        self.layer.shadowRadius = 2
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.contentView.clipsToBounds = true
        
        self.layer.masksToBounds = false

    }

}
