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

    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var event_id: String!
    //var commentsStruct: Comments!
    var comments = [Comment]()
    var addedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        
        tableView.tableFooterView = UIView()
        
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        addBtn.addTarget(self, action:#selector( CommentTableViewController.addBtnClick ), for:UIControlEvents.touchDown )
        
         setupNavigationItem()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        removeObserv()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        
        addObserv()
    }
    
    func textFieldDidChange(textField: UITextField) {
        let isEmpty = (textField.text?.isEmpty)! || textField.text == addedName
        addBtn.imageView?.image = UIImage( named: isEmpty ? "add people" : "add group")
    }
    
    func addBtnClick(_ sender: UIButton) {
        
        var newText = textField.text!
        if newText.isEmpty {
            return
        }
        
        if !addedName.isEmpty {
            
            newText = newText.replacingOccurrences(of: addedName, with: "")
        }
        
        let comment = Comment( event_key: event_id, user_uid: Model.TheModel.currentUser.uid, date: NSDate(), text: newText )
        print("added comment: \(newText)")
        
        self.comments.append( comment )
        tableView.reloadData()
        
        Model.TheModel.addComment( comment: comment )
        
        textField.text = ""
        addedName = ""
    }
    
//    func addComment( ) {
//        
//        let comment = Comment( user_uid: Model.TheModel.currentUser.uid, date: NSDate(), text: "" )
//        
//        showAlert( comment: comment, isNew: true )
//    }
//    
//    func showAlert( comment: Comment, isNew: Bool ) {
//        
//        let alert = UIAlertController(title: ( isNew ? "New comment" : "Edit comment" ), message: "", preferredStyle: .alert)
//        
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { ( textField ) in
//            textField.placeholder = ( comment.text == "" ? "Some default text" : comment.text )
//        }
//        
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let text = alert?.textFields![0].text
//            if !( (text?.isEmpty)! ) {
//                comment.text = text!
//                if isNew {
//                   self.commentsStruct.comments.append( comment )
//                }
//                
//                Model.TheModel.saveComments( comments: self.commentsStruct )
//            }
//        }))
//        
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//    }
    
    func addObserv() {
        Model.TheModel.commentsHelper.addObserv(event_key: event_id, callback: observationCallback )
    }
    
    func observationCallback( comments: Comments? ) {
        if comments != nil {
//            self.commentsStruct = comments
//            self.commentsStruct.comments.sort(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
            self.comments = (comments?.comments)!
            self.comments.sort(by: { $0.date.timeIntervalSince1970 < $1.date.timeIntervalSince1970 })
            self.tableView.reloadData()
        }
    }
    
    func removeObserv() {
        Model.TheModel.commentsHelper.removeObserv(event_key: event_id)
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
