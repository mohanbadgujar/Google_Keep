//
//  AddTaskModoel.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 6/27/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation
class AddNotesModel
{
    var title:String?
    var note:String?
    var reminder:String?
    var color:String?
    var id:String?
    
    init()
    {}
    
    init(title:String,note:String,reminder:String,color:String,id:String){
            self.title = title
            self.note = note
            self.reminder = reminder
            self.color = color
            self.id = id
    }
}


