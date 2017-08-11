//  LoginViewController.swift
//  Title :- LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 3/15/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.


import UIKit
import CoreData
import Firebase
import FirebaseAuth
import SVProgressHUD
import GoogleSignIn

//Global Variable declaration
var currentuser:String = ""

class LoginViewController: UIViewController, UITextFieldDelegate, loginProtocolDelegate, GIDSignInUIDelegate{
    
    //MARK: - Outlet Declaration
    @IBOutlet weak var mEmailTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    @IBOutlet weak var mSignIn: UIButton!
    @IBOutlet weak var mSignUp: UIButton!
    @IBOutlet weak var mLogInFb: UIButton!
    @IBOutlet weak var mLogInG: GIDSignInButton!
  
    //Variable declaration
    var user:String?
    var pass:String?
    
    //create protocol object
    var loginPresenter:LoginViewPesenter?
    
    //MARK: - viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
       NotificationCenter.default.addObserver(self, selector: #selector(googleLogin), name: NSNotification.Name(rawValue: "googleSignIn"), object: nil)
        
        loginPresenter = LoginViewPesenter(loginProtocolObj: self)
        
        GIDSignIn.sharedInstance().uiDelegate = self

        mSignIn.layer.cornerRadius = 20
        mLogInFb.layer.cornerRadius = 20

        self.mEmailTextField.delegate = self
        self.mPasswordTextField.delegate = self
    }
    
    //MARK: - Google Login Button action
    @IBAction func googleLogin(_ sender: Any){
        UserDefaults.standard.set(true, forKey: "isUserGoogleLoggedIn")
        UserDefaults.standard.synchronize()
        
        LoadingIndicatorView.hide()
        SVProgressHUD.showSuccess(withStatus: "Login Successful👍")
        GIDSignIn.sharedInstance().signIn()
    
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
        self.present(vc!, animated: true, completion: nil)
        SVProgressHUD.dismiss()
    }
    
    //MARK: - Forgot Password Button action
    @IBAction func mForgotPassword(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Login Button action
    @IBAction func loginButton(_ sender: Any){
        LoadingIndicatorView.show(self.view, loadingText: "LOADING")
        
        let userEmail = mEmailTextField.text;
        let userPassword = mPasswordTextField.text;
    
        loginPresenter?.isEmptyTextFields(emailText:mEmailTextField.text!,passText:mPasswordTextField.text!)
    
        loginPresenter?.checkAuthorizedUser(userEmail:userEmail!,userPassword:userPassword!, completion: { isSucces in
            
        if (isSucces)
        {
            LoadingIndicatorView.hide()
            SVProgressHUD.showSuccess(withStatus: "Login Successful👍")

            self.loginPresenter?.saveFirstLastName(completion: { isSucces in
                if (isSucces)
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController")
                    self.present(vc!, animated: true, completion: nil)
                }})
        }})
    }
    
    //Display alert Msg
    func displayMyAlertMessage(userMessage : String){
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        present(myAlert, animated: true, completion: nil)
    }
    
    //show msg when both email and password is empty
    func setEmailPassword(setEmailText: String, setPassText: String){
        self.mEmailTextField.text = setEmailText
        self.mPasswordTextField.text = setPassText
        self.mEmailTextField.textColor = UIColor.red
        self.mPasswordTextField.textColor = UIColor.red
        self.mPasswordTextField.isSecureTextEntry = false
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute:{
            self.mEmailTextField.text = ""
            self.mPasswordTextField.text = ""
            self.mPasswordTextField.isSecureTextEntry = true })
    }
    
    //show msg when only Email field is empty
    func setEmail(setEmailText:String){
        self.mEmailTextField.text = setEmailText
        self.mEmailTextField.textColor = UIColor.red
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute: {
            self.mEmailTextField.text = ""  })
    }
    
    //show msg when only Password field is empty
    func setpassword(setPassText:String){
        self.mPasswordTextField.text = setPassText
        self.mPasswordTextField.textColor = UIColor.red
        self.mPasswordTextField.isSecureTextEntry = false
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 2), execute:{
        self.mPasswordTextField.text = ""
        self.mPasswordTextField.isSecureTextEntry = true  })
    }

    //protocol method to display alert box msg
    func displayAlertBox(msg:String){
        self.displayMyAlertMessage(userMessage: msg)
    }
    
    //MARK: - SignUp Button action
    @IBAction func signUp(_ sender: Any){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegViewController") as! RegViewController
        self.present(vc, animated: true, completion: nil)
    }

    //return keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        mEmailTextField.resignFirstResponder()
        mPasswordTextField.resignFirstResponder()
        self.view.endEditing(true)
        return false
    }
}
