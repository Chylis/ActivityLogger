//
//  BaseOverviewPresentationController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 17/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit

class BaseOverviewPresentationController: BaseReactiveViewController {
    
    //MARK: Properties
    
    var viewModel: ActivityOverviewViewModel = ActivityOverviewViewModel()
    
    //MARK: Life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //Reload data after current transaction to adapt to the new trait collection
        //Dispatch as new task on main thread to let current stack-frame complete
        dispatch_async(dispatch_get_main_queue()) {
            self.reloadData()
        }
    }
    
    //MARK: Abstract
    func reloadData() { }
    
    
    //MARK: Overridden
    
    /**
    Binds view models to UI, reflecting model changes in the the UI
    */
    override func bindViewModelToUI() {
        
        viewModel
            .viewState
            .producer
            .startWithNext { _ in
                self.reloadData()
        }
        
        viewModel
            .selectedDate
            .producer
            .startWithNext { _ in
                self.reloadData()
        }
    }
}