//
//  ViewController.swift
//  tips
//
//  Created by John Watson on 8/15/14.
//  Copyright (c) 2014 John Watson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var twoPersonTotalLabel: UILabel!
    @IBOutlet weak var threePersonTotalLabel: UILabel!
    @IBOutlet weak var fourPersonTotalLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var displayView: UIView!
    
    let animationOffset: CGFloat = 100
    let currencyFormatter = NSNumberFormatter()
    var currentLocale = NSLocale.currentLocale()
    
    var showDisplayView: Bool = false
    
    // Copypasta (since class variables are apparently "not yet supported")
    let darkModeEnabledKey = "darkModeEnabledKey"
    let decimalSeparatorKey = "decimalSeparatorKey"
    let groupingSeparatorKey = "groupingSeparatorKey"
    
    var decimalSeparator: String!
    var groupingSeparator: String!
    var currencySymbol: String!
    var darkModeEnabled: Bool = false
    
    let separators = ["Comma":",", "Space":" ", "Period":"."]
    
    var currencySymbolTable: [String:String] = [:]
    
    func getCurrencySymbol(code: String!) -> String {
        return "$" // TODO implement
//        if code == nil {
//            return "$"
//        }
//        
//        if currencySymbolTable.isEmpty {
//            // populate currency symbol table
//            let identifiers = NSLocale.availableLocaleIdentifiers()
//            for id in identifiers {
//                // println("Identifier: " + (id as String))
//                let locale = NSLocale.localeWithLocaleIdentifier(id as String)
//                let currencyCode = locale.displayNameForKey(NSLocaleCurrencyCode, value: id as String)
//                let currencySymbol = locale.displayNameForKey(NSLocaleCurrencySymbol, value: id as String)
//                if currencyCode != nil {
//                    currencySymbolTable[currencyCode] = currencySymbol
//                }
//            }
//        }
//        
//        if currencySymbolTable[code] == nil {
//            return "$"
//        }
//        
//        return currencySymbolTable[code]!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize currency formatter
        currencyFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        // currencyFormatter.locale = currentLocale
        
        
        // tipLabel.text = currencyFormatter.stringFromNumber(0.00)
        // totalLabel.text = currencyFormatter.stringFromNumber(0.00)
        
        if billField.text.isEmpty {
            showDisplayView = false
            UIView.animateWithDuration(0, animations: {
                var controlFrame: CGRect = self.tipControl.frame
                var displayFrame: CGRect = self.displayView.frame
                var fieldFrame: CGRect = self.billField.frame
                
                controlFrame.origin.y += self.animationOffset
                displayFrame.origin.y += self.animationOffset
                fieldFrame.origin.y += self.animationOffset
                
                self.tipControl.frame = controlFrame
                self.displayView.frame = displayFrame
                self.billField.frame = fieldFrame
                
                self.tipControl.alpha = 0
                self.displayView.alpha = 0
            })
        } else {
            showDisplayView = true
        }
        
        billField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear() called")
        // Load custom settings
        var defaults = NSUserDefaults.standardUserDefaults()
        
        currencySymbol = getCurrencySymbol(defaults.stringForKey("currency"))
        
        darkModeEnabled = defaults.boolForKey(darkModeEnabledKey)
        
        if darkModeEnabled {
            self.view.backgroundColor = UIColor.blackColor()
            self.billField.textColor = UIColor.whiteColor()
            self.billField.backgroundColor = UIColor.blackColor()
        } else {
            self.view.backgroundColor = UIColor.whiteColor()
            self.billField.textColor = UIColor.blackColor()
            self.billField.backgroundColor = UIColor.whiteColor()
        }
        
        decimalSeparator = defaults.stringForKey(decimalSeparatorKey)
        groupingSeparator = defaults.stringForKey(groupingSeparatorKey)
        
        if decimalSeparator == nil {
            decimalSeparator = "Period"
        }
        
        if groupingSeparator == nil {
            groupingSeparator = "Comma"
        }
        
        // Setup number formatter according to settings
        currencyFormatter.groupingSeparator = separators[groupingSeparator]
        currencyFormatter.decimalSeparator = separators[decimalSeparator]
        
        // Update total displays, if we're transitioning back from settings
        self.onEditingChanged(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onEditingChanged(sender: AnyObject) {
        let animationTime: NSTimeInterval = 0.4
        
        if billField.text.isEmpty {
            UIView.animateWithDuration(animationTime, animations: {
                if self.showDisplayView {
                    var controlFrame: CGRect = self.tipControl.frame
                    var displayFrame: CGRect = self.displayView.frame
                    var fieldFrame: CGRect = self.billField.frame
                    
                    controlFrame.origin.y += self.animationOffset
                    displayFrame.origin.y += self.animationOffset
                    fieldFrame.origin.y += self.animationOffset
                    
                    self.tipControl.frame = controlFrame
                    self.displayView.frame = displayFrame
                    self.billField.frame = fieldFrame
                    
                    self.tipControl.alpha = 0.0
                    self.displayView.alpha = 0.0
                    self.showDisplayView = false
                }
            })
        } else {
            UIView.animateWithDuration(animationTime, animations: {
                if !self.showDisplayView {
                    var controlFrame: CGRect = self.tipControl.frame
                    var displayFrame: CGRect = self.displayView.frame
                    var fieldFrame: CGRect = self.billField.frame
                    
                    controlFrame.origin.y -= self.animationOffset
                    displayFrame.origin.y -= self.animationOffset
                    fieldFrame.origin.y -= self.animationOffset
                    
                    self.tipControl.frame = controlFrame
                    self.displayView.frame = displayFrame
                    self.billField.frame = fieldFrame
                    
                    self.tipControl.alpha = 1.0
                    self.displayView.alpha = 1.0
                    self.showDisplayView = true
                }
            })
        }
        
        let tipPercentages = [0.18, 0.2, 0.22]
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount = (billField.text as NSString).doubleValue
        let tip = billAmount * tipPercentage
        let total = billAmount + tip
        let twoPersonTotal = total / 2.0
        let threePersonTotal = total / 3.0
        let fourPersonTotal = total / 4.0
        
        tipLabel.text = currencySymbol + currencyFormatter.stringFromNumber(tip)
        totalLabel.text = currencySymbol + currencyFormatter.stringFromNumber(total)
        twoPersonTotalLabel.text = currencySymbol + currencyFormatter.stringFromNumber(twoPersonTotal)
        threePersonTotalLabel.text = currencySymbol + currencyFormatter.stringFromNumber(threePersonTotal)
        fourPersonTotalLabel.text = currencySymbol + currencyFormatter.stringFromNumber(fourPersonTotal)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}
