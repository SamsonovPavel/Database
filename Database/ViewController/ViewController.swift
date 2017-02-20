//
//  ViewController.swift
//  Database
//
//  Created by Pavel Samsonov on 18.02.17.
//  Copyright © 2017 Pavel Samsonov. All rights reserved.
//

import UIKit

private let firstNameCellReuseIdentifier  = "FirstNameCell"
private let lastNameCellReuseIdentifier   = "LastNameCell"
private let patronymicCellReuseIdentifier = "PatronymicCell"
private let birthdayCellReuseIdentifier   = "BirthdayCell"
private let genderCellReuseIdentifier     = "GenderCell"

fileprivate let userDefault = UserDefaults.standard

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsSelection = false
        
        let firstNameNib = UINib(nibName: "FirstNameTVC", bundle: nil)
        tableView.register(firstNameNib, forCellReuseIdentifier: firstNameCellReuseIdentifier)
        
        let lastNameNib = UINib(nibName: "LastNameTVC", bundle: nil)
        tableView.register(lastNameNib, forCellReuseIdentifier: lastNameCellReuseIdentifier)
        
        let patronymicNib = UINib(nibName: "PatronymicTVC", bundle: nil)
        tableView.register(patronymicNib, forCellReuseIdentifier: patronymicCellReuseIdentifier)
        
        let birthdayNib = UINib(nibName: "BirthdayTVC", bundle: nil)
        tableView.register(birthdayNib, forCellReuseIdentifier: birthdayCellReuseIdentifier)
        
        let genderNib = UINib(nibName: "GenderTVC", bundle: nil)
        tableView.register(genderNib, forCellReuseIdentifier: genderCellReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        let editVC = EditViewController.create() as! EditViewController
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
}

extension ViewController: EditViewControllerDelegate {
    func updateUI() {
        self.tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case rows.firstNameRow:
            cell = tableView.dequeueReusableCell(withIdentifier: firstNameCellReuseIdentifier, for: indexPath) as! FirstNameTVC
            configureFirstNameCell(cell: cell as! FirstNameTVC, indexPath: indexPath)
            
        case rows.lastNameRow:
            cell = tableView.dequeueReusableCell(withIdentifier: lastNameCellReuseIdentifier, for: indexPath) as! LastNameTVC
            configureLastNameCell(cell: cell as! LastNameTVC, indexPath: indexPath)
            
        case rows.patronymicRow:
            cell = tableView.dequeueReusableCell(withIdentifier: patronymicCellReuseIdentifier, for: indexPath) as! PatronymicTVC
            configurePatronymicCell(cell: cell as! PatronymicTVC, indexPath: indexPath)
            
        case rows.birthdayRow:
            cell = tableView.dequeueReusableCell(withIdentifier: birthdayCellReuseIdentifier, for: indexPath) as! BirthdayTVC
            configureBirthdayCell(cell: cell as! BirthdayTVC, indexPath: indexPath)
            
        case rows.genderRow:
            cell = tableView.dequeueReusableCell(withIdentifier: genderCellReuseIdentifier, for: indexPath) as! GenderTVC
            configureGenderCell(cell: cell as! GenderTVC, indexPath: indexPath)
            
        default: break
        }
        return cell
    }
}

extension ViewController {
    func configureFirstNameCell(cell: FirstNameTVC, indexPath: IndexPath) {
        
        let string = userDefault.value(forKey: firstNameKey) as? String
        
        if let text = string {
            cell.firstName.text = text
        } else {
            cell.firstName.text = firstName
        }
    }
    
    func configureLastNameCell(cell: LastNameTVC, indexPath: IndexPath) {
        let string = userDefault.value(forKey: lastNameKey) as? String
        
        if let text = string {
            cell.lastNameLabel.text = text
        } else {
            cell.lastNameLabel.text = lastName
        }
    }
    
    func configurePatronymicCell(cell: PatronymicTVC, indexPath: IndexPath) {
        let string = userDefault.value(forKey: patronymicKey) as? String
        
        if let text = string {
            cell.patronymicLabel.text = text
        } else {
            cell.patronymicLabel.text = patronymic
        }
    }
    
    func configureBirthdayCell(cell: BirthdayTVC, indexPath: IndexPath) {
        let string = userDefault.value(forKey: birthdayKey) as? String
        
        if let text = string {
            cell.birthdayLabel.text = text
        } else {
            cell.birthdayLabel.text = birhday
        }
    }
    
    func configureGenderCell(cell: GenderTVC, indexPath: IndexPath) {
        let string = userDefault.value(forKey: genderKey) as? String
        
        if let text = string {
            cell.genderLabel.text = text
        } else {
            cell.genderLabel.text = gender
        }
    }
}






































