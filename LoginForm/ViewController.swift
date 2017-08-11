//  ViewController.swift
//  Title :- LoginForm

//  Created by Mohan Badgujar at BridgeLabz Solutions LLP  on 3/15/17.
//  Copyright © 2017 BridgeLabz Solutions LLP . All rights reserved.

import UIKit
import CoreData
import Firebase
import FirebaseDatabase
import FirebaseAuth
import SVProgressHUD
import XLActionController
import GoogleSignIn
import Social

//MARK: Global Variable Declaration
var useremailstored:String?
var userpasswordstored:String?
var currentUserData = [NSManagedObject]()
var myData = [[String:String]]()
var myArchData = [[String:String]]()
var myTrashData = [[String:String]]()
var myRemdData = [[String:String]]()
var resultarray = [[String:String]]()
var selectedCells:[Int] = []
var reminderState = false
var archiveState = false
var trashState = false
var SearchState = false
var searchBarText = ""
var cellState = false

class ViewController: UIViewController, UISearchBarDelegate, ModelProtocolDelegate{
    
    //MARK: - Variable Declaration
    var archiveDataRemove = false
    var deleteDataRemove = true
    var Gridstate = true
    var cellLongPressState = false
    var selectedIndexColor : IndexPath?
    var isSelected :Bool = false
    var layout : CHTCollectionViewWaterfallLayout!
    fileprivate var longPressGesture : UILongPressGestureRecognizer!
    
    //create object
    var inboxPresenter : InboxViewPesenter?
    
    //create model object
    var model = [AddNotesModel]()
    var modelData = AddNotesModel()

    //MARK: - Outlet Declaration
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var undoViewMsg: UILabel!
    @IBOutlet weak var archiveUndoBtn: UIButton!
    @IBOutlet weak var deleteUndoBtn: UIButton!
    @IBOutlet weak var mCollectionView: UICollectionView!
    @IBOutlet weak var mBottomView: UIView!
    
    //create a new buttons
    let menuButton: UIButton = UIButton()
    let gridButton: UIButton = UIButton()
    let searchButton: UIButton = UIButton()
    let emptyTrashButton: UIButton = UIButton()
    
    //MARK: - Delete Button action
    @IBAction func deleteBtnPress(_ sender: Any) {
        deleteButton()
    }
    
