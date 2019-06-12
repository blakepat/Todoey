//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-08.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    var categoryArray: Results<Category>?
    
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK: - TableView Datasoruce Methods
    
    // this gets how many cells there will be in table by checking how many items are in categoryArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories add yet"
        
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

    
}
