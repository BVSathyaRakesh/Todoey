//
//  ViewController.swift
//  Todoey
//
//  Created by  B V Sathya Rakesh Kumar on 26/12/18.
//  Copyright © 2018  B V Sathya Rakesh Kumar. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var  itemArray = [Item]()
    
    var selectedCategory: Category? {
         didSet{
             loadItems()
        }
    }
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
 
      //  print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
        
       
     }

    //Mark - Add Item Button Action
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add New Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default){
            (action) in
            //print("\(textfield.text!)")
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
        
       // itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        saveItems()
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
         tableView.deselectRow(at: indexPath, animated: true)
         tableView.reloadData()
    }
    
  
    
    //Mark - Data Manipulation Methods
     func saveItems(){
         do {
             try context.save()
        }
        catch {
            print("Error encoding item Array \(error) ")
        }
        
        DispatchQueue.main.async {
             self.tableView.reloadData()
        }
     }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest() , predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", self.selectedCategory!.name!)
         if let additionalPredicate = predicate {
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else{
            request.predicate = predicate
        }
         do {
            itemArray = try context.fetch(request)
        }
        catch{
            print("getch request error is \(error)")
        }
          DispatchQueue.main.async {
              self.tableView.reloadData()
          }
     }
 }

//Mark - Search Bar Methods
extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
         let predicate =  NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
         loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

