//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-08.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    var categoryArray: Results<Category>?
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
        
        tableView.separatorStyle = .none
        
        tableView.rowHeight = 65.0
        
    }
    
    
    //MARK: - TableView Datasoruce Methods
    
    // this gets how many cells there will be in table by checking how many items are in categoryArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//
//    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories add yet"
        
        cell.backgroundColor = HexColor(hexString: categoryArray?[indexPath.row].color ?? ("1D9BF6"))
        
        cell.textLabel?.textColor = ContrastColorOf(backgroundColor: UIColor(hexString: categoryArray?[indexPath.row].color), returnFlat: true)
        
        return cell
        
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
        
        
    }
    
    //MARK: - Add New Categories
    
 
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var categoryTextField = UITextField()
        
        let categoryAlert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let categoryAction = UIAlertAction(title: "Add Category", style: .default) { (categoryAction) in
            
            
            let newCategory = Category()
            
            newCategory.name = categoryTextField.text!
            
            newCategory.color = RandomFlatColor().hexValue()
            
            self.saveCategories(category: newCategory)
        }
        
        categoryAlert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            categoryTextField = alertTextField
        }
        
        categoryAlert.addAction(categoryAction)
        
        present(categoryAlert, animated: true, completion: nil)
        
    
    }
    
    // make savedata and load data
    
    func saveCategories(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
   
    
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("error deleting category, \(error)")
            }

        }
    }
    

    
}






