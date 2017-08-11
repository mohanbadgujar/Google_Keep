//  InboxPresenter.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 4/20/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import Foundation

protocol ModelProtocolDelegate{
    func passModelData(model12:[AddNotesModel])
}

class InboxViewPesenter : NSObject
{
    //create protocol object
    var inboxModel = InboxViewModel()
    
    //create model object
    var model = [AddNotesModel]()
    
    //create protocaol object
    var modelProtocolObject : ModelProtocolDelegate?
    
    init(ModelProtocolObj:ModelProtocolDelegate){
        self.modelProtocolObject = ModelProtocolObj
    }
    
    //fetch data from firebase and core data
    func fetchData(completion:@escaping (_ result:Bool)->Void){
         inboxModel.fetchData(completion: {
            isSucces in
            
            if (isSucces){
                completion(true)
            }
            else{
                completion(false)
            }
        },success:{(model2)-> Void in
            self.model = model2
            self.modelProtocolObject?.passModelData(model12:model2)
        }) 
    }
}
