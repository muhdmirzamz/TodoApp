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

class TableViewController: UITableViewController, InputViewProtocol {
    
    var itemsArr: [String] = []
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.isEditing = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ref = Database.database().reference()
        
        let userID = Auth.auth().currentUser?.uid
        
        ref.child(userID!).observe(.value) { (snapshot) in
            self.itemsArr.removeAll()
            
            if let dict = snapshot.value as? NSDictionary {
                for entry in dict {
                    print("Key: \(entry.key)")
                    
                    if let v = entry.value as? NSDictionary {
                        guard let value = v.value(forKey: "todoItem") as? String else {
                            return
                        }
                        
                        print("Value: \(value)")
                        
                        self.itemsArr.append(value)
                    }
                }
                
                self.tableView.reloadData()
            }
           
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.itemsArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.itemsArr[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.itemsArr.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let obj = self.itemsArr[sourceIndexPath.row]
        
        self.itemsArr.remove(at: sourceIndexPath.row)
        self.itemsArr.insert(obj, at: destinationIndexPath.row)
        
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "data" {
            let inputVC = segue.destination as? InputViewController
            inputVC?.delegate = self
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
    
    func sendItem(item: String) {
        self.itemsArr.append(item)
        
        self.tableView.reloadData()
    }
}
