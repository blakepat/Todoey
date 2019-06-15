//
//  ViewController.swift
//  Todoey
//
//  Created by Blake Patenaude on 2019-06-01.
//  Copyright © 2019 Blake Patenaude. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    var toDoItems: Results<Item>?
    
    let realm = try! Realm()
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCategory : Category? {
        didSet{
           loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        tableView.rowHeight = 65.0
        
        tableView.separatorStyle = .none

    }

    override func viewWillAppear(_ animated: Bool) {
        
        if let colorHex = selectedCategory?.color {
            
            title = selectedCategory!.name
            
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
            
            navBar.barTintColor = UIColor(hexString: colorHex)
            
            navBar.tintColor = ContrastColorOf(backgroundColor: UIColor(hexString: colorHex), returnFlat: true)
            
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(backgroundColor: UIColor(hexString: colorHex), returnFlat: true)]
            
            searchBar.barTintColor = UIColor(hexString: colorHex)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        guard let originalColor = UIColor(hexString: "2A5488") else {
            fatalError()}
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : FlatWhite()]
        }

    
    
    // MARK - Tableview Datasource Methods
    
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            let categoryBackgroundColor = HexColor(hexString: selectedCategory?.color ?? "2A5488")
            
            if let color = categoryBackgroundColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(toDoItems!.count)) {
                cell.backgroundColor = color
                
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor: color, returnFlat: true)
            }
            
            //Ternary Operator!!!!!
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
                }
            } catch {
                print("error saving done status, \(error)")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the add item button on UIAlert
            
            
            
//*************************** fix this as a CHALLENGE! DO ALL SAVING IN THIS CLOSURE
         
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error saving item to realm \(error)")
                }
            }
            
            
         self.tableView.reloadData()
        
        }
        
        // create pop up alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        // call alert
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
   //MARK - Model Manupulation Methods
    

    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
    }
    
    //MARK: - delete data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.toDoItems?[indexPath.row] {
            do {
                try self.realm.write{
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("error deleting category, \(error)")
            }
            
        }
    }
    
    
}
    //MARK: - Search Bar Methods

    extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("tile CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // this is a quiry
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)

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




