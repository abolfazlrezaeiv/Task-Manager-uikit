//
//  TaskDetailViewController.swift
//  Task Manager
//
//  Created by Abolfazl-Atena on 3/16/25.
//

import Foundation
import UIKit


class TaskDetailViewController : UIViewController {
    var taskText : String?
    var taskIndex : Int?
    var onTaskUpdated : ((String,Int) -> Void)?
    
    
    @IBOutlet var taskTextField: UITextField!
    
    @IBAction func saveTask(_ sender: Any) {
        guard let newText = taskTextField.text, let index = taskIndex else { return  }
        
        onTaskUpdated?(newText,index)
        
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.text = taskText

    }
}
