//
//  DataBaseModel.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/10/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
import CoreData

class DataBaseModels
{
    //remove core data from array
    class func removeCoreData()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
    
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for data in currentUserData
            {
                context.delete(data)
                myData.removeAll()
                myArchData.removeAll()
                myRemdData.removeAll()
                myTrashData.removeAll()
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
            
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    //put updated core data to array
    class func updateData(completion:(_ isDone:Bool)->Void)
    {
        //create model object
        var model = [AddNotesModel]()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
        
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            //add offline data to array
            if Reachability.isConnectedToNetwork() == false
            {
                    myData.removeAll()
                    for i in 0..<currentUserData.count
                    {
                        let dict = ["note":currentUserData[i].value(forKey: "note") as? String,"title":currentUserData[i].value(forKey: "title") as? String,"reminder":currentUserData[i].value(forKey: "reminder") as? String,"color":currentUserData[i].value(forKey: "color") as? String,"key":currentUserData[i].value(forKey: "key") as? String]
                        
                        myData.append(dict as! [String : String])
                        
//                        let data = AddNotesModel(title: (currentUserData[i].value(forKey: "title") as? String)!, note: (currentUserData[i].value(forKey: "note") as? String)!, reminder: (currentUserData[i].value(forKey: "reminder") as? String)!, color: (currentUserData[i].value(forKey: "color") as? String)!,id: (currentUserData[i].value(forKey: "key") as? String)!)
//                        
//                        model.insert(data, at: 0)
//                        print("model data count =",model.count)
                    }
            }
            completion(true)
        }
            
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
    
    //put offline data to core data
    class func newUpdateData(completion:(_ isDone:Bool)->Void)
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserNotes")
        
        fetchRequest.predicate = NSPredicate(format: "%K = %@","username","false")
        
        do
        {
            currentUserData = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            completion(true)
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
    }
}
