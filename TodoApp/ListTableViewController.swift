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
    
    // original idea was to use a dict <String: Any>
    // to store keys as well as values so as to save a network call
    // but if you store keys + values locally, it takes up RAM/space?
    // so better for a network call?
    
    // dictionaries do not work well with accessing individual keys during tableview deletion
    // so perhaps we keep 2 arrays - one for keys and one for values
    var keysArr: [String] = []
    var listArr: [String] = []
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // prevent double insertion to arrays everytime view loads up
        print("View will appear")
        
        
        self.keysArr.removeAll()
        self.listArr.removeAll()
                
        
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
       
        
        
        ref.child("/lists").child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            
            if let listsDict = snapshot.value as? Dictionary<String, Any> {
                
                for i in listsDict {
                    print("key: \(i.key)")
                    
                    self.keysArr.append(i.key)
                    
                    if let listNameDict = i.value as? Dictionary<String, Any> {
                        
                        guard let listName = listNameDict["listName"] as? String else {
                            return
                        }
                        
                        self.listArr.append(listName)
                        
                        print("listName: \(listName)")
                    }
                }
            }
            
            self.tableView.reloadData()
            
        }
        
        
        
        
        
        
//        ref.child("/lists").child(userID!).observe(.childAdded) { (snapshot) in
//
//            let key = snapshot.key
//            self.keysArr.append(key)
//
//
//            if let listNameDict = snapshot.value as? Dictionary<String, Any> {
//                print("\n\nAN ITEM IS ADDED!!!! ------")
//
//                print("K: \(listNameDict)")
//
//                // how you access a value using Swift's Dictionary<String, Any>
//                guard let listName = listNameDict["listName"] as? String else {
//                    return
//                }
//
//                self.listArr.append(listName)
//
//                print("LENGTH====: \(self.listArr.count)")
//            }
//
//            print("Reloading table view")
//
////            self.removeAll = false
//
//            // reload data when everything is loaded up
//            self.tableView.reloadData()
//        }
        
//        ref.child(userID!).observe(.childRemoved) { (snapshot) in
//
//            let key = snapshot.key
//
//            self.keysArr = self.keysArr.filter { (item) -> Bool in
//                return item != key
//            }
//
//            if let item = snapshot.value as? Dictionary<String, Any> {
//                print("AN ITEM IS REMOVED!!!! ------")
//
//                guard let itemName = item["todoItem"] as? String else {
//                    return
//                }
//
//                // can either use filter{} or firstIndexOf
//                // indexOf(at:) is deprecated?
//                // filter the items array and not include the deleted item
//                self.itemsArr = self.itemsArr.filter { (item) -> Bool in
//                    return item != itemName
//                }
//
//                self.tableView.reloadData()
//            }
//        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.listArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        print("List arr length: \(self.listArr.count)")
        
        // Configure the cell...
        cell.textLabel?.text = self.listArr[indexPath.row]
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // remove from database
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            ref.child("/lists").child(userID!).child(self.keysArr[indexPath.row]).removeValue()
            
            
            // remove from itemsArr
            self.listArr.remove(at: indexPath.row)
            
            // remove from keysArr
            self.keysArr.remove(at: indexPath.row)

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

                print("passed var: \(self.listArr[indexPath.row])")
                
                let todoTableVC = segue.destination as? TodoTableViewController
                todoTableVC?.navigationItem.title = self.listArr[indexPath.row]
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
