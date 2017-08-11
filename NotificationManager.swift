import Foundation
import UIKit
import UserNotifications

class NotificationManager : NSObject{
    
    //sharad Instance
    static let shared:NotificationManager = {
        return NotificationManager()
    }()
    
    //lets keep tracking the status of the authorization
    var isAuthorized = false
    
    func requestAuthorization(){
        
        //Here we prepare our notification option so the system know that we will having those type of notification
        let options: UNAuthorizationOptions = [.badge,.alert,.sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: options){(granted:Bool, error:Error?) in
            
            if granted{
                print("Notification Authorized")
                self.isAuthorized = true
            }else{
                print("Notification is not Authorized")
                self.isAuthorized = false
            }
        }
        //set delegate to self VC
        UNUserNotificationCenter.current().delegate = self
    }
    
    //Schedule function
    func schedule(date:Date,title:String,note:String,repeats :Bool) -> Date?{
        
        //since we only have one notification in app that will be schedule so we need to remove all previous notification
        cancelAllNotifications()
        print(date)
        //1- Create Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = note
        content.badge = 1
        content.sound = UNNotificationSound.default()
        
        //we will also attach image in notification
        guard let filePath = Bundle.main.path(forResource: "banner", ofType: "png") else {
            
            print("Image not found")
            return nil
        }
        
        let attachment = try! UNNotificationAttachment(identifier: "attachment", url: URL.init(fileURLWithPath: filePath), options: nil)
        content.attachments = [attachment]
        
        //in order to init trigger we need a datecomponent
        let components = Calendar.current.dateComponents([.minute,.hour], from: date)
        
        let dateComponents = NSDateComponents()
        dateComponents.hour = components.hour!
        dateComponents.minute = components.minute!
        dateComponents.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents as DateComponents, repeats: false)
        
        //create the request so we can add it to notification center
        
        let request =  UNNotificationRequest(identifier: "TestNotificationId", content: content, trigger: trigger)
        
        //Add the request
        UNUserNotificationCenter.current().add(request){(error:Error?) in
            
            //lets format our date so matches device time
            if error == nil{
                print("Notification scheduled",trigger.nextTriggerDate()!.formattedDate)
            }else{
                print("Error scheduling a notification",error?.localizedDescription as Any)
            }
        }
        
        return trigger.nextTriggerDate()!
    }
    
    //now get all pending notification function
    func getAllPendingNotifications(completion:@escaping([UNNotificationRequest]?) -> Void){
        UNUserNotificationCenter.current().getPendingNotificationRequests{ (requests:[UNNotificationRequest]) in
            return completion(requests)
        }
    }
    
    //we need to cancel notification sometime
    func cancelAllNotifications(){
        getAllPendingNotifications{(requests:[UNNotificationRequest]?) in
            if let requestedIDs = requests{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestedIDs.map{$0.identifier})
            }
        }
    }
}

//Delegate methods
extension NotificationManager : UNUserNotificationCenterDelegate
{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Local Notification received while app is open", notification.request.content)
        completionHandler([.alert,.badge,.sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did tap on the notification",response.notification.request.content)
        
        //call the completion handler as soon as done from this call
        completionHandler()
    }
}

extension Date{
    var formattedDate:String{
        let formate = DateFormatter()
        formate.timeZone = TimeZone.current
        formate.timeStyle = .medium
        formate.dateStyle = .medium
        return formate.string(from: self)
    }
}
