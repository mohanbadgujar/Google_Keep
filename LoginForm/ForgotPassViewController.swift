//
//  ForgotPassViewController.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/24/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPassViewController: UIViewController
{
    @IBOutlet weak var mEmailTextField: UITextField!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        mEmailTextField.layer.borderWidth = 1
    }
   
    //MARK: - Reset Password Button action
    @IBAction func resetPassword(_ sender: Any){
        FIRAuth.auth()?.sendPasswordReset(withEmail: mEmailTextField.text!, completion: { (error) in
            
            if error == nil{
                print("An email with information how to reset password has been send to you. Thank You")
            }else{
                print("Error")
            }
        })
    }
    
    //MARK: - Back Button action
    @IBAction func backToLogin(_ sender: Any){
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(vc, animated: true, completion: nil)
    }
}
