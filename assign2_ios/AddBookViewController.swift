//
//  AddBookViewController.swift
//  assign2_ios
//
//  Created by Qz Lee on 26/08/2018.
//  Copyright © 2018 Qz Lee. All rights reserved.
//

import UIKit
import CoreData

class AddBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    var appDelegate: AppDelegate!
    
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var authorTxtField: UITextField!
    @IBOutlet weak var priceTxtField: UITextField!
    @IBOutlet weak var categoryTxtField: UITextField!
    @IBOutlet weak var statusTxtField: UITextField!
    @IBOutlet weak var ratingTxtField: UITextField!
    
    @IBOutlet weak var categoryPickerView: UIPickerView!
    @IBOutlet weak var statusPickerView: UIPickerView!
    @IBOutlet weak var ratingPickerView: UIPickerView!
    
    var category = ["Action","Art","Comic","Drama","Gudie","Health","History","Journal","Mystery","Religion","Science","Travel","Other"]
    
    var status = ["completed reading","not started","currently reading"]
    
    var rating = ["1★","2★","3★","4★","5★"]
    
    override func viewDidLoad() {
        
        authorTxtField.delegate = self
        categoryTxtField.delegate = self
        statusTxtField.delegate = self
        ratingTxtField.delegate = self
        
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
        ratingPickerView.delegate = self
        ratingPickerView.dataSource = self
        
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error in app")
            return
        }
        appDelegate = delegate
        managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        var countrow:Int = self.category.count
        
        if pickerView == statusPickerView {
            countrow = self.status.count
        }
        
        if pickerView == ratingPickerView {
            countrow = self.rating.count
        }
        
        return countrow
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == categoryPickerView {
            
            let titleRow = category[row]
            return titleRow
        }
        else if pickerView == statusPickerView {
            let titleRow = status[row]
            return titleRow
        }
        else if pickerView == ratingPickerView {
            let titleRow = rating[row]
            return titleRow
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == categoryPickerView {
            
            self.categoryTxtField.text = self.category[row]
            self.categoryPickerView.isHidden = true
            
        } else if pickerView == statusPickerView {
            
            self.statusTxtField.text = self.status[row]
            self.statusPickerView.isHidden = true
            
        } else if pickerView == ratingPickerView {
            
            self.ratingTxtField.text = self.rating[row]
            self.ratingPickerView.isHidden = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.categoryTxtField {
            textField.endEditing(true)
            self.categoryPickerView.isHidden = false
            textField.endEditing(true)
            
        } else if textField == self.statusTxtField {
            self.statusPickerView.isHidden = false
            textField.endEditing(true)
            
        } else if textField == self.ratingTxtField {
            self.ratingPickerView.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let entity = NSEntityDescription.entity(forEntityName: "Books", in: managedContext)!
        let books = NSManagedObject(entity: entity, insertInto: managedContext)
        
        if let title = (titleTxtField.text) {
            books.setValue(title, forKey: "title")
            books.setValue(categoryTxtField.text, forKey: "category")
            books.setValue(Double(priceTxtField.text!), forKey: "price")
            books.setValue(statusTxtField.text, forKey: "status")
            books.setValue(ratingTxtField.text, forKey: "rating")
            books.setValue(authorTxtField.text, forKey: "author")
        }
        do {
            try managedContext.save()
            clearText()
            print("Status: Data saved")
        } catch {
            print("Status: Could not save data")
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        clearText()
    }
    
    func clearText() {
        titleTxtField.text = ""
        categoryTxtField.text = ""
        priceTxtField.text = ""
        ratingTxtField.text = ""
        statusTxtField.text = ""
        authorTxtField.text = ""
    }
}
