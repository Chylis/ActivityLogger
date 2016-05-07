//: Playground - noun: a place where people can play

import UIKit
import XCPlayground


let size: Double = 400
let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0,
    width: size, height: size))
containerView.backgroundColor = UIColor.whiteColor()
let page = XCPlaygroundPage.currentPage
page.liveView = containerView


let checkmarkView = UIView(frame: CGRect(x: size/2-size/4, y: size/2-size/4, width: size/2, height: size/2))
checkmarkView.backgroundColor = UIColor.whiteColor()
containerView.addSubview(checkmarkView)


let shapeLayer = CAShapeLayer()
shapeLayer.strokeColor = UIColor.greenColor().CGColor
shapeLayer.fillColor = nil
shapeLayer.lineWidth = 5
let width = checkmarkView.bounds.width
let height = checkmarkView.bounds.height

let checkmarkPath = UIBezierPath()
checkmarkPath.moveToPoint(CGPointMake(width, 0))
checkmarkPath.addLineToPoint(CGPointMake(width/2, height/2))
checkmarkPath.addLineToPoint(CGPointMake(width/3, height/3))
checkmarkView.layer.addSublayer(shapeLayer)

// Draw the lines.
let aPath = UIBezierPath()
aPath.moveToPoint(CGPointMake(width, 0))
aPath.addLineToPoint(CGPointMake(width, 1))
//aPath.closePath()

shapeLayer.path = checkmarkPath.CGPath
let anim = CABasicAnimation(keyPath: "strokeEnd")
anim.fromValue = 0
anim.toValue = 1
anim.duration = 0.7
anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
shapeLayer.addAnimation(anim, forKey: nil)


//CATransaction.begin()
//CATransaction.commit()


