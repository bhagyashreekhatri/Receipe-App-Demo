//
//  IBRecipeAppTextView.swift
//  ReceipeApp
//
//  Created by Bhagyashree Haresh Khatri on 08/02/2020.
//  Copyright © 2020 Bhagyashree Haresh Khatri. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class IBRecipeAppTextView: UITextView {

    /* The view radius. Defaults to 0. Animatable. */
    @IBInspectable
    public var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
            clipsToBounds = true
        }
        get {
            return layer.cornerRadius
        }
    }

    /* The view border color. Defaults to opaque black. Animatable. */
    @IBInspectable public var borderColor: UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    /* The view border. Defaults to 0. Animatable. */
    @IBInspectable public var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }

    /* The color of the shadow. Defaults to opaque black. Colors created
     * from patterns are currently NOT supported. Animatable. */
    @IBInspectable
    open var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
            clipsToBounds = false
            for view in subviews {
                view.clipsToBounds = true
            }
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }

    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable
    open var shadowOffset: CGPoint {
        set {
            layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y: layer.shadowOffset.height)
        }
    }

    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable
    open var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }

    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable
    open var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
}
