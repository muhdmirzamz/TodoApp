//
//  TodoTableViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 3/4/21.
//  Copyright © 2021 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseDatabase

class TodoTableViewController: UITableViewController {
    
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    var list: List?
    
    var todoArray: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        // prevent double insertion to arrays everytime view loads up
        print("Todo table View will appear")
        

        self.todoArray.removeAll()
                
        
        let ref = Database.database().reference()
        
        guard let listID = list?.key else {
            return
        }
        
        
        ref.child("/todos").child(listID).observeSingleEvent(of: .value) { (snapshot) in
            
            if let todosDict = snapshot.value as? Dictionary<String, Any> {
                
                for i in todosDict {
                    
                    let todo = Todo()
                    
                    todo.key = i.key
                    
                    
                    if let todoDict = i.value as? Dictionary<String, Any> {
                        
                        guard let todoName = todoDict["name"] as? String else {
                            return
                        }
                        
                        todo.name = todoName
                        
                        
                        guard let order = todoDict["order"] as? Int else {
                            return
                        }
                        
                        
                        todo.order = order
                        
                        
                        guard let timestamp = todoDict["timestamp"] as? String else {
                            return
                        }
                        
                        
                        todo.timestamp = timestamp
                        
                        
                        self.todoArray.append(todo)
                    }
                }
            }
            
            self.todoArray.sort(by: {$0.order! < $1.order!})
            
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
        return self.todoArray.count
    }


    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.todoArray[indexPath.row].name

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    @IBAction func turnOnTableReordering() {
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
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        // update local array
        let object = self.todoArray[fromIndexPath.row]
        
        self.todoArray.remove(at: fromIndexPath.row)
        self.todoArray.insert(object, at: to.row)
        
        var count = 0
        
        
        
        // update Firebase
        // local array would have sorted indexes automatically
        let ref = Database.database().reference()
        
        guard let listID = list?.key else {
            return
        }
        
        let listDict: NSMutableDictionary = [:]
        
        // loop through the array to reorder the indexes
        for todo in self.todoArray {
            
            let newDict: [String: Any] = [
                "name": todo.name!,
                "order": count,
                "timestamp": todo.timestamp // there is not a need to change the timestamp
            ]
            
            count += 1
            
            listDict.setValue(newDict, forKey: todo.key!)
        }
        
        self.tableView.reloadData()
        ref.child("/todos/\(listID)").setValue(listDict)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "CreateTodoSegue" {
            let createTodoVC = segue.destination as? CreateTodoViewController
            createTodoVC?.list = list
            createTodoVC?.todoArray = self.todoArray
        }
    }
    

}
