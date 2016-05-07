//
//  SelectActivityTypeViewController.swift
//  ActivityLogger
//
//  Created by Magnus Eriksson on 30/12/15.
//  Copyright © 2015 Magnus Eriksson. All rights reserved.
//

import UIKit

class SelectActivityTypeViewController: UIViewController, ActivityLoggerDelegate {
    
    //MARK: Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    
    var activityModel = ActivityModel()
        
    private let viewModel = SelectActivityTypeViewModel()
    
    //MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title()
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        //Reload collection view to adapt to new trait collection
        collectionView.reloadData()
    }
}


//MARK: UICollectionViewDataSource
extension SelectActivityTypeViewController: UICollectionViewDataSource {
    
    private static let collectionViewCellId = "SelectActivityTypeCollectionViewCell"
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ActivityType.Count.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            SelectActivityTypeViewController.collectionViewCellId, forIndexPath: indexPath) as! SelectActivityTypeCollectionViewCell
        configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: SelectActivityTypeCollectionViewCell, indexPath: NSIndexPath) {
        let imageName = viewModel.imageForActivityAtIndex(indexPath.item)
        cell.imageView.image = UIImage(named:imageName)
        cell.titleLabel.text = viewModel.titleForActivityAtIndex(indexPath.item)
        
        let cellIsSelected = activityModel.type == ActivityType(rawValue: indexPath.item)
        cell.contentView.layer.borderWidth = cellIsSelected ? 5 : 0
    }
}


//MARK: UICollectionViewDelegate
extension SelectActivityTypeViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let activityType = ActivityType(rawValue: indexPath.row) {
            activityModel.type = activityType
            collectionView.reloadData()
            onActivityLoggerCompleted(activityModel)
        }
    }
}


//MARK: UICollectionViewDelegateFlowLayout
extension SelectActivityTypeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return itemSize()
    }
    
    /**
     Returns the collection view item size, depending on the current orientation
     */
    private func itemSize() -> CGSize {
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let width = (isInLandscapeOrientation() ? itemWidthInLandscape() : itemWidthInPortrait() )
            - flowLayout.sectionInset.left
            - flowLayout.sectionInset.right
            - flowLayout.minimumInteritemSpacing
        
        let height: CGFloat = 130
        return CGSizeMake(width, height)
    }
    
    private func itemWidthInPortrait() -> CGFloat {
        return collectionView.bounds.size.width
    }
    
    private func itemWidthInLandscape() -> CGFloat {
        let itemPadding: CGFloat = 0.5
        return collectionView.bounds.size.width / 2.0 + itemPadding
        
    }
}
