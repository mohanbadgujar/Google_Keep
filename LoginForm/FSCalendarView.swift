//
//  FSCalendarView.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 6/12/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import  FSCalendar

class FSCalendarView: UIViewController,FSCalendarDelegate,FSCalendarDataSource{
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func userDidDoneBtnClk(_ sender: Any) {
        if remindData == nil
        {
            let date = Date()
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "MMMM dd"
            remindData = dateFormate.string(from: date)
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue:"loadCalendar"), object: nil)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        
        remindData = formatter.string(for: date)
    }
}
