//
//  BaseReactiveViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 17/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit

class BaseReactiveViewController: UIViewController {
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        bindViewModelToUI()
        bindUIToViewModel()
    }

    //MARK: Abstract
    
    func setupViewModel() {}
    func setupUI() {}
    
    func bindViewModelToUI() {}
    func bindUIToViewModel() {}
}
