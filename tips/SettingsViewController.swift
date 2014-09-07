//
//  SettingsViewController.swift
//  tips
//
//  Created by John Watson on 8/16/14.
//  Copyright (c) 2014 John Watson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let darkModeEnabledKey = "darkModeEnabledKey"
    let numberFormatKey = "numberFormatKey"
    
    let reuseIdentifier = "NumberFormatCell"
    
    let numberFormats = ["1,000,000.00", "1 000 000.00", "1.000.000,00"]
    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var numberFormatTable: UITableView!
    
    // MARK: - table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberFormats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = numberFormats[indexPath.item]
        return cell
    }
    
    // MARK: - table view delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Number format: \(indexPath.item)")
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load defaults
        var defaults = NSUserDefaults.standardUserDefaults()
        
        darkModeSwitch.on = defaults.boolForKey(darkModeEnabledKey)
                
        self.numberFormatTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.numberFormatTable.delegate = self
        self.numberFormatTable.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectNumberFormat(index: Int) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.numberFormatTable.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: UITableViewScrollPosition.None)
        self.tableView(self.numberFormatTable, didSelectRowAtIndexPath: indexPath)
    }

    // MARK: - Navigation
    override func viewWillAppear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        selectNumberFormat(defaults.integerForKey(numberFormatKey))
    }
    
    override func viewWillDisappear(animated: Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(darkModeSwitch.on, forKey: darkModeEnabledKey)
        
        if let indexPath = self.numberFormatTable.indexPathForSelectedRow() {
            NSLog("Setting number key to \(indexPath.item)")
            defaults.setInteger(indexPath.item, forKey: numberFormatKey)
        }
        
        defaults.synchronize()
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }

}
