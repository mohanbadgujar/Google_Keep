//  InboxViewModel.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/20/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

//Global variable declaration
var taskKey :String?

class InboxViewModel
{
    var ref:FIRDatabaseReference?

    //create model object
    var model = [AddNotesModel]()
    
    init()
    {
        //set the firebase refrence
        ref = FIRDatabase.database().reference()
    }
    
    //fetch data from firebase
    func fetchData(completion:@escaping (_ result:Bool)->Void,success:@escaping (_ model:[AddNotesModel]) -> Void)
    {
        //Check user is connected to network or not
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet connection OK")
            
            //Retrive data
            DataBaseModels.newUpdateData(completion: { isDone in
                if isDone
                {
                    completion(true)
                }
            })
            
            //If any offline data stored then put that data to firebase
          //  print("aftr offline stored data count=",currentUserData.count)
            
            //post offline data added to firebase
            for i in 0..<currentUserData.count
            {
                
            ref?.child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Data").childByAutoId().setValue(UserDataModel.addTask(title: (currentUserData[i].value(forKey: "title") as? String)!, notes: (currentUserData[i].value(forKey:"note") as? String)!, reminder: (currentUserData[i].value(forKey:"reminder") as? String)!, color: (currentUserData[i].value(forKey:"color") as? String)!))
            }
            
            //remove previous core data
            DataBaseModels.removeCoreData()
            
            //remove previous model data
            self.model.removeAll(keepingCapacity: false)

            //check state
            if trashState{
                
                //Retrieve the posts and listen for changes
                self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("TrashData").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    for rec in snapshot.children
                    {
          
                        taskKey = (rec as! FIRDataSnapshot).key
                        
                        //Try to convert the value of the data to string
                        let post = (rec as! FIRDataSnapshot).value as? [String:String]
                        
                        //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            
                            let taskUP = UserNotes(context: context)
                            
                            taskUP.note = actualPost["note"]
                            taskUP.title = actualPost["title"]
                            taskUP.reminder = actualPost["reminder"]
                            taskUP.key = taskKey
                            
                            let dictTrash = ["note":actualPost["note"],"title":actualPost["title"],"reminder":actualPost["reminder"],"rec":taskKey]
                            
                            myTrashData.append(dictTrash as! [String : String])
                            
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            DataBaseModels.updateData(completion: { isDone in
                                if isDone
                                {
                                    completion(true)
                                    success(self.model)
                                    LoadingIndicatorView.hide()
                                }
                                
                            })
                        }
                    }
                })
            }else{
            
            //check state
            if archiveState
            {
                    //Retrieve the posts and listen for changes
                self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Archive").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    for rec in snapshot.children
                    {
           
                        taskKey = (rec as! FIRDataSnapshot).key
                        
                        //Try to convert the value of the data to string
                        let post = (rec as! FIRDataSnapshot).value as? [String:String]
                        
                        //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            
                            let taskUP = UserNotes(context: context)
                            
                            taskUP.note = actualPost["note"]
                            taskUP.title = actualPost["title"]
                            taskUP.reminder = actualPost["reminder"]
                      
                            taskUP.key = taskKey
                            
                            let dictArch = ["note":actualPost["note"],"title":actualPost["title"],"reminder":actualPost["reminder"],"rec":taskKey]
                            
                            myArchData.append(dictArch as! [String : String])
                            
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            DataBaseModels.updateData(completion: { isDone in
                                if isDone
                                {
                                    completion(true)
                                    LoadingIndicatorView.hide()
                                }
                                
                            })
                        }
                    }
                })
            
            }else{
                
                //Retrieve the posts and listen for changes
                self.ref?.child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("Data").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    for rec in snapshot.children
                    {
         
                        taskKey = (rec as! FIRDataSnapshot).key
                      //  print("TaskKey",taskKey)
                        
                        //Try to convert the value of the data to string
                        let post = (rec as! FIRDataSnapshot).value as? [String:String]
                        
                        //code to executed when a child is added to the users, take the value from the snapshot and added it to the core data
                        if let actualPost = post
                        {
                            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                            
                            let taskUP = UserNotes(context: context)
                            
                            taskUP.note = actualPost["note"]
                            taskUP.title = actualPost["title"]
                            taskUP.reminder = actualPost["reminder"]
                            taskUP.color = actualPost["color"]
                            taskUP.key = taskKey
                            
                            let data = AddNotesModel(title: actualPost["title"]!, note: actualPost["note"]!, reminder: actualPost["reminder"]!, color: actualPost["color"]!,id: taskKey!)
                            
                            self.model.insert(data, at: 0)
                            
                            let dict = ["note":actualPost["note"],"title":actualPost["title"],"reminder":actualPost["reminder"],"color":actualPost["color"],"rec":taskKey]
                            
                            myData.append(dict as! [String : String])
                            
                            if taskUP.reminder != ""
                            {
                                myRemdData.append(dict as! [String : String])
                            }
                            
                            //save the data to core data
                            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                            
                            //get the updated data from core data
                            DataBaseModels.updateData(completion: { isDone in
                                if isDone
                                {
                                    completion(true)
                                    success(self.model)
                                    LoadingIndicatorView.hide()
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    else{
        print("Internet connection FAILED")
        //get the updated data from core data
        DataBaseModels.updateData(completion: { isDone in
            if isDone
            {
                completion(true)
                LoadingIndicatorView.hide()
            }
        })
    }
  }
}
