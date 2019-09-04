//
//  BookDetailViewController.swift
//  assign2_ios
//
//  Created by Qz Lee on 26/08/2018.
//  Copyright © 2018 Qz Lee. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var selectedBook: Books!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        
        if let book = selectedBook {
            titleLabel.text = book.title
            authorLabel.text = book.author
            priceLabel.text = String(book.price)
            categoryLabel.text = book.category
            statusLabel.text = book.status
            ratingLabel.text = book.rating
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editVC = segue.destination as! EditBookViewController
        editVC.selectedBook = selectedBook
    }
    
    @IBAction func returnEdit(segue: UIStoryboardSegue) {
        if let book = selectedBook {
            titleLabel.text = book.title
            authorLabel.text = book.author
            priceLabel.text = String(book.price)
            categoryLabel.text = book.category
            statusLabel.text = book.status
            ratingLabel.text = book.rating
        }
    }
}
