//
//  NotesViewModel.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage

class NotesViewModel
{
    var ref:FIRDatabaseReference?
    
    //create model object
    var model = [AddNotesModel]()
    
    init(){
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Data")
    }
    
    //Save button action
    func ButtonPressed(mTitleTextField:String,mNotesTextView:String,mReminder:String,completion:@escaping (_ result:Bool)->Void){
        
        //check notes not empty
        if mTitleTextField != "" && mNotesTextView != "" || mTitleTextField == "" && mNotesTextView != "Note"
        {
            titleStored = mTitleTextField
            noteStored = mNotesTextView
            reminderStored = mReminder
            
            print("Reminder Data",reminderStored!)
            
            colorStored = "0xffffff"
            
         //   let data = AddNotesModel(title:titleStored!,note:noteStored!,reminder:reminderStored!,color:colorStored!,id:"")
            
          //  let dateStr = "12/07/2017 9:20:00 AM"
            let dateObj = reminderStored?.date(format: "dd/MM/yyyy hh:mm:ss a")

            print("Date",dateObj)
            
            if dateObj != nil
            {
                NotificationManager.shared.schedule(date:dateObj!,title:titleStored!,note:noteStored!,repeats: false)
            }
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let taskIs = UserNotes(context: context)
            
            if Reachability.isConnectedToNetwork() == true
            {
                print("Internet connection OK")
                
                ref?.childByAutoId().setValue(UserDataModel.addTask(title: titleStored!, notes: noteStored!, reminder:reminderStored!, color:colorStored!))
                
            } else {
                print("Internet connection FAILED")
                taskIs.username = "false"
                taskIs.key = "1"
            }
            
            taskIs.title = mTitleTextField
            taskIs.note = mNotesTextView
            taskIs.reminder = mReminder
            taskIs.color = "0xffffff"
            
            //save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        
        completion(true)
    }
    
    //click cell to modify notes
    func mupdate(mTitleTextField:String,mNotesTextView:String,mKey:String,mReminder:String,completion:@escaping (_ result:Bool)->Void){
        
            //notes not empty
            titleStored = mTitleTextField
            noteStored = mNotesTextView
            reminderStored = mReminder
            colorStored = "0xffffff"

            keyStored = mKey
            print(keyStored)
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let taskIs = UserNotes(context: context)
            
            if Reachability.isConnectedToNetwork() == true
            {
                print("Internet connection OK")
               
                ref?.child(keyStored).updateChildValues(UserDataModel.addTask(title: titleStored!, notes: noteStored!,reminder:reminderStored!, color:colorStored!))
            } else {
                print("Internet connection FAILED")
                taskIs.username = "false"
                taskIs.key = "1"
            }
            
            taskIs.title = mTitleTextField
            taskIs.note = mNotesTextView
            taskIs.reminder = mReminder
            taskIs.color = "0xffffff"
            
            //save the data to core data
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        completion(true)
    }
    
}


extension String {
    
    func date(format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = format
        
        dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "GMT+0:00")
        
        let date = dateFormatter.date(from: self)
        
        return date
        
    }
    
}
