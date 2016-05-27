//
//  OverviewContainerViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 21/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit
import APSlidableTabPageController
import Swiftilities

class OverviewContainerViewController: BaseOverviewPresentationController {
    
    //MARK: Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var prevDateButton: UIButton!
    @IBOutlet weak var nextDateButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
        
    private var slidableTabPageController: HorizontalContainerViewController?
    
    
    //MARK: Overridden from BaseReactiveViewController
        
    override func setupUI() {
        setupContentControllers()
        performAddChildViewController(slidableTabPageController!, parentView: contentContainerView)
    }
    
    /**
     Binds view models to UI, reflecting model changes in the the UI
     */
    override func bindViewModelToUI() {
        viewModel
            .viewState
            .producer
            .startWithNext { viewState in
                self.segmentedControl.selectedSegmentIndex = viewState.rawValue
                self.reloadData()
        }
        
        viewModel
            .selectedDate
            .producer
            .startWithNext { _ in
                self.reloadData()
        }
    }
    
    /**
     Binds UI to view models, i.e. notifying the view models when the user interacts with the app
     */
    override func bindUIToViewModel() {
        
        segmentedControl
            .rac_signalForControlEvents(.ValueChanged)
            .subscribeNext { sender in
                if let segmentedControl = sender as? UISegmentedControl {
                    self.viewModel.viewState.value = (ViewState(rawValue:segmentedControl.selectedSegmentIndex)!)
                }
        }
        
        prevDateButton
            .rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { _ in
                self.viewModel.selectPreviousDate()
        }
        
        nextDateButton
            .rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext { _ in
                self.viewModel.selectNextDate()
        }
    }
    
    //MARK: IBActions
    
    @IBAction func onLogNewActivityButtonTapped(sender: AnyObject) {
        let navCtrl = UINavigationController(rootViewController: LogActivityViewController())
        self.presentViewController(navCtrl, animated: true, completion: nil)
    }
    
    
    //MARK: Overridden BaseOverviewPresentationController
    
    override func reloadData() {
        dateLabel.text = viewModel.formattedDate()
    }

    
    //MARK: Private
    
    /**
    Returns a configured APSlidableTabPageController
    */
    private func setupContentControllers() {
        let lineVc = UIStoryboard.overviewStoryboard().instantiateViewControllerWithIdentifier("LineOverviewController")
            as! LineOverviewController
        lineVc.viewModel = viewModel
        
        let listVc = UIStoryboard.overviewStoryboard().instantiateViewControllerWithIdentifier("TableOverviewController")
            as! TableOverviewController
        listVc.viewModel = viewModel
        
        
        slidableTabPageController = HorizontalContainerCreator.horizontalContainerWithViewControllers([lineVc, listVc])
        slidableTabPageController?.indexBarTextColor = UIColor.blackColor()
        slidableTabPageController?.indexBarHighlightedTextColor = view.tintColor
    }
}
