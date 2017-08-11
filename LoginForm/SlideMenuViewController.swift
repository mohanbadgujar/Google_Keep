//
//  SlideMenuViewController.swift
//  LoginForm
//
//  Created by BridgeLabz Solutions LLP  on 3/23/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class SlideMenuViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIGestureRecognizerDelegate, ImageCropViewControllerDelegate{
  
    //MARK: - Outlet Declaration
    @IBOutlet weak var mtakeimages: UIImageView!
    @IBOutlet weak var mtakebackimg: UIImageView!
    @IBOutlet weak var mName: UILabel!
    @IBOutlet weak var mEmail: UILabel!
    
    //MARK:Variable Declaration
    var ref:FIRDatabaseReference?
    var profile:String = ""
    var profileback:String = ""
    var storage:FIRStorageReference?
    var section: Int! = 0
    var indexrow: Int! = 0
    var mCircleProfile : Bool = false
    var data = Data()
    let metaData = FIRStorageMetadata()
    let imagePicker = UIImagePickerController()
    
    //MARK: - create protocol object
    var slidePresenter = SlideViewPesenter()
    
    //MARK: - viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //display user first name and last name
        userFirstName = UserDefaults.standard.value(forKey: "user_first_name") as! String
        userLastName = UserDefaults.standard.value(forKey: "user_last_name") as! String
        mName.text = userFirstName+" "+userLastName
        
        ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()!.currentUser!.uid))
        
        storage = FIRStorage.storage().reference().child("Users")
        
        metaData.contentType = "image/jpeg"

        imagePicker.delegate = self
        mtakeimages.isUserInteractionEnabled = true
        mtakebackimg.isUserInteractionEnabled = true
        
        mtakeimages.layer.cornerRadius = mtakeimages.frame.width/2
        mtakeimages.layer.masksToBounds = true
        mtakeimages.layer.borderWidth = 0.5
        
        mEmail.text = currentuser

        //store true or false value
        let isUserProfileSet = UserDefaults.standard.bool(forKey: "isUserProfileSet")
        let isUserBackProfileSet = UserDefaults.standard.bool(forKey: "isUserBackProfileSet")
        
        //check network
        if Reachability.isConnectedToNetwork() == true
        {
            slidePresenter.saveImageData(completion: { isSucces in
                if (isSucces)
                {
                    self.profile = UserDefaults.standard.string(forKey: "user_profile_imgurl")!
                    
                    let profileImageUrl = URL(string:  self.profile as String)
                    
                    print("Image Url",profileImageUrl!)
                    
                    if let url = profileImageUrl
                    {
                        self.mtakeimages.sd_setImage(with: url as URL!)
                    }
                    
                    self.profileback = UserDefaults.standard.string(forKey: "user_background_imgurl")!
                    
                    let backProfileImageUrl = URL(string: self.profileback as String)
                    
                    print("Image Url",backProfileImageUrl!)
                    
                    if let url = backProfileImageUrl
                    {
                        self.mtakebackimg.sd_setImage(with: url as URL!)
                    }
                }})
        }
        else
        {
                if isUserProfileSet
                {
                    self.profile = UserDefaults.standard.string(forKey: "user_profile_imgurl")!
                    
                    let profileImageUrl = URL(string:  self.profile as String)
                    
                    print("Image Url",profileImageUrl!)
                    
                    if let url = profileImageUrl
                    {
                        self.mtakeimages.sd_setImage(with: url as URL!)
                    }
                }
                if isUserBackProfileSet
                {
                    self.profileback = UserDefaults.standard.string(forKey: "user_background_imgurl")!
                    
                    let backProfileImageUrl = URL(string: self.profileback as String)
                    
                    print("Image Url",backProfileImageUrl!)
                    
                    if let url = backProfileImageUrl
                    {
                        self.mtakebackimg.sd_setImage(with: url as URL!)
                    }
                }
        }
    }
    
    //MARK: - Select Background Button action
    @IBAction func selectBackImage(_ sender: UITapGestureRecognizer){
        self.choosePhoto()
        self.mCircleProfile = true
    }

    //MARK: - Select Image from photo library Button action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer){
        self.choosePhoto()
        mCircleProfile = false
    }
    
    //set image and dismiss view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
    }
        
    //set background image
    if mCircleProfile == true
    {
         UserDefaults.standard.removeObject(forKey: "user_background_imgurl")
         mtakebackimg.image = selectedImage
      
        //post background image to firebase
        UserDefaults.standard.set(true, forKey: "isUserBackProfileSet")
        UserDefaults.standard.synchronize()
        
        data = UIImageJPEGRepresentation(selectedImage, 0.8)! as Data
        
        storage?.child((FIRAuth.auth()?.currentUser?.uid)!).child("Profile").child("backprofileimg").put(data, metadata: metaData, completion: {(metadata,error) in
        
            if error != nil
            {
                print("Failed to upload image")
            }
            else
            {
                if let downloadUrl = metadata?.downloadURL()?.absoluteString
                {
                    self.ref?.child("Profile").updateChildValues(["user_background_imgurl":downloadUrl])
                    print("URL - - >",downloadUrl)
                     self.slidePresenter.saveImageData(completion: { isSucces in
                        if (isSucces)
                        {

                        }
                    })
                }
            }
                
            })
            
        }
        else//set profile image
        {
            UserDefaults.standard.removeObject(forKey: "user_profile_imgurl")
            
            mtakeimages.image = selectedImage
            
            //post profile image to firebase
            UserDefaults.standard.set(true, forKey: "isUserProfileSet")
            UserDefaults.standard.synchronize()
            
            data = UIImageJPEGRepresentation(selectedImage, 0.8)! as Data

            storage?.child((FIRAuth.auth()?.currentUser?.uid)!).child("Profile").child("profileimg").put(data, metadata: metaData, completion: {(metadata,error) in
                
                if error != nil
                {
                    print("Failed to upload image")
                }
                else
                {
                    if let downloadUrl = metadata?.downloadURL()?.absoluteString
                    {
                    self.ref?.child("Profile").updateChildValues(["user_profile_imgurl":downloadUrl])
                        self.slidePresenter.saveImageData(completion: { isSucces in
                            if (isSucces)
                            {
                                
                            }
                        })

                    }
                }
                
            })
        }
        if mCircleProfile
        {
            dismiss(animated: true, completion: nil)
        }else
        {
            dismiss(animated: true) { [unowned self] in
            self.openEditor()}
        }
   }
    
    //height for footer
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //clear separator
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      //  tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.separatorColor = UIColor.clear
    }

    //MARK:Action for table view cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        section = indexPath.section
        indexrow = indexPath.row
            
        //Notes cell pressed
        if section == 0 && indexrow == 0{
            reminderState = false
            archiveState = false
            trashState = false
        }
        
        //Reminder cell pressed
        if section == 1 && indexrow == 0{
            reminderState = true
            archiveState = false
            trashState = false
        }
        
        //Archive cell pressed
        if section == 2 && indexrow == 0{
            reminderState = false
            archiveState = true
            trashState = false
        }
        
        //Trash cell pressed
        if section == 3 && indexrow == 0{
            reminderState = false
            archiveState = false
            trashState = true
        }
        
        //Logout cell pressed
        if section == 4 && indexrow == 0{
            slidePresenter.logout(completion: { isSucces in
                if (isSucces)
                {
                    do
                    {
                        try! FIRAuth.auth()?.signOut()
                        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(loginVC, animated: true, completion: nil)
                    }
                    
                }})
        }
    }
    
    //MARK: - Alert box for Take Photo
    func choosePhoto()
    {
        self.imagePicker.delegate = self
        
        let alertController = UIAlertController(title:"Add a Picture", message:"Choose From",preferredStyle: .alert)
        
        //take Photo from Camera
        let cameraAction = UIAlertAction(title:"Camera",style: .default){(action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        //take photo from Photo library
        let photoLibraryAction = UIAlertAction(title:"Photo Library",style: .default){(action) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        //take photo from Album
        let savedPhotoAction = UIAlertAction(title:"Saved Photo Album",style: .default){(action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated:true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title:"Cancel",style: .destructive, handler: nil)
 
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(savedPhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //set image
    func openEditor()
    {
        guard let selectedImage = mtakeimages.image else {
            return
        }
        let controller = ImageCropViewController()
        controller.delegate = self
        controller.image = selectedImage
        controller.blurredBackground = true
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
     }
    
    //cancel action
    func imageCropViewControllerDidCancel(_ controller: UIViewController!){
        self.dismiss(animated: true, completion: nil)
    }
    
    //set croped image
    func imageCropViewControllerSuccess(_ controller: UIViewController!, didFinishCroppingImage croppedImage: UIImage!){
        mtakeimages.image = croppedImage
        self.dismiss(animated: true, completion: nil)
    }
}
