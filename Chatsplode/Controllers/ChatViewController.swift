//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal

class ChatViewController: UIViewController {

    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey!"),
        Message(sender: "a@b.com", body: "Hey Back!"),
        Message(sender: "1@2.com", body: "Dont talk to me that way!")
    ]
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    //Retrieving messages from Firestore database
    //.order(by: "date") orders your data by your data field. |  addSnapshotListener listens for new data coming in.
    func loadMessages(){
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error{
                print("There was an issue getting data \(e)")
            } else {
                if let snapDocs = querySnapshot?.documents{
                    for doc in snapDocs{
                        let data = doc.data()
                        if let msgSender = data["sender"] as? String, let msgBody = data["body"] as? String{
                            let newMsg = Message(sender: msgSender, body: msgBody)

                            self.messages.append(newMsg)
                            //use dispatchqueue whenever you are reloading the tableView.  Its an async func.
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                                
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //Saving messages when created
    @IBAction func sendPressed(_ sender: UIButton) {
        if let msgBody = messageTextfield.text, let msgSender = Auth.auth().currentUser?.email{
            db.collection("messages").addDocument(data: ["sender": msgSender, "body": msgBody, "date": Date().timeIntervalSince1970]) { error in
                if let e = error{
                    print("There was an issue saving data to Firestore \(e)")
                } else {
                    print("Successfully saved data.")
                    DispatchQueue.main.async{
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        let msg = messages[indexPath.row]
        if msg.sender == Auth.auth().currentUser?.email{
            cell.leftImg.isHidden = true
            cell.msgImg.isHidden = false
            cell.msgBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.msgLabel.textColor = UIColor(named: K.BrandColors.purple)
        }  else{
            cell.leftImg.isHidden = false
            cell.msgImg.isHidden = true
            cell.msgBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.msgLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        cell.msgLabel.text = msg.body
        return cell
    }
}


//extension ChatViewController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}


