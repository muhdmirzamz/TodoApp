//
//  TodoViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 5/6/21.
//  Copyright © 2021 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseDatabase

class TodoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var addButton: UIBarButtonItem!
    
    @IBOutlet var tableView: UITableView!
    
    
    var list: List?
    
    var todoArray: [Todo] = []
    
    var isSortedToTimestamp = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.editButton.title = "Edit"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.todoArray.count
    }


    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.todoArray[indexPath.row].name

        return cell
    }
    
    
    
    
    
    
    
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
    
    @IBAction func sortTable() {
        print("Sorting")
        
        if self.isSortedToTimestamp == false {
            self.todoArray.sort(by: {$0.timestamp! > $1.timestamp!})
            
            self.isSortedToTimestamp = true
        } else {
            self.todoArray.sort(by: {$0.order! < $1.order!})
            
            self.isSortedToTimestamp = false
        }

        self.tableView.reloadData()
    }
    
    // Override to support rearranging the table view.
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
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
