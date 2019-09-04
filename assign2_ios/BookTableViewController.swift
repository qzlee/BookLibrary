//
//  ViewController.swift
//  assign2_ios
//
//  Created by Qz Lee on 26/08/2018.
//  Copyright © 2018 Qz Lee. All rights reserved.
//

import UIKit
import CoreData

class BookTableViewController: UITableViewController {

    var appDelegate: AppDelegate!
    
    var managedContext: NSManagedObjectContext!
    
    var bookList: [Books] = []
    
    var selectedBook: Books!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error in app")
            return
        }
        
        appDelegate = delegate
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        
        do{
            bookList = try managedContext.fetch(fetchRequest) as! [Books]
        }catch{
            print("could not retrieve data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Books")
        
        do{
            bookList = try managedContext.fetch(fetchRequest) as! [Books]
        }catch{
            print("could not retrieve data")
        }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell!
        
        cell = tableView.dequeueReusableCell(withIdentifier: "BookCell")
        
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "BookCell")
        }
        
        let book = bookList[indexPath.row]
        
        //cell!.textLabel!.text = book.value(forKey: "title") as? String
        cell.textLabel!.text = book.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Books")
            fetchRequest.predicate = NSPredicate(format: "%K == %@", "title", bookList[indexPath.row].title! as CVarArg)
            do {
                let books = try managedContext.fetch(fetchRequest) as! [Books]
                
                if !books.isEmpty {
                    let foundBook = books[0]
                    managedContext.delete(foundBook as NSManagedObject)
                    self.bookList.remove(at: indexPath.row)

                    do {
                try managedContext.save()
            } catch {
                        print("Could not delete movie")
                    }
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                    print("Status: Book found")
                } else {
                    print("Status: Book not found")
                }
            } catch {
                    print("Status: could not retrieve searched data")
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {action, indexPath in     self.managedContext.delete(self.bookList[indexPath.row])
            do {
                try self.managedContext.save()
                self.tableView.reloadData()
                print("saved")
            } catch {
                print("fail to save")
            }
        })
        return [delete]
} */
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toDetail" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let detailVC = segue.destination as! BookDetailViewController
                    selectedBook = bookList[indexPath.row]
                    detailVC.selectedBook = selectedBook
                }
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func returnFromAddBook(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

