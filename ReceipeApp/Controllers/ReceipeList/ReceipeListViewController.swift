//
//  ReceipeListViewController.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit

class ReceipeListViewController: UIViewController {

    
    @IBOutlet weak var receipeListTableView: UITableView!
    
    @IBOutlet weak var pickerView: UIView!
    
    @IBOutlet weak var receipeTypePicker: UIPickerView!
    var receipeDetailsList: [ReceipeDetails] = []
    var filterDetailsList: [ReceipeDetails] = []
    var selectedDetail : ReceipeDetails?
    var selectedType : String = ""
    var receipeTypeList: [ReceipeTypeModel] = []
    
    //MARK: App Lifecyle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        uiConfig()
    }
    
    //MARK: UIConfiguration
    func uiConfig(){
        receipeListTableView.delegate   = self
        receipeListTableView.dataSource = self
        receipeTypePicker.delegate = self
        receipeTypePicker.dataSource = self
        pickerView.isHidden = true
        receipeListTableView.isHidden = false
        receipeListTableView.tableFooterView = UIView()
        filterDetailsList = receipeDetailsList
    }
    
    @IBAction func filterByAction(_ sender: UIBarButtonItem) {
        pickerView.isHidden = false
        receipeListTableView.isHidden = true
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        pickerView.isHidden = true
        receipeListTableView.isHidden = false
        filterDetailsList = receipeDetailsList.filter() { $0.type == selectedType }
        receipeListTableView.reloadData()
    }
    
    //MARK: UINavigation Segue Perform
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.selectedReceipeSegueId {
            let controller = segue.destination as? ReceipeAddViewController
            controller?.receipeTypeList = receipeTypeList
            controller?.selectedDetail = selectedDetail
            controller?.perform = "Update"
        }
    }
    
}

// MARK: - UITableView Delegate & Datasource Methods
extension ReceipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filterDetailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.receipeListTableViewCellId, for: indexPath) as! ReceipeListTableViewCell
        
        let receipeList = filterDetailsList[indexPath.row]
        cell.receipeNameLabel.text = receipeList.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedDetail = filterDetailsList[indexPath.row]
        performSegue(withIdentifier: Constants.selectedReceipeSegueId, sender: self)
    
    }
    
}

//MARK: UIPickerView Delegate & Datasource
extension ReceipeListViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return receipeTypeList.count
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedType = receipeTypeList[row].receipeName

    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return receipeTypeList[row].receipeName
    }
    
}
