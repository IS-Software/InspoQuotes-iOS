//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by idStorm on 15.12.2021.
//

import UIKit

class QuoteTableViewController: UITableViewController {
    
    @IBOutlet weak var restoreButton: UIBarButtonItem!
    let shop = Shop()
    var purchaised: Bool = false {
        didSet {
            restoreButton.customView?.isHidden = purchaised
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shop.delegate = self
        purchaised = shop.isPurchaised
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Quotes.toShow.count
        return purchaised ? count : count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        if indexPath.row < Quotes.toShow.count {
            cell.textLabel?.text = Quotes.toShow[indexPath.row]
            cell.textLabel?.textColor = UIColor.black
            cell.accessoryType = .none
            cell.textLabel?.numberOfLines = 0
        } else {
            cell.textLabel?.text = "Get more quotes"
            cell.textLabel?.textColor = #colorLiteral(red: 0.1551266611, green: 0.6682294011, blue: 0.7508320212, alpha: 1)
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
    }
    
    //MARK: - TableView delegates
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Quotes.toShow.count {
            shop.buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }
}

extension QuoteTableViewController: IShopMessages {
    func purchaiseError(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func purchaiseComplete() {
        purchaised = true
    }
}
