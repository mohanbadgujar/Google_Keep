import UIKit
//var remindRepeat : String?
class PopUpReminderVC: UIViewController,UITableViewDataSource,UITableViewDelegate,PopupContentViewController {

    @IBOutlet weak var tableView: UITableView!
    var remindDay : [String] = ["Does not repeat","Repeat Daily","Repeat Weekly","Repeat Monthly","Repeat Yearly","Custom..."]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }

    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        
        return CGSize(width: 375, height: 300)
    }
    
    class func instance() -> PopUpReminderVC{
        let storyboard = UIStoryboard(name: "PopUpReminderVC", bundle: nil)
        return storyboard.instantiateInitialViewController() as! PopUpReminderVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindercell") as! PopUpReminderVCCell
        cell.remindName.text = remindDay[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        
        switch index {
        case 0:
            
            remindRepeat = remindDay[index]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })

            break
        case 1:
            
            remindRepeat = remindDay[index]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            
            break
            
        case 2:
            remindRepeat = remindDay[index]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            
            break
            
        case 3:
            remindRepeat = remindDay[index]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            
            break
            
        case 4:
            remindRepeat = remindDay[index]
            
            NotificationCenter.default.post(name: Notification.Name(rawValue:"load"), object: nil)
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now()+0.1), execute: {
                self.view.removeFromSuperview()
            })
            break
            
        case 5:
            break
            
        default:
            break
        }
    }
}
