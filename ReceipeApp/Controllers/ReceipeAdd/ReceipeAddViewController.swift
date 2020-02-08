//
//  ReceipeAddViewController.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import CoreData

class ReceipeAddViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIView!
    @IBOutlet weak var receipeTypePicker: UIPickerView!
    @IBOutlet weak var selectTypeTxtField: UITextField!
    @IBOutlet weak var nameTxtField: UITextField!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var stepsTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var performButton: UIButton!
    
    var receipeTypeList: [ReceipeTypeModel] = []
    var selectedDetail : ReceipeDetails?
    
    var perform : String = ""
    
    //MARK: App Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        uiConfig()
    }
    
    //MARK: UIConfiguration Method
    func uiConfig(){
        pickerView.isHidden = true
        receipeTypePicker.delegate   = self
        receipeTypePicker.dataSource = self
        selectTypeTxtField.delegate = self
        nameTxtField.delegate = self
        validations()
         
    }
    
    func validations(){
       if(perform == "Save"){
            performButton.setTitle("Save",for: .normal)
            deleteButton.isHidden = true
        }
         else{
            performButton.setTitle("Update",for: .normal)
            deleteButton.isHidden = false
            nameTxtField.text = selectedDetail?.name
            stepsTextView.text = selectedDetail?.steps
            ingredientsTextView.text = selectedDetail?.ingredients
            selectTypeTxtField.text = selectedDetail?.type
        }
    }
    
    //MARK: IBAction Method
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        pickerView.isHidden = true
    }
    
    
    @IBAction func performAction(_ sender: UIButton) {
        if(perform == "Save"){
            save()
        }
        else{
            if let id = selectedDetail?.id {
                update(id: id)
            }
        }
    }
    
    
    @IBAction func deleteAction(_ sender: UIButton) {
        if let id = selectedDetail?.id {
            delete(id: id)
        }
    }
    
    //MARK: Update in core data
    
    func update(id:Int16){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReceipeDetails")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        if let result = try? context?.fetch(request) {
        let resultData = result as! [ReceipeDetails]
        for object in resultData {
            print(object.id)
            if object.id == id {
                object.setValue(ingredientsTextView.text, forKey: "ingredients")
                object.setValue(nameTxtField.text, forKey: "name")
                object.setValue(stepsTextView.text, forKey: "steps")
                object.setValue(selectTypeTxtField.text, forKey: "type")
            }
        }
        do {
            try context?.save()
            print("saved!")
            Constants.showToast(controller: self, message: "Updated Successfully")
            self.navigationController?.popToRootViewController(animated: false)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        }
    }
    //MARK: Delete in core data
    
    func delete(id:Int16){
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReceipeDetails")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        if let result = try? context?.fetch(request) {
        for object in result {
            context?.delete(object as! NSManagedObject)
           
        }
            do {
                try context?.save()
                Constants.showToast(controller: self, message: "Deleted Successfully")
                self.navigationController?.popToRootViewController(animated: false)
            } catch let error {
                print(error)
                Constants.showToast(controller: self, message: "Something went wrong")
            }
        }
    }
    
    //MARK: Save in core data
    
    func save(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ReceipeDetails", in: context)
        let newReceipe = NSManagedObject(entity: entity!, insertInto: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReceipeDetails")
        let idDescriptor: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [idDescriptor]
        request.fetchLimit = 1
        var newId = 0; // Default to 0, so that you can check if do catch block went wrong later
        do {
            let results = try context.fetch(request)

            //Compute the id
            if(results.count == 1){
                newId = Int((results[0] as! ReceipeDetails).id + 1)
            }
            else{
                newId = 1
            }

        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }

        newReceipe.setValue(newId, forKey: "id")
        newReceipe.setValue(ingredientsTextView.text, forKey: "ingredients")
        newReceipe.setValue(nameTxtField.text, forKey: "name")
        newReceipe.setValue(stepsTextView.text, forKey: "steps")
        newReceipe.setValue(selectTypeTxtField.text, forKey: "type")

        do {
            try context.save()
            Constants.showToast(controller: self, message: "Added Successfully")
            self.navigationController?.popViewController(animated: false)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            Constants.showToast(controller: self, message: "\(error.userInfo)")
        }
    }
}

//MARK: UIPickerView Delegate & Datasource
extension ReceipeAddViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return receipeTypeList.count
    }
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectTypeTxtField.text = receipeTypeList[row].receipeName

    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return receipeTypeList[row].receipeName
    }
    
}

//MARK: UITextField Delegate
extension ReceipeAddViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 {
            pickerView.isHidden = false
            textField.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
}
