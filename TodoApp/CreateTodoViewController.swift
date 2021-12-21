//
//  CreateTodoViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 3/6/21.
//  Copyright © 2021 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth

class CreateTodoViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textfield: UITextField!
    
    var list: List?
    
    var todoArray: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(CreateTodoViewController.hideKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        self.textfield.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }

    @IBAction func addTodo() {
        if let text = self.textfield.text {
            
            let ref = Database.database().reference()
            
            guard let listID = list?.key else {
                return
            }
            
            guard let key = ref.child("/todos/\(listID)").childByAutoId().key else {
                return
            }
            
            
            let dateString = self.getStringForDateToday()
            
            
            // the latest insert gets a 0 index so it will appear at the top
            let listDict: NSMutableDictionary = [
                key: [
                    "name": text,
                    "order": 0,
                    "timestamp": dateString
                ]
            ]
            
            
            var count = 1
            
            // pass in the array (should have been reordered correctly since the array has the auto reorder function)
            // loop through the rest of the array to reorder the indexes
            for todo in self.todoArray {
                
                let newDict: [String: Any] = [
                    "name": todo.name!,
                    "order": count,
                    "timestamp": todo.timestamp
                ]
                
                count += 1
                
                listDict.setValue(newDict, forKey: todo.key!)
            }
            

            
            ref.child("/todos/\(listID)").setValue(listDict)
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func getStringForDateToday() -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.sss'Z'"

        return dateFormatter.string(from: Date())
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
