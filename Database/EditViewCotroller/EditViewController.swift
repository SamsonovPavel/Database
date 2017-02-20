//
//  EditViewController.swift
//  Database
//
//  Created by Pavel Samsonov on 20.02.17.
//  Copyright © 2017 Pavel Samsonov. All rights reserved.
//

import UIKit

private let firstNameCellReuseIdentifier  = "FirstNameCell"
private let lastNameCellReuseIdentifier   = "LastNameCell"
private let patronymicCellReuseIdentifier = "PatronymicCell"
private let birthdayCellReuseIdentifier   = "BirthdayCell"
private let genderCellReuseIdentifier     = "GenderCell"

fileprivate let userDefault = UserDefaults.standard

protocol EditViewControllerDelegate {
    func updateUI()
}

class EditViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: EditViewControllerDelegate?
    var picker : UIPickerView!
    
    let pickerArr = ["Мужской" ,"Женский", "Не указан"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить",
                                                            style: .plain,
                                                           target: self,
                                                           action: #selector(saveContent))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveContent() {
        delegate?.updateUI()
         _ = navigationController?.popViewController(animated: true)
        picker.isHidden = true
    }
}

extension EditViewController: ViewControllerProtocol {
    static func storyBoardName() -> String {
        return "Main"
    }
}

extension EditViewController {
    func displayAlertToAddTaskList(task: String, indexPath: IndexPath) {
        let message = "Это действие приведет к изменению текущего поля."
        let titleOk = "Изменить"
        let titleCancel = "Отмена"
        
        if let picker = self.picker {
            picker.removeFromSuperview()
        }
        
        let alertController = UIAlertController(title: task, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in textField.placeholder = "Введите данные" }
        
        let alertCancel = UIAlertAction(title: titleCancel, style: .default, handler: nil)
        
        let alertOkAction = UIAlertAction(title: titleOk, style: .default) { [weak self] (action) in
            guard let sself = self else { return }
            let text = (alertController.textFields?.first?.text)!.capitalized
            
            switch indexPath.row {
            case rows.firstNameRow:
                let cell = sself.tableView.dequeueReusableCell(withIdentifier: firstNameCellReuseIdentifier, for: indexPath) as! FirstNameTVC
                userDefault.set(text, forKey: firstNameKey)
                cell.firstName.text = text
                
            case rows.lastNameRow:
                let cell = sself.tableView.dequeueReusableCell(withIdentifier: lastNameCellReuseIdentifier, for: indexPath) as! LastNameTVC
                userDefault.set(text, forKey: lastNameKey)
                cell.lastNameLabel.text = text
                
            case rows.patronymicRow:
                let cell = sself.tableView.dequeueReusableCell(withIdentifier: patronymicCellReuseIdentifier, for: indexPath) as! PatronymicTVC
                userDefault.set(text, forKey: patronymicKey)
                cell.patronymicLabel.text = text
                
            case rows.birthdayRow:
                let cell = sself.tableView.dequeueReusableCell(withIdentifier: birthdayCellReuseIdentifier, for: indexPath) as! BirthdayTVC
                
                let date = Date()
                let calendar = Calendar.current
                
                let year  = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day   = calendar.component(.day, from: date)
                
                let result = String(day) + "." + String(month) + "." + String(year)
                
                cell.birthdayLabel.text = result
                userDefault.set(result, forKey: birthdayKey)
                
            default: break
            }
            sself.tableView.reloadData()
            sself.delegate?.updateUI()
        }

        alertController.addAction(alertOkAction)
        alertController.addAction(alertCancel)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension EditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case rows.firstNameRow:
            displayAlertToAddTaskList(task: "Редактировать имя", indexPath: indexPath)
            
        case rows.lastNameRow:
            displayAlertToAddTaskList(task: "Редактировать фамилию", indexPath: indexPath)
            
        case rows.patronymicRow:
            displayAlertToAddTaskList(task: "Редактировать отчество", indexPath: indexPath)
            
        case rows.birthdayRow:
            displayAlertToAddTaskList(task: "Редактировать день рождения", indexPath: indexPath)
            
        case rows.genderRow:
            picker = UIPickerView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.frame.size.height - 216),
                                                size: CGSize(width: (self.view.frame.size.width), height: 216)))
            picker.delegate = self
            picker.dataSource = self
            
            self.view.addSubview(picker)
            
        default: break
        }
    }
}

extension EditViewController: UITableViewDataSource {
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

extension EditViewController {
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

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let cell = tableView.dequeueReusableCell(withIdentifier: genderCellReuseIdentifier, for: IndexPath(row: 4, section: 0)) as! GenderTVC
        cell.genderLabel.text = pickerArr[row]
        userDefault.set(pickerArr[row], forKey: genderKey)
        
        tableView.reloadData()
        delegate?.updateUI()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArr[row]
    }
}

















