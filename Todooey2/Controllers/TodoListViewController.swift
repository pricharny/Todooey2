//
//  ViewController.swift
//  Todooey2
//
//  Created by administrator on 3/7/19.
//  Copyright © 2019 Paul Richardson. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    
        var itemArray=[Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    
 //       let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      //   print(dataFilePath)
        // Do any additional setup after loading the view, typically from a nib.
        
        
   
        
        
       
        
        
        
        
        
        
//         if let  items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
            let item = itemArray[indexPath.row]
            cell.textLabel?.text = item.title
        
        //    cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        
            return cell
        
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
   
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)


       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        
        
      
    
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    @IBAction func addButttonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "",
                                      preferredStyle: .alert)
        
               let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                //what will happen once user clicks UIAlert
            
               
                let newItem = Item(context: self.context)
                 newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                  self.itemArray.append(newItem)
                self.saveItems()
            
            
      //      self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        //    let encoder = PropertyListEncoder()
          
            do {
           // let data = try encoder.encode(self.itemArray)
            //    try data.write(to: self.dataFilePath!)
            } catch {
           //     print("error encoding item array, \(error)")
                
            }
             self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
             
            
        }
            
            alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveItems() {
      
    
        
        do {
         try  context.save()
        } catch {
           print("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item>=Item.fetchRequest(), predicate: NSPredicate? = nil) {
   //     let request: NSFetchRequest<Item> = Item.fetchRequest()
      
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
 
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:   [categoryPredicate, predicate])
        
      //      request.predicate = compoundPredicate
        
        
        
        do {
        itemArray = try  context.fetch(request)
        } catch {
        print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }

}

  //MARK:  - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
 func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
    
    let request : NSFetchRequest<Item> = Item.fetchRequest()
   
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

    
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

