import UIKit
//var timeLabel : String?

class PopUpDatePickVC: UIViewController,UITableViewDelegate,UITableViewDataSource,PopupContentViewController {

    @IBOutlet weak var tableView: UITableView!
    var dayTimes : [String] = ["Morning","Afternoon","Evening","Night","Pick A Time"]
    var  times : [String] = ["8:00 AM","1:00 PM","6:00 PM","8:00 PM",""]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
                
        self.view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 375, height: 300)
    }
    
    class func instance() -> PopUpDatePickVC {
        let storyboard = UIStoryboard(name: "PopUpDatePickVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpDatePickVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "datecell") as! PopUpDatePickVCCell
        cell.dayTime.text = dayTimes[indexPath.row]
        cell.dayTimes.text = times[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        
        switch index {
        case 0:
            timeLabel = times[0]
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })

            break
        case 1:
            timeLabel = times[1]
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.2), execute: {
                self.view.removeFromSuperview()
            })
            break
        case 2:
            timeLabel = times[2]
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            break
        case 3:
            timeLabel = times[3]
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            break
        case 4:
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ESTimePickerVC") as! ESTimePickerVC
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
