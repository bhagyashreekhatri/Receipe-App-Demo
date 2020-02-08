//
//  Constants.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import Foundation
import Toast_Swift

class Constants: NSObject {

    static let receipeTypeTableViewCellId = "ReceipeTypeTableViewCellId"
    static let receipeListTableViewCellId = "ReceipeListTableViewCellId"
    static let receipeAddSegueId = "ReceipeAddViewControllerId"
    static let receipeListSegueId = "ReceipeListViewControllerId"
    static let selectedReceipeSegueId = "SelectedReceipeId"
    static let receipeElement = "Receipe"
    static let nameElement = "ReceipeName"
    static let imageElement = "ReceipeImgName"

//MARK: - Alert

    class func showToast(controller: UIViewController, message: String) {
        controller.view.makeToast(message, duration: 3.0, position: .center)
    }
}
