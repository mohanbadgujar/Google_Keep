//
//  NotesViewPresenter.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation

class NotesViewPresenter
{
    //create protocol object
    var notesModel = NotesViewModel()

    //save button action
    func ButtonPressed(mTitleTextField:String,mNotesTextView:String,mReminder:String,completion:@escaping (_ result:Bool)->Void){
        notesModel.ButtonPressed(mTitleTextField: mTitleTextField, mNotesTextView: mNotesTextView,mReminder:mReminder,completion: {
            isSucces in
            
            if (isSucces){
                completion(true)
            }
            else{
                completion(false)
            }
        })
    }
    
    //cell modify
    func update(mTitleTextField:String,mNotesTextView:String,mReminder:String,mKey:String,completion:@escaping (_ result:Bool)->Void){
        notesModel.mupdate(mTitleTextField: mTitleTextField, mNotesTextView: mNotesTextView,mKey:mKey,mReminder:mReminder,completion: {
            isSucces in
            
            if (isSucces){
                completion(true)
            }
            else{
                completion(false)
            }
        })
    }
}
