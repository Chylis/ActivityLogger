//
//  CubeContainerViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 31/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit

protocol CubeContainerDataSource {
    
    //Called during an interactive transition to fetch the next view controller
    func cubeContainerViewController(cubeContainerViewController: CubeContainerViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
}

private enum CubeSide: Int {
    case Front = 0
    case Right
    case Back
    case Left
    case Count
    
    func nextSide() -> CubeSide {
        switch self {
        case .Front:    return .Right
        case .Right:    return .Back
        case .Back:     return .Left
        case .Left:     return .Front
        default:        return .Front
        }
    }
    
    func prevSide() -> CubeSide {
        switch self {
        case .Front:    return .Left
        case .Right:    return .Front
        case .Back:     return .Right
        case .Left:     return .Back
        default:        return .Front
        }
    }

    /**
     Returns the cube-transform for the given cube side
     */
    func viewTransform(parentView: UIView) -> CATransform3D {
        let horizontalDistance = parentView.bounds.size.width / 2.0

        switch self {
        case .Front:
            return CATransform3DMakeTranslation(0, 0, horizontalDistance) //y 0 degrees, z 'distance' units (towards camera)
        case .Right:
            let transform = CATransform3DMakeTranslation(horizontalDistance, 0, 0) //x 'distance' units (right)
            return CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0) //y 90 degrees
        case .Left:
            let transform = CATransform3DMakeTranslation(-horizontalDistance, 0, 0) //x -'distance' units (left)
            return CATransform3DRotate(transform, CGFloat(-M_PI_2), 0, 1, 0) //y -90 degrees
        case .Back:
            let transform = CATransform3DMakeTranslation(0, 0, -horizontalDistance) //z -'distance' units (away from camera)
            return CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0) //y 180 degrees (mirrored)
        default:
            return CATransform3DIdentity
        }
    }
    
    /**
     Returns the perspective transform required to see the view at each side
     */
    func perspectiveTransform() -> CATransform3D {
        switch self {
        case .Front:
            return CATransform3DIdentity
        case .Right:
            return CATransform3DMakeRotation(CGFloat(-M_PI_2), 0, 1, 0) // y - 90 degrees
        case .Left:
            return CATransform3DMakeRotation(CGFloat(M_PI_2), 0, 1, 0) //y 90 degrees
        case .Back:
            return CATransform3DMakeRotation(CGFloat(M_PI), 0, 1, 0) //y 180 degrees
        default:
            return CATransform3DIdentity
        }
    }
}

class CubeContainerViewController: UIViewController {
    
    //MARK: Properties
    
    let containerView = UIView()
    var dataSource: CubeContainerDataSource?
    var rightScreenEdgeRecognizer, leftScreenEdgeRecognizer: UIScreenEdgePanGestureRecognizer?

    //Initial view controller
    private let rootViewController: UIViewController
    
    //The currently presented side of the cube
    private var currentSide = CubeSide.Front
    
    //Called after a rotation animation has completed successfully
    private var rotationCompletionBlock: (() -> Void)?
    
    //Animation key-value keys
    private let animationIdentifier = "rotateCubeAnimation"
    private let animationKeyFinalSide = "rotateCubeAnimationFinalTransform"
    
    
    
    
    
    
    
    
    
