//
//  LineOverviewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 17/02/16.
//  Copyright © 2016 Magnus Eriksson. All rights reserved.
//

import UIKit
import JBChartView
import Swiftilities


enum LineViewDataSourceIndexMapper: Int {
    case Healthy = 0
    case Unhealthy
    case Count
}

class LineOverviewController: BaseOverviewPresentationController {
    
    //MARK: Outlets
    
    @IBOutlet weak var contentView: JBLineChartView!
    
    @IBOutlet var footerView: UIStackView!
    @IBOutlet weak var leftFooterLabel: UILabel!
    @IBOutlet weak var rightFooterLabel: UILabel!

    
    //MARK: Private
    
    private var healthyActivities: [[ActivityModel]] = [[]]
    private var unhealthyActivities: [[ActivityModel]] = [[]]
    
    //MARK: Overridden
    
    override func setupUI() {
        contentView.dataSource = self
        contentView.delegate = self
        contentView.minimumValue = 0
        contentView.maximumValue = viewModel.maxNumberOfActivitiesForCurrentViewState()
        contentView.footerView = footerView
        contentView.showsVerticalSelection = false
        contentView.showsLineSelection = false
    }
    
    override func reloadData() {
        (healthyActivities, unhealthyActivities) = viewModel.lineChartViewDataSourceForCurrentViewState()

        leftFooterLabel.text = viewModel.leftFooterLabelText()
        rightFooterLabel.text = viewModel.rightFooterLabelText()
        contentView.reloadData()
        contentView.animateTransition()
    }
}

//MARK: JBLineChartViewDataSource
extension LineOverviewController: JBLineChartViewDataSource {
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(LineViewDataSourceIndexMapper.Count.rawValue)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        let activityMatrix = datasourceAtIndex(Int(lineIndex))
        return UInt(activityMatrix.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func datasourceAtIndex(index: Int) -> [[ActivityModel]] {
        if index == LineViewDataSourceIndexMapper.Healthy.rawValue {
            return healthyActivities
        }
        
        return unhealthyActivities
    }
}

//MARK: JBLineChartViewDelegate
extension LineOverviewController: JBLineChartViewDelegate {
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return lineIndex == UInt(LineViewDataSourceIndexMapper.Healthy.rawValue) ? UIColor.greenColor() : UIColor.redColor()
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt,
        atLineIndex lineIndex: UInt) -> CGFloat {
            let activityMatrix = datasourceAtIndex(Int(lineIndex))
            let activities = activityMatrix[Int(horizontalIndex)]
            let numberOfActivitiesPerformed = activities.count
            return CGFloat(numberOfActivitiesPerformed)
    }
}