import UIKit

//var dateLabel : String?
class PopUpTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController {
    
    @IBOutlet weak var tableview: UITableView!
    var datePicker = UIDatePicker()
    var arra : [String] = ["Today","Tomorrow","D'After Tomorrow","Pick a Date..."]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        
        //for table view border
        tableview.layer.borderColor = UIColor.white.cgColor
        tableview.layer.borderWidth = 1.0
        
//        NotificationCenter.default.addObserver(self, selector: #selector(loadCalendar), name: NSNotification.Name(rawValue: "loadCalendar"), object: nil)
    }
    
//    func loadCalendar() {
//        
//        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
//            self.view.removeFromSuperview()
//        })
//    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 375, height: 200)
    }
    class func instance() -> PopUpTableVC{
        let storyboard = UIStoryboard(name: "PopUpTableVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpTableVC
    }

    override func viewWillAppear(_ animated: Bool){
        tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arra.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableview.dequeueReusableCell(withIdentifier: "popupcell") as! PopUpTableVCCell
        cell.label.text = arra[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            
            let date = Date()
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd-MMMM-yyyy"
            dateLabel = dateFormate.string(from: date)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            
            break
            
        case 1:
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd-MMMM-yyyy"
            dateLabel = dateFormate.string(from: tomorrow!)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            break
            
        case 2:
            
            let today = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd-MMMM-yyyy"
            dateLabel = dateFormate.string(from: tomorrow!)
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            
            break
        case 3:
            /*
           datePicker.datePickerMode = .date
           let toolBar = UIToolbar()
           toolBar.sizeToFit()
           let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
           toolBar.setItems([doneButton], animated: false)
            
           view.addSubview(datePicker)*/
           /*
            
            func donePressed()
            {
                let dateFormater = DateFormatter()
                dateFormater.dateStyle = .short
                dateFormater.timeStyle = .short
                datePickerTxt.backgroundColor = UIColor.lightGray
                datePickerTxt.text = dateFormater.string(from: datePicker.date)
            }
            */
           
    //         let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FSCalendarView") as! FSCalendarView
      //       self.addChildViewController(popOverVC)
     //        popOverVC.view.frame = self.view.frame
     //        self.view.addSubview(popOverVC.view)
             
             let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FSCalendarView") as! FSCalendarView
             popOverVC.modalPresentationStyle = .overCurrentContext
             popOverVC.modalTransitionStyle = .crossDissolve
             self.present(popOverVC, animated: true, completion: nil)
             
             self.view.removeFromSuperview()
             
             
             break
            
        default:
 
            break
        }
    }
}

