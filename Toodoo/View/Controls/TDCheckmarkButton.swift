//
//  CheckmarkButton.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit


class TDCheckmarkButton: UIButton {
    
    var width: CGFloat?
    var height: CGFloat?
    
    fileprivate var circleLayer = CAShapeLayer()
        fileprivate var fillCircleLayer = CAShapeLayer()
        override var isSelected: Bool {
            didSet {
                toggleButon()
            }
        }
        /**
         Color of the radio button circle. Default value is UIColor red.
         */
    @IBInspectable var circleColor: UIColor = UIColor.secondaryLabel {
        didSet {
            circleLayer.strokeColor = strokeColor.cgColor
            self.toggleButon()
        }
    }
    
    /**
     Color of the radio button stroke circle. Default value is UIColor red.
     */
    @IBInspectable var strokeColor: UIColor = UIColor.secondaryLabel {
        didSet {
            circleLayer.strokeColor = strokeColor.cgColor
            self.toggleButon()
        }
    }
    
    /**
     Radius of TDCheckmarkButton circle.
     */
    @IBInspectable var circleRadius: CGFloat = 5.0
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    fileprivate func circleFrame() -> CGRect {
        var frame: CGRect!
        if width != nil && height != nil {
            frame = CGRect(x: 0, y: 0, width: self.width!, height: self.height!)
        } else {
            frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 4)
        }
        var circleFrame = frame
        circleFrame!.origin.x = 0 + circleLayer.lineWidth
        circleFrame!.origin.y = bounds.height/2 - circleFrame!.height/2
        return circleFrame!
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        circleLayer.frame = bounds
        circleLayer.lineWidth = 1
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = strokeColor.cgColor
        layer.addSublayer(circleLayer)
        fillCircleLayer.frame = bounds
        fillCircleLayer.lineWidth = 1
        fillCircleLayer.fillColor = UIColor.clear.cgColor
        fillCircleLayer.strokeColor = UIColor.clear.cgColor
        layer.addSublayer(fillCircleLayer)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (4*circleRadius + 4*circleLayer.lineWidth), bottom: 0, right: 0)
        self.toggleButon()
    }
    /**
     Toggles selected state of the button.
     */
    func toggleButon() {
        if self.isSelected {
            fillCircleLayer.fillColor = circleColor.cgColor
            circleLayer.strokeColor = circleColor.cgColor
        } else {
            fillCircleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }
    
    fileprivate func fillCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: 2, dy: 2))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleLayer.frame = bounds
        circleLayer.path = circlePath().cgPath
        fillCircleLayer.frame = bounds
        fillCircleLayer.path = fillCirclePath().cgPath
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: (2*circleRadius + 4*circleLayer.lineWidth), bottom: 0, right: 0)
    }
    
    override func prepareForInterfaceBuilder() {
        initialize()
    }
}
