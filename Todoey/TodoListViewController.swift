//
//  ViewController.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 14/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike","Buy eggos","Destroy demigorgon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.textLabel?.text=itemArray[indexPath.row]
        return cell
    }
    
    
    //MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType(rawValue: 0) ){
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none 
        }
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
self.itemArray.append(alertTextField.text!)
            self.tableView.reloadData()
            }
        }
        
        alertVC.addAction(add)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    


}

