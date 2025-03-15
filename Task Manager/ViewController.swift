//
//  ViewController.swift
//  Task Manager
//
//  Created by Abolfazl-Atena on 3/13/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    

    @IBOutlet var tableView: UITableView!
    
    var tasks : [[String : Any]] = []
    
    
    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: "Enter the task information", preferredStyle: .alert)
        
        alertController.addTextField { textFiled in
            textFiled.placeholder = "Add Task"
            
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let taskText = alertController.textFields?.first?.text , !taskText.isEmpty {
                let newTask : [String:Any] = ["title" : taskText, "completed" : false]
                
                self.tasks.append(newTask)
                UserDefaults.standard.set(self.tasks, forKey: "tasks")
                self.tableView.reloadData()
            }
        }
        
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancleAction)
        
        present(alertController, animated: true,completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        if let savedTasks = UserDefaults.standard.array(forKey: "tasks") as? [[String:Any]] {
            self.tasks = savedTasks
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        let taskTitle = tasks[indexPath.row]["title"] as? String ?? ""
        let isCompleted = tasks[indexPath.row]["completed"] as? Bool ?? false
        
        // Apply strikethrough effect if completed
        let attributedString = NSMutableAttributedString(string: taskTitle)
        if isCompleted {
            attributedString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: taskTitle.count))
        }
        
        cell.textLabel?.attributedText = attributedString
        
        cell.accessoryType = isCompleted ? .checkmark : .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            
            UserDefaults.standard.set(self.tasks, forKey: "tasks")
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasks[indexPath.row]["completed"] = !(tasks[indexPath.row]["completed"] as? Bool ?? false)
        
        UserDefaults.standard.set(tasks, forKey: "tasks")
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

