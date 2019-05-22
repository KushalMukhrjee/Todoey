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
//    var defaults=UserDefaults.standard //to get userdefauts object
    
    var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //i want to create my own plist file
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print(dataFilePath!)
        getItems()
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
        if(itemArray[indexPath.row].done == true){
            print("checkmark")
            cell.accessoryType = .checkmark
        }
        else{
            print("none mark")
            cell.accessoryType = .none
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
        print("item array:",itemArray[indexPath.row].done)
        saveItems()
        
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
                self.saveItems()
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cancel)
        
        alertVC.addAction(add)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    
    func saveItems(){
        
        
        let encoder=PropertyListEncoder() //this will help me in encoding my own objects into a form which can be written into a plist
        
        print("saved items...")
        print(self.itemArray[0].done)
        
        
        do{
            let arr = try? encoder.encode(self.itemArray)
            
            try? arr?.write(to: self.dataFilePath!)
        }
        //self.defaults.set(arr, forKey: "toDoListArray") //will crash the code as you are setting custom object(non-property list object) to plist which is only meant for storing small amounts of data
        
        self.tableView.reloadData()
        
        
    }
    
    
    func getItems(){
        
        do{
            let data = try Data(contentsOf: dataFilePath!)
            let decoder=PropertyListDecoder()
            itemArray = try decoder.decode([Item].self, from: data)
            
            print(itemArray[0].done)
            
        }
        catch{
            print("get items error : \(error)")
        }
        
    }
    
    


}

