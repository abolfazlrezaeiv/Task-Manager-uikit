//
//  ViewController.swift
//  Task Manager
//
//  Created by Abolfazl-Atena on 3/13/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    

    @IBOutlet var tableView: UITableView!
    
    var tasks = [String]()
    
    
    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add Task", message: "Enter the task information", preferredStyle: .alert)
        
        alertController.addTextField { textFiled in
            textFiled.placeholder = "Add Task"
            
        }
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            if let taskText = alertController.textFields?.first?.text , !taskText.isEmpty {
                self.tasks.append(taskText)
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
        
        if let savedTasks = UserDefaults.standard.array(forKey: "tasks") as? [String] {
            self.tasks = savedTasks
        }
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            
            UserDefaults.standard.set(self.tasks, forKey: "tasks")
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

