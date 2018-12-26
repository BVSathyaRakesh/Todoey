//
//  ViewController.swift
//  Todoey
//
//  Created by  B V Sathya Rakesh Kumar on 26/12/18.
//  Copyright © 2018  B V Sathya Rakesh Kumar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var  itemArray = [Item]()
    
      let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
        print(dataFilePath)
        
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem3)
        
        loadItems()
        
    }

    
    ///////////////////////////////////////////////
    
    // Mark  - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemcell", for: indexPath)
         let item = itemArray[indexPath.row]
         cell.textLabel?.text = item.title
        
        //TernaryOperator ==>
        //value = condition ? valueIfTrue == valueIfFalse
        cell.accessoryType = item.done == true ? .checkmark : .none
        
//          if item.done == true {
//            cell.accessoryType = .checkmark
//         }else{
//           cell.accessoryType = .none
//         }
        
         return cell
    }
    
    //Mark - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
         tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //Mark - Add Item Button Action
    @IBAction func addItem(_ sender: UIBarButtonItem) {
         var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
         let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            //print("\(textfield.text!)")
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
            self.saveItems()
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
         alert.addAction(action)
        present(alert , animated: true, completion: nil)
     }
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data =  try encoder.encode(itemArray)
            try data.write(to: self.dataFilePath!)
        }
        catch {
            print("Error encoding item Array \(error) ")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
         if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
             do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item Array \(error) ")
            }
         }
    }
 }