    //MARK: Creation
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewController: UIViewController) {
        rootViewController = viewController
        super.init(nibName:nil, bundle:nil)
    }
    
    
    
    
    
    
    
    
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerSubview(containerView, superview:view, topAnchor:topLayoutGuide.bottomAnchor)
        applyPerspective()
        addGestureRecognizers()
        addViewControllerToCube(rootViewController, transform: currentSide.viewTransform(view))
    }
    
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        applyCubeTransforms()
    }
    
    private func applyCubeTransforms() {
        for var i = 0; i < childViewControllers.count; i++ {
            let cubeSide = CubeSide(rawValue: i)
            let viewControllerAtIndex = childViewControllers[i]
            viewControllerAtIndex.view.layer.transform = cubeSide!.viewTransform(view)
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Public
    
    /**
    Returns the currently presented view controller
    */
    func currentViewController() -> UIViewController {
        let current = childViewControllers.last!
        return current
    }
    
    /**
     Rotates the cube forward if possible.
     Disables user interaction so that the newest view may receive touches.
    */
    func navigateToViewController(viewController: UIViewController) {
        let canAddMoreChildren = childViewControllers.count < CubeSide.Count.rawValue
        
        if  canAddMoreChildren {
            currentViewController().view.userInteractionEnabled = false
            addViewControllerToCube(viewController, transform: currentSide.nextSide().viewTransform(containerView))
            performScaleAndRotateAnimation(currentSide, toSide: currentSide.nextSide())
        }
    }
    
    /**
     Rotates the cube backward and removes the latest view controller if rotation was successful.
     */
    func navigateToPreviousViewController() {
        let hasPreviousChildren = childViewControllers.count > 1
        
        if hasPreviousChildren {
            rotationCompletionBlock =  {
                self.removeViewControllerFromCube(self.currentViewController())
            }
            
            performScaleAndRotateAnimation(currentSide, toSide: currentSide.prevSide())
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: Setup
    
    /**
    Applies camera perspective
    */
    private func applyPerspective() {
        var perspective = CATransform3DIdentity
        perspective.m34 = -1/50000 //After testing, 50000 seems to be a good value
        containerView.layer.sublayerTransform = perspective
    }
    
    
    private func addGestureRecognizers() {
        leftScreenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePanned:")
        leftScreenEdgeRecognizer!.edges = .Left
        containerView.addGestureRecognizer(leftScreenEdgeRecognizer!)
        
        rightScreenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePanned:")
        rightScreenEdgeRecognizer!.edges = .Right
        containerView.addGestureRecognizer(rightScreenEdgeRecognizer!)
    }
    
    private func addViewControllerToCube(viewController: UIViewController, transform: CATransform3D) {
        addChildViewController(viewController)
        centerSubview(viewController.view, superview:containerView)
        viewController.view.layer.transform = transform
        viewController.didMoveToParentViewController(self)
    }
    
    private func removeViewControllerFromCube(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    
    private func centerSubview(subview: UIView, superview: UIView, topAnchor: NSLayoutAnchor? = nil) {
        superview.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            subview.leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor),
            subview.trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor),
            subview.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor),
            subview.topAnchor.constraintEqualToAnchor(topAnchor ?? superview.topAnchor)
            ])
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Interactive animation related
    
    func onEdgePanned(sender: UIScreenEdgePanGestureRecognizer) {
        
        //Calculate some data
        let minPercent = 0.0, maxPercent = 0.999, minPercentMoved = 0.25
        let backward = sender == leftScreenEdgeRecognizer
        let containingView = sender.view!
        let delta = sender.translationInView(containingView)
        var percent = Double(fabs(delta.x/containingView.bounds.size.width))
        
        //Make sure percent is a value between 0.0 and 0.999
        percent = min(maxPercent, max(minPercent, percent))
        
        switch sender.state {
        case .Began:
            //Freeze the layer and begin the animation
            containingView.layer.speed = 0
            
            if (backward) {
                navigateToPreviousViewController()
            }
            else if let nextVc = dataSource? .cubeContainerViewController(self,
                viewControllerAfterViewController: currentViewController()) {
                navigateToViewController(nextVc)
            }
            
        case .Changed:
            //Animation might not be in progress, e.g. if going backward from the initial view controller
            if animationIsInProgress() {
                //Update animation progress
                containingView.layer.timeOffset = percent
            }
            
        case .Ended, .Cancelled, .Failed:
            if percent < minPercentMoved {
                removeRotationAnimation()
            }
            
            //Restore layer speed and begin the animation now
            containingView.layer.beginTime = CACurrentMediaTime()
            containingView.layer.speed = 1
        default:
            return
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: Rotation Animation Related
    
    private func performScaleAndRotateAnimation(fromSide: CubeSide, toSide: CubeSide) {
        if animationIsInProgress() {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.containerView.layer.timeOffset = 0 //Restore timeOffset for interactive animations
        }
        
        let animation = rotationAnimation(fromSide, toSide: toSide)
        CATransaction.setAnimationDuration(animation.duration)
        containerView.layer.addAnimation(animation, forKey: animationIdentifier)
        CATransaction.commit()
    }
    
    private func animationIsInProgress() -> Bool {
        return containerView.layer.animationForKey(animationIdentifier) != nil
    }
    
    private func rotationAnimation(fromSide: CubeSide, toSide: CubeSide) -> CAAnimation {

        let startTransform = fromSide.perspectiveTransform()
        let startDownScaled = CATransform3DScale(startTransform, 0.55, 0.55, 0.55)

        let finalTransform = toSide.perspectiveTransform()
        let finalDownScaled = CATransform3DScale(finalTransform, 0.55, 0.55, 0.55)
        
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "sublayerTransform")
        keyFrameAnimation.duration = 1.0
        keyFrameAnimation.removedOnCompletion = false
        keyFrameAnimation.fillMode = kCAFillModeForwards
        
        keyFrameAnimation.values = [
            startTransform,     //Begin from start transform
            startDownScaled,    //Animate to scaled down version of start transform
            finalDownScaled,    //Animate to scaled down version of final transform
            finalTransform]     //Animate to original version of final transform
            .map { NSValue(CATransform3D:$0) }
        

        keyFrameAnimation.timingFunctions = [
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        ]
        
        keyFrameAnimation.keyTimes = [0, 0.15, 0.65, 1.0] //These values look good
        keyFrameAnimation.delegate = self
        
        //Add meta-data to the animation object, so that appropriate actions may performed when the animation ends
        keyFrameAnimation.setValue(toSide.rawValue, forKey: animationKeyFinalSide)
        
        return keyFrameAnimation
    }
    
    private func removeRotationAnimation() {
        containerView.layer.removeAnimationForKey(animationIdentifier)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: CAAnimationDelegate
    
    /**
    Called when the rotation animation has stopped.
    
    Removes the animation from the layer since it has removeOnCompletion 'false' and fillmode 'forwards'
    
    If the animation was successful:
    - The current side is updated
    - The container view perspective is updated to show the new-current view controller's view
    - Call the rotationCompletionBlock
    
    If the animation failed: Remove the current view controller if the animation direction was forward,
    
    */
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let successful = flag
        let newSide = CubeSide(rawValue:anim.valueForKey(animationKeyFinalSide) as! Int)!
        
        if successful {
            //Update current side
            currentSide = newSide
            
            //Update perspective of container view
            containerView.layer.sublayerTransform = newSide.perspectiveTransform()
            
            if rotationCompletionBlock != nil {
                rotationCompletionBlock!()
            }
        }
        else {
            //Interactive animation failed. Let's check what direction was attempted
            let oldSide = currentSide
            let animationDirectionForward = oldSide.nextSide() == newSide
            
            if (animationDirectionForward) {
                // Remove the newly added 'nextVc' since animation didn't complete
                removeViewControllerFromCube(currentViewController())
            }
        }
        
        //Enable user interaction for the current view controller
        currentViewController().view.userInteractionEnabled = true

        rotationCompletionBlock = nil
        removeRotationAnimation()
    }
}