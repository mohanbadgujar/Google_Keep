//
//  LaunchScreenViewController.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/10/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit

//Global Variable Declaration
var userFirstName:String = ""
var userLastName:String = ""

class LaunchScreenViewController: UIViewController
{
    @IBOutlet weak var mCurrentUserName: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        //store true or false value
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLoggedIn")
        let isUserGoogleLoggedIn = UserDefaults.standard.bool(forKey: "isUserGoogleLoggedIn")

        //check user is already log in
        if isUserLoggedIn == true || isUserGoogleLoggedIn == true
        {
            currentuser = UserDefaults.standard.string(forKey: "userEmail")!
            userFirstName = UserDefaults.standard.value(forKey: "user_first_name") as! String
            self.mCurrentUserName.text = userFirstName
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4), execute:
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.present(vc, animated: true, completion: nil)
                })
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 4), execute:
                {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    self.present(vc, animated: true, completion: nil)})
                }
        }
}
