//
//  ViewController.swift
//  Todoey
//
//  Created by  B V Sathya Rakesh Kumar on 26/12/18.
//  Copyright © 2018  B V Sathya Rakesh Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var  itemArray = ["Find Mike","Buy Eggs","Destroy Demogrogran"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    ///////////////////////////////////////////////
    
    // Mark  - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemcell", for: indexPath)
         cell.textLabel?.text = itemArray[indexPath.row]
         return cell
    }
    
    //Mark - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
         if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
             tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add Item Button Action
    @IBAction func addItem(_ sender: UIBarButtonItem) {
         var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
         let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            //print("\(textfield.text!)")
            self.itemArray.append(textfield.text!)
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
         alert.addAction(action)
        present(alert , animated: true, completion: nil)
     }
 }

