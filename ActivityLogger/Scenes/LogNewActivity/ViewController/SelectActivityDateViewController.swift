//
//  SelectActivityDateViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 04/01/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit

class SelectActivityDateViewController: UIViewController, ActivityLoggerDelegate {

    //MARK: Outlets
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var proceedButton: UIButton!
    
    //MARK: Properties
    
    var activityModel = ActivityModel()
    private let viewModel = SelectActivityDateViewModel()
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.shouldRasterize = true
        title = viewModel.title()
        proceedButton.setTitle(viewModel.proceedTitle(), forState: .Normal)
        configureDatePicker()
        bindUIToViewModel()
    }
    
    //MARK: Private
    
    private func configureDatePicker() {
        datePicker.maximumDate = viewModel.maximumDate()
    }
    
    private func bindUIToViewModel() {
        proceedButton
            .rac_signalForControlEvents(.TouchUpInside)
            .subscribeNext{ _ in
                self.activityModel.date = self.datePicker.date
                self.onActivityLoggerCompleted(self.activityModel)
        }
    }
}
