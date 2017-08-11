//  RegViewController.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 3/15/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD

class RegViewController: UIViewController, UITextFieldDelegate, RegisterProtocolDelegate{
    
    //MARK: - Outlet Declaration
    @IBOutlet weak var mFirstName: FloatLabelTextField!
    @IBOutlet weak var mLastName: FloatLabelTextField!
    @IBOutlet weak var mEmailReg: UITextField!
    @IBOutlet weak var mPassReg: UITextField!
    @IBOutlet weak var mRepassReg: UITextField!
    @IBOutlet weak var mMobileReg: UITextField!
    @IBOutlet weak var mCreateAccount: UIButton!

    //create object
    var registerPresenter:RegViewPresenter?
    
    //MARK: - viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
        registerPresenter = RegViewPresenter(RegisterProtocolObj: self)
 
        self.mFirstName.delegate = self
        self.mLastName.delegate = self
        self.mEmailReg.delegate = self
        self.mPassReg.delegate = self
        self.mRepassReg.delegate = self
        self.mMobileReg.delegate = self
        
        mCreateAccount.layer.cornerRadius = 15
    }
    
    //MARK: - Create Account Button action
    @IBAction func createNewAccount(_ sender: Any)
    {
        //MARK: - Variable Declaration
        let firstname_store = mFirstName.text;
        let lastname_store = mLastName.text;
        let username_store = mEmailReg.text;
        let pass_store = mPassReg.text;
        let repass_store = mRepassReg.text;
        let mobile_store = mMobileReg.text;

        //check for empty fields
        registerPresenter?.checkEmptyField(username_store:username_store!,pass_store:pass_store!,repass_store:repass_store!)
        
        //check password and repeated password match
        registerPresenter?.checkPassRepass(pass_store:pass_store!,repass_store:repass_store!)
        
        //Validate Email
        let isEmailAddressValid = registerPresenter?.isValidEmailAddress(emailAddressString: username_store!)
        registerPresenter?.isEmailAddressValid(isEmailAddressValid:isEmailAddressValid!)

        //Validate Password
        let isPasswordValid = registerPresenter?.isValidPassword(passswordString: pass_store!)
        registerPresenter?.isPasswordValid(isPasswordValid:isPasswordValid!)
  
        //Validated Mobile Number
        let isMobileValid = registerPresenter?.isValidMobileNumber(value: mMobileReg.text!)
        registerPresenter?.isMobileValid(isMobileValid:isMobileValid!)
  
        //check registration Validation
        registerPresenter?.checkValidUser(firstname_store:firstname_store!,lastname_store:lastname_store!,username_store:username_store!,pass_store:pass_store!,repass_store:repass_store!,isEmailAddressValid:isEmailAddressValid!,isPasswordValid:isPasswordValid!,isMobileValid:isMobileValid!,mobile_store:mobile_store!,completion:{ isSuccess in
            
            if (isSuccess)
            {
                //display alert

                let myalert = UIAlertController(title:"Alert", message: "Registration is successful, Thank You", preferredStyle : UIAlertControllerStyle.alert)
                
                let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: {(action:UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
     
                })
                
                myalert.addAction(okAction)
                self.present(myalert, animated: true, completion: nil)
            }
        
        })
    }
    
    //Protocol method display Alert Box msg
    func displayAlertBox(msg:String){
        self.displayMyAlertMessage(userMessage: msg)
    }
    
    //If you have registerd go to login page
    @IBAction func alreadyReg(_ sender: UIButton){
       let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       present(vc, animated: true, completion: nil)
    }
    
    //Display Alert Box
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    //hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        mFirstName.resignFirstResponder()
        mLastName.resignFirstResponder()
        mEmailReg.resignFirstResponder()
        mPassReg.resignFirstResponder()
        mRepassReg.resignFirstResponder()
        mMobileReg.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}
