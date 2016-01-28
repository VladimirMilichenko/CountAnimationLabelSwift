//
//  UILabel+CountAnimation.swift
//
//  Created by Vladimir Milichenko on 12/2/15.
//  Copyright © 2016 Vladimir Milichenko. All rights reserved.

//import UIKit

private struct AssociatedKeys {
    static var isAnimated = "isAnimated"
}

public extension UILabel {
    var isAnimated : Bool {
        get {
            guard let number = objc_getAssociatedObject(self, &AssociatedKeys.isAnimated) as? NSNumber else {
                return false
            }
            
            return number.boolValue
        }
        
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.isAnimated, NSNumber(bool: value), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func countAnimationWithDuration(duration: NSTimeInterval, numberFormatter: NSNumberFormatter?) {
        if !self.isAnimated {
            self.isAnimated = true
            
            let lastNumberSymbol = self.text!.substringFromIndex(self.text!.endIndex.predecessor())
            let textWidth = self.text!.sizeWithAttributes([NSFontAttributeName: self.font]).width
            let halfWidthsDiff = (self.frame.size.width - textWidth) / 2.0
            let lastNumberSymbolWidth = lastNumberSymbol.sizeWithAttributes([NSFontAttributeName: self.font]).width
            
            let textStorage = NSTextStorage(attributedString: self.attributedText!)
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            let textContainer = NSTextContainer(size: self.bounds.size)
            textContainer.lineFragmentPadding = 0
            layoutManager.addTextContainer(textContainer)
            let lastCharacterRange = NSRange(location: self.text!.characters.count - 1, length: 1)
            layoutManager.characterRangeForGlyphRange(lastCharacterRange, actualGlyphRange: nil)
            let lastNumberViewFrame = layoutManager.boundingRectForGlyphRange(lastCharacterRange, inTextContainer: textContainer)
            
            let lastNumberView = UIView(
                frame:CGRect(
                    x: lastNumberViewFrame.origin.x + self.frame.origin.x,
                    y: self.frame.origin.y,
                    width: lastNumberSymbolWidth + halfWidthsDiff,
                    height: self.frame.size.height
                )
            )
            
            lastNumberView.backgroundColor = UIColor.clearColor()
            lastNumberView.clipsToBounds = true
            
            let lastNumberUpperLabel = UILabel(
                frame: CGRect(
                    x: 0.0,
                    y: 0.0,
                    width: lastNumberView.frame.size.width,
                    height: lastNumberView.frame.size.height
                )
            )
            
            lastNumberUpperLabel.textAlignment = .Left;
            lastNumberUpperLabel.font = self.font;
            lastNumberUpperLabel.textColor = self.textColor;
            lastNumberUpperLabel.text = lastNumberSymbol;
            
            lastNumberView.addSubview(lastNumberUpperLabel)
            
            var lastNumber = Int(lastNumberSymbol)!
            lastNumber = lastNumber == 9 ? 0 : lastNumber + 1
            
            let lastNumberBottomLabel = UILabel(
                frame: CGRect(
                    x: lastNumberUpperLabel.frame.origin.x,
                    y: (lastNumberUpperLabel.frame.origin.y + lastNumberUpperLabel.frame.size.height) - (lastNumberUpperLabel.frame.size.height) / 4.0,
                    width: lastNumberUpperLabel.frame.size.width,
                    height: lastNumberUpperLabel.frame.size.height
                )
            )
            
            lastNumberBottomLabel.textAlignment = .Left;
            lastNumberBottomLabel.font = self.font;
            lastNumberBottomLabel.textColor = self.textColor;
            lastNumberBottomLabel.text = "\(lastNumber)"
            
            lastNumberView.addSubview(lastNumberBottomLabel)
            
            self.superview!.insertSubview(lastNumberView, belowSubview: self.superview!)
            
            let attributedText = NSMutableAttributedString(string: self.text!)
            
            attributedText.addAttribute(
                NSForegroundColorAttributeName,
                value: UIColor.clearColor(),
                range: lastCharacterRange
            )
            
            self.attributedText! = attributedText
            
            UIView.animateWithDuration(duration,
                animations: {
                    var lastNumberBottomLabelFrame = lastNumberBottomLabel.frame
                    lastNumberBottomLabelFrame.origin.y = lastNumberUpperLabel.frame.origin.y
                    lastNumberBottomLabel.frame = lastNumberBottomLabelFrame
                    
                    var lastNumberUpperLabelFrame = lastNumberUpperLabel.frame
                    lastNumberUpperLabelFrame.origin.y = lastNumberUpperLabel.frame.origin.y - lastNumberUpperLabel.frame.size.height;
                    lastNumberUpperLabel.frame = lastNumberUpperLabelFrame
                },
                completion: { [unowned self] finished in
                    var likesCount = numberFormatter != nil ? Int(numberFormatter!.numberFromString(self.text!)!) : Int(self.text!)
                    likesCount!++
                    self.text = numberFormatter != nil ? numberFormatter!.stringFromNumber(likesCount!) : "\(likesCount!)"
                    lastNumberView.removeFromSuperview()
                    
                    self.isAnimated = false
                }
            )
        }
    }
}