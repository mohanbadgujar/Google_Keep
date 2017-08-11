//
//  NotesViewController.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 3/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth

//Global Variable declaration
var titleStored:String?
var noteStored:String?
var reminderStored:String?
var colorStored:String?
var keyStored = String()

class NotesViewController: UIViewController, UITextViewDelegate{
    
    //MARK: - Outlet Declaration
    @IBOutlet weak var mTitleTextField: UITextField!
    @IBOutlet weak var mNotesTextView: UITextView!
    @IBOutlet weak var mReminder: UITextField!
    
    //MARK: - Variable Declaration
    var mTitleTextFieldData:String?
    var mNotesTextViewData:String?
    var mReminderData:String?
    var mKey :String?
    var mUpdate = false
    var ref:FIRDatabaseReference?

    //create object
    var notesPresenter = NotesViewPresenter()

    //MARK: - viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if cellState{
            mTitleTextField.text = mTitleTextFieldData
            mNotesTextView.text = mNotesTextViewData
            mReminder.text = mReminderData
            cellState = false
        }
        
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid)).child("Data")

        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderData), name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showNavigation), name: NSNotification.Name(rawValue: "save"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderData), name: NSNotification.Name(rawValue: "setPlaceInfo"), object: nil)
    }

    //MARK: - viewDidLoad
    override func viewWillAppear(_ animated: Bool){
        
        //create a new button
        let backButton: UIButton = UIButton()
        let reminderButton: UIButton = UIButton()
        let deleteButton: UIButton = UIButton()
        //let pinUpButton: UIButton = UIButton()
        
        //set image for button
        backButton.setImage(UIImage(named: "ic_arrow_back"), for: UIControlState.normal)
        reminderButton.setImage(UIImage(named: "reminder"), for: UIControlState.normal)
        deleteButton.setImage(UIImage(named: "deletemenublack"), for: UIControlState.normal)
        //pinUpButton.setImage(UIImage(named: "pinup"), for: UIControlState.normal)
     
        //add function for button
        backButton.addTarget(self, action: #selector(NotesViewController.ButtonPressed), for: UIControlEvents.touchUpInside)
        reminderButton.addTarget(self, action: #selector(NotesViewController.showRemider), for: UIControlEvents.touchUpInside)
        
        //set frame
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        reminderButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        deleteButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        //pinUpButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        let backBarButton = UIBarButtonItem(customView: backButton)
        let reminderBarButton = UIBarButtonItem(customView: reminderButton)
        let deleteBarButton = UIBarButtonItem(customView: deleteButton)
        //let barButton3 = UIBarButtonItem(customView: pinUpButton)
        
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = backBarButton
        self.navigationItem.rightBarButtonItems = [deleteBarButton,reminderBarButton]
        
        navigationController?.navigationBar.isHidden = false
        
        //set shadow to navigation bar
        self.navigationController?.navigationBar.layer.backgroundColor = UIColor.white.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.clipsToBounds = true
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }

    //set reminder data or set place selected place name to label
    func loadReminderData(){
        if remindData != nil{
            mReminder.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
            mReminder.text = remindData
            self.navigationController?.navigationBar.isHidden = false
        }
    }

    //hide navigation bar
    func showNavigation(){
        navigationController?.navigationBar.isHidden = false
    }
    
    //return keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //change placeholder name Note to empty text field
    func textViewDidBeginEditing(_ textView: UITextView){
        if(textView.text == "Note"){
            textView.text = ""
        }
        textView.becomeFirstResponder()
    }
    
    //change placeholder empty text to Note text
    func textViewDidEndEditing(_ textView: UITextView){
        if(textView.text == ""){
            textView.text = "Note"
        }
        textView.resignFirstResponder()
    }

    //Go reminder View Controller
    func showRemider(){
        navigationController?.navigationBar.isHidden = true
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReminderPopUpView") as! ReminderPopUpView
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.modalTransitionStyle = .crossDissolve
        self.present(popOverVC, animated: true, completion: nil)
    }
    
    //This method will call when you press notes save button.
    func ButtonPressed()
    {
        if mUpdate{
            notesPresenter.update(mTitleTextField: mTitleTextField.text!, mNotesTextView: mNotesTextView.text!,mReminder:mReminder.text!,mKey:mKey!,completion: { isSucces in
                if (isSucces)
                {
                    print("hello button is pressed")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            })
        }
        else
        {
            notesPresenter.ButtonPressed(mTitleTextField: mTitleTextField.text!, mNotesTextView: mNotesTextView.text!,mReminder:mReminder.text!,completion: { isSucces in
            if (isSucces)
            {
               print("hello button is pressed")
               let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
 
               self.navigationController?.pushViewController(vc, animated: true)
            }
        })
      }
    }
}
