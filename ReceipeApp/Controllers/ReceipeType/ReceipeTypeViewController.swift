//
//  ReceipeTypeViewController.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import CoreData

class ReceipeTypeViewController: UIViewController {

    
    @IBOutlet weak var receipeTypeTableView: UITableView!
    
    var receipeTypeList: [ReceipeTypeModel] = []
    var receipeDetailsList: [ReceipeDetails] = []
    var elementName: String = String()
    var receipeName = String()
    var receipeImgName = String()
    
    
    //MARK: App Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()

        uiConfig()
    }
    
    //MARK: UIConfiguration Method

    func uiConfig(){
        receipeTypeTableView.delegate   = self
        receipeTypeTableView.dataSource = self
        receipeTypeTableView.tableFooterView = UIView()
        if let path = Bundle.main.url(forResource: "ReceipeType", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    //MARK: Fetch from core data
    
    func fetchFromStorage(type: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ReceipeDetails")
        if(type != "All"){
            request.predicate = NSPredicate(format: "type == %@", type)
        }
        
        request.returnsObjectsAsFaults = false
        
        do {
            let receipes = try managedContext?.fetch(request)
            receipeDetailsList = receipes as! [ReceipeDetails]
            if(receipeDetailsList.count != 0){
                performSegue(withIdentifier: Constants.receipeListSegueId, sender: self)
            }
            else{
                Constants.showToast(controller: self, message: "No Receipes added for this meal type")
            }
        } catch let error {
            print(error)
            Constants.showToast(controller: self, message: "Something went wrong")
        }
    }

    //MARK: UINavigation Segue Perform
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == Constants.receipeAddSegueId {
            let controller = segue.destination as? ReceipeAddViewController
            controller?.receipeTypeList = receipeTypeList
            controller?.perform = "Save"
        }
        else if segue.identifier == Constants.receipeListSegueId {
            let controller = segue.destination as? ReceipeListViewController
            controller?.receipeDetailsList = receipeDetailsList
            controller?.receipeTypeList = receipeTypeList
        }
    }
    
    //MARK: IBAction Methods

    @IBAction func addAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.receipeAddSegueId, sender: self)
    }
    
    @IBAction func allListAction(_ sender: UIBarButtonItem) {
        fetchFromStorage(type: "All")
    }
}

// MARK: - UITableView Delegate & Datasource Methods
extension ReceipeTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return receipeTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.receipeTypeTableViewCellId, for: indexPath) as! ReceipeTypeTableViewCell
        
        let receipeType = receipeTypeList[indexPath.row]
        cell.receipeTypeLabel.text = receipeType.receipeName
        cell.receipeImageView.image = UIImage.init(named: receipeType.receipeImgName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 130
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fetchFromStorage(type: receipeTypeList[indexPath.row].receipeName)
    }
    
}

//MARK: XMLPARSER Delegate Method
extension ReceipeTypeViewController: XMLParserDelegate{
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == Constants.receipeElement {
            receipeName = String()
            receipeImgName = String()
        }

        self.elementName = elementName
    }

   
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == Constants.receipeElement {
            let receipeType = ReceipeTypeModel(receipeName: receipeName,receipeImgName: receipeImgName)
            receipeTypeList.append(receipeType)
        }
        
    }

    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == Constants.nameElement {
                receipeName += data
            }else if self.elementName == Constants.imageElement {
                receipeImgName += data
            }
        }
    }
}
