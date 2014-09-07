//
//  DarkPlaceholderBackgroundTextField.swift
//  tips
//
//  Created by John Watson on 9/7/14.
//  Copyright (c) 2014 John Watson. All rights reserved.
//

import UIKit

class DarkPlaceholderBackgroundTextField: UITextField {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
    
    override func drawPlaceholderInRect(rect: CGRect) {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        style.alignment = self.textAlignment
        
        let attributes = [NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:UIColor.lightGrayColor(), NSFontAttributeName:self.font]
        let str = NSAttributedString(string: self.placeholder!, attributes: attributes)
        str.drawInRect(rect)
    }

}
