//
//  ViewController.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 14/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray : [Item] = []
    var defaults=UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let item1=Item(title: "Find Mike")
//        let item2=Item(title: "Kill demogorgon")
        
        
        
        if let items=defaults.value(forKey: "toDoListArray") as? [Item]{
            itemArray=items
        }
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Tableview datasource methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoitemcell", for: indexPath)
        cell.textLabel?.text=itemArray[indexPath.row].title
        if(itemArray[indexPath.row].done == false){
           
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
          
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        return cell
    }
    
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem=itemArray[indexPath.row]

        if(selectedItem.done == false){
            selectedItem.done=true
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
            selectedItem.done=false
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) //flashes select momentarily and then goes away; looksgood in ui
    }
    
    //MARK: - Add button
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var alertTextField=UITextField()
        
        let alertVC=UIAlertController(title: "New Item", message: nil, preferredStyle: .alert)
        
        alertVC.addTextField{
            (textfield) in
            textfield.placeholder="Create new item"
            
            alertTextField=textfield
            
        }
        
        let add = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if(alertTextField.text != ""){
                
                
                self.itemArray.append(Item(title: alertTextField.text!))
                self.defaults.set(self.itemArray, forKey: "toDoListArray")
                
                self.tableView.reloadData()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cancel)
        
        alertVC.addAction(add)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    


}

