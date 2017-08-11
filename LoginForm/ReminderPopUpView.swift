import UIKit
import XLActionController

var remindData : String?
var remindTimeData : String?
var dateLabel : String?
var timeLabel : String?
var remindRepeat : String?

class ReminderPopUpView: UIViewController
{
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var timePickLabel: UILabel!
    @IBOutlet weak var dateLabelPick: UILabel!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var searchPlace: UIView!
    
    var  times : [String] = ["8:00:00 AM","1:00:00 PM","6:00:00 PM","8:00:00 PM",""]
    var remindDay : [String] = ["Does not repeat","Repeat Daily","Repeat Weekly","Repeat Monthly","Repeat Yearly","Custom..."]
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
       super.viewDidLoad()
       self.searchPlace.isHidden = true
       NotificationCenter.default.addObserver(self, selector: #selector(loadCalendar), name: NSNotification.Name(rawValue: "loadCalendar"), object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(loadTime), name: NSNotification.Name(rawValue: "loadTime"), object: nil)
    }
    
    //set reminder date
    func loadCalendar() {
        dateLabelPick.text = remindData
    }
    
    //set reminder time
    func loadTime(){
        timePickLabel.text = remindTimeData
    }
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        let date = Date()
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd/MM/yyyy"
        dateLabel = dateFormate.string(from: date)
        dateLabelPick.text = dateLabel
        timeLabel = "8:00:00 AM"
        timePickLabel.text = timeLabel
        remindRepeat = "Does Not Repeat"
        remindLabel.text = remindRepeat
    }
 
    //cancel Button action
    @IBAction func userDidCloseBtnClk(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"save"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    //save reminder Button action
    @IBAction func userDidSaveReminderBtnClk(_ sender: Any) {
        
        if remindData == nil
        {
            let reminderPicked = dateLabelPick.text!+" "+timePickLabel.text!
            remindData = reminderPicked
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
        }
            
        dismiss(animated: true, completion: nil)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:"save"), object: nil)
       
    }
    
    @IBAction func pickDateSearchPlace(_ sender: UISegmentedControl){
        if(sender.selectedSegmentIndex == 0)
        {
            self.searchPlace.isHidden = true
        }else{
            self.searchPlace.isHidden = false
        }
    }

    //Date Button Action
    @IBAction func didClkDateButton(_ sender: Any) {
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Today", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            let date = Date()
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd/MM/yyyy"
            dateLabel = dateFormate.string(from: date)
            
            self.dateLabelPick.text = dateLabel
        }))
        
        actionController.addAction(Action(ActionData(title: "Tomorrow", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd/MM/yyyy"
            dateLabel = dateFormate.string(from: tomorrow!)
            self.dateLabelPick.text = dateLabel
        }))
        
        actionController.addAction(Action(ActionData(title: "Next Saturday", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd/MM/yyyy"
            dateLabel = dateFormate.string(from: tomorrow!)
            self.dateLabelPick.text = dateLabel
        }))
        
        //Pick a date from Calender
        actionController.addAction(Action(ActionData(title: "Pick a date...", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FSCalendarView") as! FSCalendarView
            popOverVC.modalPresentationStyle = .overCurrentContext
            popOverVC.modalTransitionStyle = .crossDissolve
            self.present(popOverVC, animated: true, completion: nil)
            
        }))
        present(actionController, animated: true, completion: nil)

    }
    
    //Time Button action
    @IBAction func userDidTimesBtnClk(_ sender: Any) {
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Morning", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            timeLabel = self.times[0]
            self.timePickLabel.text = timeLabel
        }))
        
        actionController.addAction(Action(ActionData(title: "Afternoon", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            timeLabel = self.times[1]
            self.timePickLabel.text = timeLabel
        }))
        
        actionController.addAction(Action(ActionData(title: "Evening", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            timeLabel = self.times[2]
            self.timePickLabel.text = timeLabel
        }))

        actionController.addAction(Action(ActionData(title: "Night", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            timeLabel = self.times[3]
            self.timePickLabel.text = timeLabel
        }))

        //Pick a Time from Clock
        actionController.addAction(Action(ActionData(title: "Pick a time...", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ESTimePickerVC") as! ESTimePickerVC
            popOverVC.modalPresentationStyle = .overCurrentContext
            popOverVC.modalTransitionStyle = .crossDissolve
            self.present(popOverVC, animated: true, completion: nil)
        }))

        present(actionController, animated: true, completion: nil)
    }

    //Reminder Option Button action
    @IBAction func userDidOptionRemBtnClk(_ sender: Any){
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Does not repeat", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[0]
            self.remindLabel.text = remindRepeat
        }))
        
        actionController.addAction(Action(ActionData(title: "Daily", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[1]
            self.remindLabel.text = remindRepeat
        }))
        
        actionController.addAction(Action(ActionData(title: "Weekly", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[2]
            self.remindLabel.text = remindRepeat
        }))
        
        actionController.addAction(Action(ActionData(title: "Monthly", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[3]
            self.remindLabel.text = remindRepeat
        }))
        
        actionController.addAction(Action(ActionData(title: "Yearly", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[4]
            self.remindLabel.text = remindRepeat
        }))
        
        actionController.addAction(Action(ActionData(title: "Custom...", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            remindRepeat = self.remindDay[5]
            self.remindLabel.text = remindRepeat
        }))
        
        present(actionController, animated: true, completion: nil)
    }
}

