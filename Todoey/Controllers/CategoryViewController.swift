//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 25/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm=try! Realm()
    
    var newCatgoryText:String?
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var categoryArray:[CategoryR]=[]
    var categoryArray : Results<CategoryR>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath)
        
        cell.textLabel?.text=categoryArray?[indexPath.row].name ?? "No categories added yet."
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category:CategoryR){
        
        do{
//            try context.save()
            
            try realm.write {
                realm.add(category)
            }
            
            
        }
        catch{
            print("Error saving categories:\(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    //for core data
//    func getCategories(with fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()){
//        do{
//            categoryArray=try context.fetch(fetchRequest)
//        }
//        catch{
//            print("Error fetching categories:\(error)")
//        }
//        
//        tableView.reloadData()
//        
    
    
//    }
    
    func getCategories(){
        
        
        categoryArray = realm.objects(CategoryR.self)
        
        tableView.reloadData()
    }
    
    
    
    
    

    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alertVC=UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        alertVC.addTextField { (textfield) in
            textfield.placeholder="Enter category here..."
        }
        
        
        let addButton=UIAlertAction(title: "Add", style: .default) { (add) in
            self.newCatgoryText=alertVC.textFields![0].text
//            let newCategory=Category(context: self.context)
            let newCategory=CategoryR()
            newCategory.name=self.newCatgoryText!
            
//            self.categoryArray.append(newCategory) // we don't need this as results is auto updating
            
            self.save(category: newCategory)
        }
        let cancelButton=UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertVC.addAction(addButton)
        alertVC.addAction(cancelButton)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Tableview Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoitems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC=segue.destination as! TodoListViewController
        let indexpath=tableView.indexPathForSelectedRow
        destinationVC.selectedCategory=categoryArray?[(indexpath?.row)!]
    }
}
