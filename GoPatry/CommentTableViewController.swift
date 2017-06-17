//
//  CommentTableViewController.swift
//  GoPatry
//
//  Created by Karnovskiy on 10/1/16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import Firebase

class CommentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var REF:  FIRDatabaseReference!

    @IBOutlet weak var textFiledConstrain: NSLayoutConstraint!
    @IBOutlet weak var inputTextView: UIView!
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var event_id: String!
    //var commentsStruct: Comments!
    var comments = [Comment]()
    var addedName = ""
    
    var activeField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.hideKeyboardWhenTappedAround()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.tableFooterView = UIView()
        
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        addBtn.addTarget(self, action:#selector( CommentTableViewController.addBtnClick ), for:UIControlEvents.touchDown )
        
        setupNavigationItem()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        
        animateViewMoving( up: false, moveValue: keyboardSize)
        //self.view.frame.origin.y = 0
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        
        animateViewMoving( up: true, moveValue: keyboardSize )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        removeObserv()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        scrollToBottom()
        addObserv()
    }
    
    func scrollToBottom() {
        if ( comments.count > 0 ) {
            let indexPath = IndexPath(row: comments.count - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        let isEmpty = (textField.text?.isEmpty)! || textField.text == addedName
        addBtn.imageView?.image = UIImage( named: isEmpty ? "add people" : "add group")
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    func addBtnClick(_ sender: UIButton) {
        
        var newText = textField.text!
        if newText.isEmpty {
            return
        }
        
//        if !addedName.isEmpty {
//            
//            newText = newText.replacingOccurrences(of: addedName, with: "")
//        }
        
        let comment = Comment( event_key: event_id, user_uid: Model.TheModel.currentUser.uid, date: NSDate(), text: newText )
        print("added comment: \(newText)")
        
        self.comments.append( comment )
        tableView.reloadData()
        scrollToBottom()
        
        Model.TheModel.addComment( comment: comment )
        
        textField.text = ""
        addedName = ""
    }
    
    func addObserv() {
        Model.TheModel.commentsHelper.addObserv(event_key: event_id, callback: observationCallback )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
    }
    
    func observationCallback( comments: Comments? ) {
        if comments != nil {
//            self.commentsStruct = comments
//            self.commentsStruct.comments.sort(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
            self.comments = (comments?.comments)!
            self.comments.sort(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
            self.tableView.reloadData()
            self.scrollToBottom()
        }
    }
    
    func removeObserv() {
        Model.TheModel.commentsHelper.removeObserv(event_key: event_id)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)

    }
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableCell
            
        let comment = comments[indexPath.row]
        cell.message?.text = comment.text
        if let user = Model.TheModel.getUsersBy(uidsList: [comment.user_uid!], withCurrent: true).first {
            cell.avatar.setData(url: user.photo_url)
            cell.name?.text = user.nik
        }
                  
        cell.date?.text = formatDate( date: comment.date as Date )
        cell.answerBtnCallback = answerBtnCallback
        
        print(comment.description)
            
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
//        if Model.TheModel.currentUser.uid == comments[indexPath.row].user_uid {
//            showAlert( comment: commentsStruct.comments[indexPath.row], isNew: false )
//        }
        return indexPath
    }
    
    func formatDate( date: Date ) -> String {
        
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "ru")
        let formatter = DateComponentsFormatter()
        formatter.calendar = calendar
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute]
        formatter.unitsStyle = .short
        formatter.includesApproximationPhrase = true
        formatter.maximumUnitCount = 1
        
        let elapseTimeInSeconds = Date().timeIntervalSince(date as Date)
       
        var str = formatter.string(from: elapseTimeInSeconds)!
        str = str.replacingOccurrences(of: "About", with: "")
        
        return str
    }
    
    func answerBtnCallback( str: String ) {
        
        let insertName = "@\(str) "
        if addedName == insertName {
            return
        }
        
        var newText = textField.text!
        
        if !addedName.isEmpty {
           
           newText = newText.replacingOccurrences(of: addedName, with: "")
        }
        
        addedName = insertName
        textField.text = insertName + newText
        textField.becomeFirstResponder()
        
        print("@\(str)")
    }
    
    func setupNavigationItem() {
        
        let arrowBackImg = UIImage(named: "Back")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        let leftBarButtonItem = UIBarButtonItem(image: arrowBackImg, style: UIBarButtonItemStyle.plain, target: self, action: #selector( CreateEventPeopleViewController.popToRoot ))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : NAVIGATION_TITLE_COLOR ]
    }
    
    func popToRoot() {
        navigationController!.popViewController(animated: true)
    }
}
