//
//  ViewController.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 14/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray : [Item] = []
    
    var selectedCategory:Category?{
        didSet{
            getItems()
        }
    }
    
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
                
                let newItem=Item(context: self.context)
                newItem.title = alertTextField.text
                newItem.done = false
                newItem.parentCategory=self.selectedCategory
                
                
                
                self.itemArray.append(newItem)
                self.saveItems()
                
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(cancel)
        
        alertVC.addAction(add)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    
    func saveItems(){
        
        
//        let encoder=PropertyListEncoder() //this will help me in encoding my own objects into a form which can be written into a plist
        
        print("saved items...")
        print(self.itemArray[0].done)
        
        
        do{
//            let arr = try? encoder.encode(self.itemArray)
//
//            try? arr?.write(to: self.dataFilePath!)
            
            
            try context.save()
            
            
        }
        catch{
            print("Error saving data:\(error)")
        }
        
        //self.defaults.set(arr, forKey: "toDoListArray") //will crash the code as you are setting custom object(non-property list object) to plist which is only meant for storing small amounts of data
        
        self.tableView.reloadData()
        
        
    }
    

    func getItems(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate:NSPredicate? = nil){
        
        let categoryPredicate=NSPredicate(format: "parentCategory.name MATCHES %@", self.selectedCategory!.name!)
        
        if let addedpredicate=predicate{
            let compoundPredicate=NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addedpredicate])
            request.predicate=compoundPredicate
            
        }
        else{
            request.predicate=categoryPredicate
        }
        

//        do{
//            let data = try Data(contentsOf: dataFilePath!)
//            let decoder=PropertyListDecoder()
//            itemArray = try decoder.decode([Item].self, from: data)
//
//            print(itemArray[0].done)
//
//        }
//        catch{
//            print("get items error : \(error)")
//        }
        
        
        
        do{
            self.itemArray = try context.fetch(request)
            
        }
        catch{
            print("error while fetching from context: \(error)")
        }
        tableView.reloadData()

    }
    
    
    
    
    
    


}

extension TodoListViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate=predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors=[sortDescriptor]
        
        getItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text==""){
            getItems()
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
            
        }
        else{
              let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            request.sortDescriptors=[sortDescriptor]
            
            getItems(with: request,predicate: predicate)
        }
    }
    
    
}
