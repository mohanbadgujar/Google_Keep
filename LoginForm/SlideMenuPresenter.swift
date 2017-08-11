//
//  SlideMenuPresenter.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/25/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation

class SlideViewPesenter
{
    //create protocol object
    var slideModel = SlideViewModel()
    
    //save image data
    func saveImageData(completion:@escaping (_ result:Bool)->Void)
    {
        slideModel.saveImageData(completion: {
            isSucces in
            
            if (isSucces){
                completion(true)
            }else{
                completion(false)
            }
            
        })
    }
    
    //logout operation
    func logout(completion:@escaping (_ result:Bool)->Void)
    {
        slideModel.logout(completion: {
            isSucces in
            
            if (isSucces){
                completion(true)
            }else{
                completion(false)
            }
            
        })
    }
}
