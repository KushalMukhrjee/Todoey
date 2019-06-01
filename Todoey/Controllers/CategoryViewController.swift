//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kushal Mukherjee on 25/05/19.
//  Copyright © 2019 Kushal Mukherjee. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    
    var newCatgoryText:String?
    let context=(UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray:[Category]=[]
    
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "categorycell", for: indexPath)
        
        cell.textLabel?.text=categoryArray[indexPath.row].name
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories(){
        
        do{
            try context.save()
            
        }
        catch{
            print("Error saving categories:\(error)")
        }
        
        tableView.reloadData()
        
        
    }
    
    func getCategories(with fetchRequest:NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray=try context.fetch(fetchRequest)
        }
        catch{
            print("Error fetching categories:\(error)")
        }
        
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
            let newCategory=Category(context: self.context)
            newCategory.name=self.newCatgoryText
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
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
        destinationVC.selectedCategory=categoryArray[(indexpath?.row)!]
    }
}
