//
//  ESTimePickerVC.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 6/16/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit

class ESTimePickerVC: UIViewController,ESTimePickerDelegate {
    
    @IBOutlet weak var hoursLabel: UILabel!
    
    @IBOutlet weak var minutesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let timePicker = ESTimePicker(delegate: self)
        // Delegate is optional
        timePicker?.frame = CGRect(x: CGFloat(60), y: CGFloat(230), width: CGFloat(250), height: CGFloat(250))
        view.addSubview(timePicker!)
    }
    
    public func timePickerMinutesChanged(_ timePicker: ESTimePicker!, toMinutes minutes: Int32) {
        minutesLabel.text = "\(minutes)"
    }

    public func timePickerHoursChanged(_ timePicker: ESTimePicker!, toHours hours: Int32) {
        hoursLabel.text = "\(hours)"
    }

    @IBAction func donePrsd(_ sender: UIButton) {
        let totalTime = hoursLabel.text!+":"+minutesLabel.text!+":00"+" AM"
        remindTimeData = totalTime
        NotificationCenter.default.post(name: Notification.Name(rawValue:"loadTime"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPrsd(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
