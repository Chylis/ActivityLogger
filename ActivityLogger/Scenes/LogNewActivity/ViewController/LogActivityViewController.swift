//
//  LogActivityViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 30/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit
import GLKit

protocol ActivityLoggerDelegate {
    var activityModel: ActivityModel { get set }
    func onActivityLoggerCompleted(activityModel: ActivityModel)
}

//Extension of all UIViewControllers that conform to ActivityLogerDelegate
extension ActivityLoggerDelegate where Self:UIViewController {
    
    /**
     Default implementation is chain of command, i.e. search until someone takes responsibility
     */
    func onActivityLoggerCompleted(activityModel: ActivityModel) {
        if let parent = parentViewController as? ActivityLoggerDelegate {
            parent.onActivityLoggerCompleted(activityModel)
        }
    }
}


class LogActivityViewController: CubeContainerViewController, ActivityLoggerDelegate {
    
    //MARK: Properties
    
    var activityModel: ActivityModel = ActivityModel()
    
    private let vc1 = UIStoryboard.logActivityStoryboard().instantiateViewControllerWithIdentifier("SelectActivityTypeViewController")
        as! SelectActivityTypeViewController
    
    private let vc2 = UIStoryboard.logActivityStoryboard().instantiateViewControllerWithIdentifier("SelectActivityDateViewController")
        as! SelectActivityDateViewController
    
    
    //MARK: Initialization
    
    init(){
        super.init(viewController: vc1)
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        setupNavigationItems()
    }
    
    //MARK: Private
    
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Rewind,
            target: self,
            action: "leftBarButtonTapped:")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Cancel,
            target: self,
            action: "rightBarButtonTapped:")
    }
    
    
    
    
    //MARK: IBActions
    
    func rightBarButtonTapped(sender: AnyObject) {
        dismissAnimated()
    }
    
    func leftBarButtonTapped(sender: AnyObject) {
        navigateToPreviousViewController()
    }
    
    
    //MARK: ActivityLoggerDelegate
    
    func onActivityLoggerCompleted(activityModel: ActivityModel) {
        self.activityModel = activityModel
        
        if let nextVc = cubeContainerViewController(self, viewControllerAfterViewController: currentViewController()) {
            navigateToActivityLoggerController(nextVc)
        } else {
            completeActivityLogging()
        }
    }
    
    
    /**
     Configures the received logger with self.activityLogger
     Navigates to the received activity logger
     */
    private func navigateToActivityLoggerController(activityController: UIViewController) {
        if var activityLoggerDelegate = activityController as? ActivityLoggerDelegate {
            activityLoggerDelegate.activityModel = activityModel
            navigateToViewController(activityController)
        }
    }
    
    private func completeActivityLogging() {
        let success = activityModel.write()
        if success {
            dismissAnimated()
        } else {
            fatalError("Failed to save activity!")
        }
    }
}


//MARK: CubeContainerDataSource
extension LogActivityViewController: CubeContainerDataSource {
    func cubeContainerViewController(cubeContainerViewController: CubeContainerViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case vc1:       return vc2
        case vc2:       return nil
        default:        return nil
        }
    }
}
