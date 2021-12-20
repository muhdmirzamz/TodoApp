//
//  TableViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 13/7/20.
//  Copyright © 2020 Muhd Mirza. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ListTableViewController: UITableViewController {

    var uponSuccessfulSignup = false
    
    var listArray: [List] = []
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        if (uponSuccessfulSignup) {
            let alert = UIAlertController.init(title: "Welcome!", message: "Let's start", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // prevent double insertion to arrays everytime view loads up

        self.listArray.removeAll()
                
        
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
       
        
        
        ref.child("/lists").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            
            if let listsDict = snapshot.value as? Dictionary<String, Any> {
                
                for i in listsDict {
                    
                    let list = List()
                    
                    list.key = i.key
                    
                    
                    if let listNameDict = i.value as? Dictionary<String, Any> {
                        
                        guard let listName = listNameDict["listName"] as? String else {
                            return
                        }
                        
                        list.listName = listName
                        
                        guard let timestamp = listNameDict["timestamp"] as? String else {
                            return
                        }
                        
                        list.timestamp = timestamp
                        
                        self.listArray.append(list)
                    }
                }
            }
            
            self.listArray.sort(by: {$0.timestamp! > $1.timestamp!})
            
            self.tableView.reloadData()
            
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

//        print("List arr length: \(self.listArray.count)")
        
        // Configure the cell...
        cell.textLabel?.text = self.listArray[indexPath.row].listName
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove from firebase
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            
            let listID = self.listArray[indexPath.row].key!
            
            // remove todos first
            ref.child("/todos").child(listID).removeValue()
            // remove list next
            ref.child("/lists").child(userID!).child(listID).removeValue()
            
            
            // remove list from local listArray
            // we remove from local array afterwards and not before
            // because we are referencing listID, which is in listArray
            self.listArray.remove(at: indexPath.row)

            // remove from table view next
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let obj = self.itemsArr[sourceIndexPath.row]
//
//        self.itemsArr.remove(at: sourceIndexPath.row)
//        self.itemsArr.insert(obj, at: destinationIndexPath.row)
//
//        self.tableView.reloadData()
//    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TodoSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {

                print("passed var: \(self.listArray[indexPath.row].listName)")
                
                let todoVC = segue.destination as? TodoViewController
                todoVC?.navigationItem.title = self.listArray[indexPath.row].listName
                todoVC?.list = self.listArray[indexPath.row]
            }
        }
    }
    
    @IBAction func editTable() {
        if self.tableView.isEditing == false {
            self.editButton.title = "Done"
            self.addButton.isEnabled = false
            
            self.tableView.isEditing = true
        } else {
            self.editButton.title = "Edit"
            self.addButton.isEnabled = true
            
            self.tableView.isEditing = false
        }
    }
}
