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

class CreateTodoViewController: UIViewController {
    
    @IBOutlet var textfield: UITextField!
    
    var list: List?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            
            let listDict: [String : Any] = [
                "name": text,
                "timestamp": dateString
            ]
            
            
            ref.child("/todos/\(listID)/\(key)").setValue(listDict)
            
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