    //MARK: - Color Button action
    @IBAction func colorBtn(_ sender: UIButton) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ColorPickerView") as! ColorPickerView
        popOverVC.modalPresentationStyle = .overCurrentContext
        popOverVC.modalTransitionStyle = .crossDissolve
        self.present(popOverVC, animated: true, completion: nil)
    }
    
    //MARK: - Remove top view Button action
    @IBAction func removeView(_ sender: UIButton) {
        //mCollectionView.reloadData()
        self.navigationController?.navigationBar.isHidden = false
        cellLongPressState = false
        self.isSelected = false
        
        for item in selectedCells
        {
            let indexPath = IndexPath(row: item, section: 0)
            
            let cell = self.mCollectionView.cellForItem(at: indexPath) as! Cell

            cell.layer.opacity = 1
        }
        selectedCells.removeAll()
    }
    
    //MARK: - viewDidLoad Method Declaration
    override func viewDidLoad(){
        super.viewDidLoad()
        
        inboxPresenter = InboxViewPesenter(ModelProtocolObj: self)
        self.undoView.isHidden = true
        
        LoadingIndicatorView.show(self.view, loadingText: "LOADING")
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(_:)))
        self.mCollectionView.addGestureRecognizer(longPressGesture)
        
        layout = self.mCollectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        
        setBottomViewShadow()
        
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.width-45
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        inboxPresenter?.fetchData(completion: { isSucces in
            if (isSucces)
            {
                self.mCollectionView.reloadData()
            }})
        
        let nib = UINib(nibName: "Cell", bundle: nil)
        self.mCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")

        NotificationCenter.default.addObserver(self, selector: #selector(colorForSelectedCell(colors :)), name: NSNotification.Name("selectedCell"), object: nil)
    }
    
    //set selected color to cell
    func colorForSelectedCell(colors:Notification)  {
        
        if let colorValue = colors.userInfo?["color"] as? String
        {
            let cell = mCollectionView.cellForItem(at: selectedIndexColor!) as! Cell
            cell.mView.backgroundColor = UIColor(hex: colorValue)
            self.navigationController?.navigationBar.isHidden = false
            //collectionview.allowsMultipleSelection = false
            isSelected = false
            cell.layer.opacity = 1
            self.postColorIntoFIR(color: (colors.userInfo?["color"] as! String))
        }
    }
    
    //post selected color to firebase
    func postColorIntoFIR(color:String) {
   
        modelData = model[(selectedIndexColor?.row)!]
        
        let rec = modelData.id
        let uid = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference()
        
         ref.child("Users").child(uid!).child("Data").child(rec!).updateChildValues(["color": color as String])
    }

    //MARK: - viewWillAppear Method Declaration
    override func viewWillAppear(_ animated: Bool){
        cellLongPressState = false
        navigationBarButtons()
        setNavigationBar()
        selectedCells.removeAll()
    }
    
    //Set Buttons to navigation Button
    func navigationBarButtons(){
        
        //set image for slidemenu button
        menuButton.setImage(UIImage(named: "menu"), for: UIControlState.normal)
        gridButton.setImage(UIImage(named: "table"), for: UIControlState.normal)
        searchButton.setImage(UIImage(named: "search"), for: UIControlState.normal)
        emptyTrashButton.setImage(UIImage(named: "deletemenu"), for: UIControlState.normal)
        
        //set action to buttons
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        gridButton.addTarget(self, action: #selector(ViewController.ButtonPressed), for: UIControlEvents.touchUpInside)
        searchButton.addTarget(self, action: #selector(ViewController.searchButtonPressed), for: UIControlEvents.touchUpInside)
        emptyTrashButton.addTarget(self, action: #selector(ViewController.emptyTrashPressed), for: UIControlEvents.touchUpInside)
        
        //set frame size for buttons
        menuButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        gridButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        searchButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        emptyTrashButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

        //set buttons as a bar buttons
        let menuBarButton = UIBarButtonItem(customView: menuButton)
        let gridBarButton = UIBarButtonItem(customView: gridButton)
        let searchBarButton = UIBarButtonItem(customView: searchButton)
        let emptyBarButton = UIBarButtonItem(customView: emptyTrashButton)
        
        //assign button to navigationbar
        if trashState
        {
            self.navigationItem.leftBarButtonItem = menuBarButton
            self.navigationItem.rightBarButtonItem = emptyBarButton
            
        }else{
            self.navigationItem.leftBarButtonItem = menuBarButton
            self.navigationItem.setRightBarButtonItems([gridBarButton,searchBarButton], animated: true)
        }
    }
    
    //Set Color to navigation bar according state
    func setNavigationBar()
    {
        if reminderState{
            self.navigationItem.titleView = nil
            self.navigationItem.title = "Reminders"
            self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
            self.navigationController?.navigationBar.barTintColor = UIColor(red: 64/255, green: 88/255, blue: 104/255, alpha: 1)
        }else{
            if archiveState{
                self.mBottomView.isHidden = true
                self.navigationItem.titleView = nil
                self.navigationItem.title = "Archive"
                self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                self.navigationController?.navigationBar.barTintColor = UIColor(red: 67/255, green: 183/255, blue: 203/255, alpha: 1)
            }else{
                if trashState{
                    self.mBottomView.isHidden = true
                    self.navigationItem.titleView = nil
                    self.navigationItem.title = "Trash"
                    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 221/255, green: 52/255, blue: 56/255, alpha: 1)
                }else{
                    self.navigationItem.titleView = nil
                    self.navigationItem.title = "Notes"
                    self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                    self.navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 190/255, blue: 0/255, alpha: 1)
                }
            }
        }
    }
    
    //Set shadow to bottom view
    func setBottomViewShadow()
    {
        mBottomView.layer.shadowColor = UIColor.black.cgColor
        mBottomView.layer.shadowOffset = CGSize.zero
        mBottomView.layer.shadowRadius = 5
        mBottomView.layer.shadowPath = UIBezierPath(rect: mBottomView.bounds).cgPath
        mBottomView.layer.shadowOpacity = 0.5
        mBottomView.clipsToBounds = true
        mBottomView.layer.masksToBounds = false
        
        view.bringSubview(toFront: mBottomView)
    }
    
    //MARK: - Take note Button action
    @IBAction func notesButtonPressed(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Table and Collection Button action
    func ButtonPressed()
    {
        mCollectionView.reloadData()
        
        if Gridstate
        {
            self.gridButton.setImage(UIImage(named: "grid"), for: UIControlState.normal)
            
            self.Gridstate = false
            
        } else
        {
            self.gridButton.setImage(UIImage(named: "table"), for: UIControlState.normal)
            
            self.Gridstate = true
        }
    }
    
    //MARK: - Search Button action
    func searchButtonPressed(){
        createSearchBar()
    }
    
    //create custom search bar
    func createSearchBar(){
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.placeholder = "search here...."
        searchBar.autocapitalizationType = .none
        self.navigationItem.titleView = searchBar
    }
    
    //MARK: - Empty Trash Button action
    func emptyTrashPressed()
    {
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Empty Trash"), style: .default, handler: { action in
            
            let ref = FIRDatabase.database().reference().child("Users").child((FIRAuth.auth()?.currentUser?.uid)!).child("TrashData")
            ref.removeValue()
            self.inboxPresenter?.fetchData(completion: { isSucces in
                if (isSucces)
                {
                    self.mCollectionView.reloadData()
                }})
            
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    //MARK: - Search bar cancel Button action
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        SearchState = false
        setNavigationBar()
        DataBaseModels.updateData(completion: { isDone in
            if isDone
            {
                self.mCollectionView.reloadData()
            }
        })
    }
    
    //action for search bar text did change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        SearchState = true
        
        resultarray.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "title contains[c] %@ OR note contains[c] %@", searchBar.text!,searchBar.text!)
        let array = (myData as NSArray).filtered(using: searchPredicate)
        resultarray = array as! [[String : String]]
        self.mCollectionView.reloadData()
        
        if(searchText.characters.count < 1)
        {
            searchBar.resignFirstResponder()
        }
    }

    //handle longpress gesture
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer){
        switch(gesture.state){
            
        case UIGestureRecognizerState.began:
            let selectedIndexPath = self.mCollectionView.indexPathForItem(at: gesture.location(in: self.mCollectionView))
            
            self.isSelected = true
            self.selectedIndexColor = selectedIndexPath
            
            let cell = mCollectionView.cellForItem(at: selectedIndexPath!) as! Cell
         
            cell.layer.opacity = 0.2

            selectedCells.append((selectedIndexPath?.row)!)
            
            cellLongPressState = true
            self.navigationController?.navigationBar.isHidden = true
            mCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath!)
            
        case UIGestureRecognizerState.changed:
            
            mCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            mCollectionView.reloadData()
            isSelected = false
            self.navigationController?.navigationBar.isHidden = false
            
        case UIGestureRecognizerState.ended:
            
            mCollectionView.endInteractiveMovement()
            
        default:
            
            mCollectionView.cancelInteractiveMovement()
        }
    }
    
    //MARK:Archive Undo Button action
    @IBAction func undoBtnClk(_ sender: Any) {
        archiveDataRemove = true
        inboxPresenter?.fetchData(completion: { isSucces in
            if (isSucces)
            {
                self.mCollectionView.reloadData()
            }})
        
        self.undoView.isHidden = true
    }
    
    //MARK:Delete Undo Button action
    @IBAction func undoDelete(_ sender: UIButton) {
        deleteDataRemove = false
        self.undoView.isHidden = true
        for item in selectedCells{
            let indexPath = IndexPath(row: item, section: 0)
            
            let cell = self.mCollectionView.cellForItem(at: indexPath) as! Cell
            cell.layer.opacity = 1
        }
    }
    
    //set label height
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        
        label.numberOfLines = 0
        
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        label.font = font
        
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
    //set Table view and Collection view frame
    func numberOfCoulom() -> Int {
        if Gridstate
        {
            return 2
        }
        else
        {
            return 1
        }
    }
    
    func sectionInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController : CHTCollectionViewDelegateWaterfallLayout {
    
    //set size for cells
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        let note:String?
        let tittle:String?
        var reminder:String?
        
        if Gridstate
        {
            let labelWidth = (self.mCollectionView.bounds.width-(self.sectionInsets().left+self.sectionInsets().right+layout.minimumColumnSpacing))/2
            
            if trashState{
                note = myTrashData[indexPath.row]["note"]
                tittle = myTrashData[indexPath.row]["title"]
            
            }else{
            if reminderState
            {
                note = myRemdData[indexPath.row]["note"]
                tittle = myRemdData[indexPath.row]["title"]
                
            }else{
                if archiveState
                {
                    note = myArchData[indexPath.row]["note"]
                    tittle = myArchData[indexPath.row]["title"]
                }else{
                        modelData = model[indexPath.row]
                        note = modelData.note
                        tittle = modelData.title
                        reminder = modelData.reminder
                }
              }
            }
            
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            
            let noteHeight = self.heightForView(text: (note)!, font: (labelFont)!, width:labelWidth)
            
            let tittleHeight = self.heightForView(text: tittle!, font: labelFont!, width:labelWidth)
            
            let totalHeight = noteHeight+tittleHeight
            
            if reminder == ""
            {
                return CGSize(width: labelWidth, height: totalHeight+20)
            }else
            {
                return CGSize(width: labelWidth, height: totalHeight + 40)
            }
        }
        else
        {
            if trashState{
                
                note = myTrashData[indexPath.row]["note"]
                tittle = myTrashData[indexPath.row]["title"]

            }else{
            if reminderState
            {
                note = myRemdData[indexPath.row]["note"]
                tittle = myRemdData[indexPath.row]["title"]
                
            }else{
                
                if archiveState
                {
                    note = myArchData[indexPath.row]["note"]
                    tittle = myArchData[indexPath.row]["title"]
                    
                }else{
 
                    modelData = model[indexPath.row]
                    
                    note = modelData.note
                    tittle = modelData.title
                    reminder = modelData.reminder
                }
              }
            }
            
            let labelFont = UIFont(name:"Helvetica Neue" , size: 17)
            
            let noteHeight = self.heightForView(text: note!, font: labelFont!, width:(view.bounds.width - 40))
            
            let tittleHeight = self.heightForView(text: tittle!, font: labelFont!, width:(view.bounds.width - 40))
            
            let totalHeight = (noteHeight+40)+tittleHeight
            
            if reminder == ""
            {
                return CGSize(width: (view.bounds.width - 40), height: totalHeight-20)
            }else
            {
                return CGSize(width: (view.bounds.width - 40), height: totalHeight)
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    //arrays count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if trashState{
            return myTrashData.count
        }else{
        if reminderState{
            return myRemdData.count
        }else{
            if SearchState{
                return resultarray.count
            }else{
                if archiveState{
                    return myArchData.count
                }else{
                    
                print(model.count)
                 return model.count
                }
             }
          }
       }
    }
    
    //Delegate method callback
    func passModelData(model12: [AddNotesModel]) {
        self.model = model12
    }
    
    //take data from array and put into cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        let color:String?
        
        if trashState
        {
            cell.mTitle.text = myTrashData[indexPath.row]["title"]
            cell.mNote.text = myTrashData[indexPath.row]["note"]
            cell.mReminder.text = myTrashData[indexPath.row]["reminder"]
            
        }else{
        if reminderState
        {
            cell.mTitle.text = myRemdData[indexPath.row]["title"]
            cell.mNote.text = myRemdData[indexPath.row]["note"]
            cell.mReminder.text = myRemdData[indexPath.row]["reminder"]
            color = myRemdData[indexPath.row]["color"]! as String
            cell.mView.backgroundColor = UIColor(hex:color!)
            
        }else{
            if SearchState
            {
                cell.mTitle.text = resultarray[indexPath.row]["title"]
                cell.mNote.text = resultarray[indexPath.row]["note"]

            }else{
                if archiveState
                {
                    cell.mTitle.text = myArchData[indexPath.row]["title"]
                    cell.mNote.text = myArchData[indexPath.row]["note"]
                    cell.mReminder.text = myArchData[indexPath.row]["reminder"]
                    
                }else
                {
                    modelData = model[indexPath.row]
                    
                    cell.mTitle.text = modelData.title
                    cell.mNote.text = modelData.note
                    cell.mReminder.text = modelData.reminder
                    color = modelData.color! as String
                    cell.mView.backgroundColor = UIColor(hex:color!)
                }
            }
        }
    }
        return cell
    }
    
    //archive action
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?){
        
        self.deleteUndoBtn.isEnabled = false
        self.undoView.isHidden = false
        
        var myTempArchData = [[String:String]]()
        for _ in 0..<model.count
        {
            modelData = model[indexPath.row]
            
            let dict = ["note":modelData.note,"title":modelData.title,"reminder":modelData.reminder,"rec":modelData.id]
            myTempArchData.append(dict as! [String : String])
        }
        
        DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 5), execute:
            {
                if self.archiveDataRemove == false
                {
                    self.undoView.isHidden = true
                    
                    let post : [String:AnyObject] = ["title":myTempArchData[indexPath.row]["title"] as AnyObject,"note":myTempArchData[indexPath.row]["note"] as AnyObject,"reminder":myTempArchData[indexPath.row]["reminder"] as AnyObject]
                    
                    let df = FIRDatabase.database().reference()
                    
                    let uid = FIRAuth.auth()?.currentUser?.uid
                    
                    df.child("Users").child(uid!).child("Archive").childByAutoId().setValue(post)
                    
                    let temp = myTempArchData[indexPath.row]
                    
                    let ref = FIRDatabase.database().reference().child("Users").child(uid!).child("Data").child(temp["rec"]!)
                    ref.removeValue()
                    
                }
        })
        model.remove(at: indexPath.row)
        myData.remove(at: indexPath.row)
        mCollectionView.reloadData()
    }
    
    //move cell action from source to destination
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
        
        let temp = model.remove(at: sourceIndexPath.item)
        model.insert(temp, at: destinationIndexPath.item)
        
        self.mCollectionView.reloadData()
    }
    
    //Cells action
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        if cellLongPressState == true
        {
            let cell = mCollectionView.cellForItem(at: indexPath) as! Cell
            
            //show cell popup animation
            self.showAnimation(indexPath: indexPath)
            
            if selectedCells.contains(indexPath.row) {
                
                cell.layer.opacity = 1
                selectedCells.remove(at: selectedCells.index(of: indexPath.row)!)
                 print("Selected Cells =",selectedCells)
            } else {

                cell.layer.opacity = 0.2
                selectedCells.append(indexPath.row)
                print("Selected Cells =",selectedCells)
            }
        }else{
            
            let cell = mCollectionView.cellForItem(at: indexPath) as! Cell
        
            let newFrame = UIView(frame: CGRect(x: (cell.frame.origin.x), y: (cell.frame.origin.y), width: (cell.frame.width), height: (cell.frame.height)))
            
            modelData = model[indexPath.row]
            newFrame.backgroundColor = UIColor(hex: modelData.color! as String)
            
            self.view.addSubview(newFrame)
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options:[], animations: {
                
                newFrame.frame.origin.x = 0
                
                newFrame.frame.origin.y = 0
                
                newFrame.frame.size.width = self.view.bounds.width
                
                newFrame.frame.size.height = self.view.bounds.height
                
            }, completion: {(true) in
 
                let vc:NotesViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotesViewController") as! NotesViewController
                
                self.modelData = self.model[indexPath.row]
                vc.mTitleTextFieldData = self.modelData.title
                vc.mNotesTextViewData = self.modelData.note
                vc.mReminderData = self.modelData.reminder
                vc.mKey = self.modelData.id
                
                vc.mUpdate = true
                
                self.navigationController?.pushViewController(vc, animated: false)
                cellState = true
                
                newFrame.removeFromSuperview()
            })
        }
    }
    
    //MARK: - Delete Button action(move data to trash)
    func deleteButton(){
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Archive"), style: .default, handler: { action in
        }))
        
        actionController.addAction(Action(ActionData(title: "Delete", image: UIImage(named: "table")!), style: .default, handler: { action in
            
            self.navigationController?.navigationBar.isHidden = false
            self.undoViewMsg.text = "Note moved to trash"
            self.archiveUndoBtn.isEnabled = false
            self.undoView.isHidden = false
            
            for item in selectedCells{
                let indexPath = IndexPath(row: item, section: 0)
                
                let cell = self.mCollectionView.cellForItem(at: indexPath) as! Cell
                cell.layer.opacity = 0.01
            }
            
            DispatchQueue.main.asyncAfter(deadline: (DispatchTime.now() + 5), execute:{
                if self.deleteDataRemove{
                    self.undoView.isHidden = true
                    self.deleteCell()
                }
            })
        
        }))
        actionController.addAction(Action(ActionData(title: "Make a copy", image: UIImage(named: "table")!), style: .default, handler: { action in
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Send", image: UIImage(named: "table")!), style: .default, handler: { action in
            self.send()
        }))
    
        actionController.addAction(Action(ActionData(title: "Copy to Google Docs", image: UIImage(named: "table")!), style: .cancel, handler: nil))
        
        present(actionController, animated: true, completion: nil)
    }
    
    //MARK: - Delete Cell Button action
    func deleteCell() {
        print(selectedCells)
     //   selectedCells.sorted(by: >)
        for item in selectedCells{
            
            self.postDataToTrash(index: item)
            
            self.removeTrashDataFromFIR(indexValue: item)
            
            model.remove(at: item)
            myData.remove(at: item)
            
            let indexPath = IndexPath(row: item, section: 0)
            
            mCollectionView.deleteItems(at: [indexPath])
            
        }
        selectedCells.removeAll()
        
        mCollectionView.reloadData()
    }
    
    //push data to firebase
    func postDataToTrash(index:Int){
        
        modelData = model[index]
        
        let title = modelData.title! as String
        
        let note = modelData.note! as String
        
        let reminder = modelData.reminder! as String
        
        let notes:[String:String] = [
            
            "title":title,
            
            "note":note,
            
            "reminder": reminder
        ]
    
        let df = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        df.child("Users").child(uid!).child("TrashData").childByAutoId().setValue(notes)
    }
    
    //remove trash data from firebase
    func removeTrashDataFromFIR(indexValue : Int){
        let uid = FIRAuth.auth()?.currentUser?.uid
        modelData = model[indexValue]

        let ref = FIRDatabase.database().reference().child("Users").child(uid!).child("Data").child(modelData.id!)
        ref.removeValue()
    }
    
    //send notification
    func send(){
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc?.setInitialText("Hi Mohan")
             vc?.add(#imageLiteral(resourceName: "ic_archive"))
        self.present(vc!, animated: true, completion: nil)
    }
    
    //show cell popup animation
    func showAnimation(indexPath:IndexPath)
    {
        let cell = self.mCollectionView.cellForItem(at: indexPath)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: [], animations: {
            
            cell?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        }, completion: {finished in
            
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                
            cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                
            })
        })
    }
}


