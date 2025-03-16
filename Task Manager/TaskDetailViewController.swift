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
    
    
    @IBOutlet var taskLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLabel.text = taskText ?? ""
        taskLabel.textAlignment = .left
    }
}
