import UIKit
class PopUpReminderVCCell: UITableViewCell {

    @IBOutlet weak var remindName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.contentView.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.shadowOpacity = 1.0
        
        self.layer.shadowRadius = 2
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.contentView.clipsToBounds = true
        
        self.layer.masksToBounds = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
