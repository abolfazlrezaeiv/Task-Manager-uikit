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
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPress)
        
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
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskItem = tasks[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "TaskDetailVC") as? TaskDetailViewController {
            detailVC.taskText = taskItem["title"] as? String
            detailVC.taskIndex = indexPath.row
            detailVC.onTaskUpdated = {updatedText , index in
                self.tasks[index]["title"] = updatedText
                self.tableView.reloadRows(at: [ IndexPath(row: index, section: 0)], with: .automatic)
            }
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchPoint = gesture.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                tasks[indexPath.row]["title"]  = "\(tasks[indexPath.row]["title"]!) ✅"  // Mark as completed
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}

