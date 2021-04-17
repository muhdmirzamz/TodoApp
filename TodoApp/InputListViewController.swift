//
//  InputViewController.swift
//  TodoApp
//
//  Created by Muhd Mirza on 13/7/20.
//  Copyright © 2020 Muhd Mirza. All rights reserved.
//

import UIKit

import FirebaseDatabase
import FirebaseAuth


class InputListViewController: UIViewController {

    @IBOutlet var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addItem() {
        if let text = self.textfield.text {
            
            let ref = Database.database().reference()
            
            guard let userID = Auth.auth().currentUser?.uid else {
                return
            }
            
            guard let key = ref.child("/lists/\(userID)").childByAutoId().key else {
                return
            }
            
            ref.child("/lists/\(userID)/\(key)").setValue(["listName": text])
            
            self.navigationController?.popViewController(animated: true)
        }
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
