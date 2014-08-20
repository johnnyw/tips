//
//  SettingsViewController.swift
//  tips
//
//  Created by John Watson on 8/16/14.
//  Copyright (c) 2014 John Watson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    enum DecimalSeparators: String {
        case Comma = "Comma"
        case Period = "Period"
    }
    
    enum GroupingSeparators: String {
        case Comma = "Comma"
        case Period = "Period"
        case Space = "Space"
    }
    
    let darkModeEnabledKey = "darkModeEnabledKey"
    let decimalSeparatorKey = "decimalSeparatorKey"
    let groupingSeparatorKey = "groupingSeparatorKey"
    
    var decimalSeparator: String!
    var groupingSeparator: String!
    
    let decimalSeparatorIndices = [DecimalSeparators.Period.toRaw():0, DecimalSeparators.Comma.toRaw():1]
    let groupingSeparatorIndices = [GroupingSeparators.Comma.toRaw():0, GroupingSeparators.Period.toRaw():1, GroupingSeparators.Space.toRaw():2];
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var decimalSeparatorControl: UISegmentedControl!
    @IBOutlet weak var groupingSeparatorControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load defaults
        var defaults = NSUserDefaults.standardUserDefaults()
        
        darkModeSwitch.on = defaults.boolForKey(darkModeEnabledKey)
        
        decimalSeparator = defaults.stringForKey(decimalSeparatorKey)
        groupingSeparator = defaults.stringForKey(groupingSeparatorKey)
        
        if decimalSeparator == nil {
            decimalSeparator = DecimalSeparators.Period.toRaw()
        }
        
        if groupingSeparator == nil {
            groupingSeparator = GroupingSeparators.Comma.toRaw()
        }
        
        decimalSeparatorControl.selectedSegmentIndex = decimalSeparatorIndices[decimalSeparator]!
        groupingSeparatorControl.selectedSegmentIndex = groupingSeparatorIndices[groupingSeparator]!
    }

    @IBAction func decimalSeparatorChanged(sender: AnyObject) {
        let senderControl = sender as UISegmentedControl
        let newDecimalSeparator = senderControl.titleForSegmentAtIndex(senderControl.selectedSegmentIndex)
        
        // Make sure our decimal and grouping separators are not the same
        if(newDecimalSeparator == groupingSeparator) {
            let alertView = UIAlertView(title: "Woah, there!", message: "Grouping and decimal separators can't be the same.", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
            // Revert back to old selection
            senderControl.selectedSegmentIndex = decimalSeparatorIndices[decimalSeparator]!
        } else {
            decimalSeparator = newDecimalSeparator
        }
    }
    
    @IBAction func groupingSeparatorChanged(sender: AnyObject) {
        let senderControl = sender as UISegmentedControl
        let newGroupingSeparator = senderControl.titleForSegmentAtIndex(senderControl.selectedSegmentIndex)
        
        // Make sure our decimal and grouping separators are not the same
        if(newGroupingSeparator == decimalSeparator) {
            let alertView = UIAlertView(title: "Woah, there!", message: "Grouping and decimal separators can't be the same.", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
            // Revert back to old selection
            senderControl.selectedSegmentIndex = groupingSeparatorIndices[groupingSeparator]!
        } else {
            groupingSeparator = newGroupingSeparator
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    override func viewWillDisappear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(darkModeSwitch.on, forKey: darkModeEnabledKey)
        defaults.setObject(decimalSeparator, forKey: decimalSeparatorKey)
        defaults.setObject(groupingSeparator, forKey: groupingSeparatorKey)
        defaults.synchronize()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
