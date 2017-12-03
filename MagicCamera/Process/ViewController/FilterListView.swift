//
//  FilterListView.swift
//  MagicCamera
//
//  Created by sugc on 2017/9/15.
//  Copyright © 2017年 sugc. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

protocol FilterListViewProtocol:NSObjectProtocol {
    func applyFilter(filters:Array<BasicOperation>)
    func didbeganApplyFilter()
}

class FilterListView : UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterListViewHeaderDelegate {

    @IBOutlet var listCollectionView : UICollectionView!
    @IBOutlet var contentView : UIView!
    @IBOutlet var layout : UICollectionViewFlowLayout!
    weak var filterDelegate : FilterListViewProtocol?
    var filterManager : FilterManager!
    var lastSelectIndex : IndexPath? = IndexPath.init(row: -1, section: -1)
    var dataArray : Array<Any>!
    var selectedSection : Int!
    var filter : LookupFilter16 = LookupFilter16.init()
    var currentFilterInfo : FilterInfo?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comonInit()
    }
    
    func comonInit()  {
        let bundle = Bundle.init(for: type(of: self))
        let nib = UINib(nibName: "FilterListView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        contentView.frame = bounds
        self.addSubview(contentView)
        registerNib()
        selectedSection = -1
        let configPath = Bundle.main.path(forResource: "filterResourse", ofType: nil)
        filterManager = FilterManager.init(cofigPath: configPath!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func registerNib() {
        let cellNib = UINib(nibName: "FilterListViewCell", bundle: nil)
        listCollectionView.register(cellNib, forCellWithReuseIdentifier: "FilterListViewCell")
        let hederNib = UINib(nibName: "FilterListViewHeader", bundle: nil)
        listCollectionView.register(hederNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FilterListViewHeader")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = self.bounds
    }
    
    
    func preprareData() {
        dataArray = [["filterName":"B&W","thumbImage":"imageName"],
                    ["filterName":"B&W","thumbImage":"imageName"]]
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterListViewCell", for: indexPath) as! FilterListViewCell
        cell.isSelect = false
        
        if (lastSelectIndex == indexPath) {
            cell.isSelect = true
        }
        
        let filterInfo = filterManager.configArray[indexPath.section].filterInfos[indexPath.row]
        
        cell.imageName = filterInfo.thumderImageName
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: "FilterListViewHeader",
                                                                     for: indexPath) as! FilterListViewHeader
        header.imageName = filterManager.configArray[indexPath.section].themeImagePath
        header.section = indexPath.section
        header.titleLabel.text = filterManager.configArray[indexPath.section].themeName
        header.delegate = self
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filterManager.configArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == selectedSection {
            return filterManager.configArray[section].filterNumber
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: 60, height: 70)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //获取滤镜信息
        let lastCell = collectionView.cellForItem(at: lastSelectIndex!) as? FilterListViewCell
        lastCell?.isSelect = false
        
        var filters : Array<BasicOperation> = []
        let cell = collectionView.cellForItem(at: indexPath) as! FilterListViewCell
        if (lastSelectIndex == indexPath) {
            cell.isSelect = false
            lastSelectIndex = IndexPath.init(row: -1, section: -1)
            currentFilterInfo = nil
        }else {
            filterDelegate?.didbeganApplyFilter()
            cell.isSelect = true
            let filterInfo = filterManager.configArray[indexPath.section].filterInfos[indexPath.row]
            filters = getFilters(filterInfo: filterInfo)
            lastSelectIndex = indexPath
            currentFilterInfo = filterInfo
        }
    
        //应用滤镜
        filterDelegate?.applyFilter(filters: filters)
    }
    
    func FilterListViewHeader(_ hederView: FilterListViewHeader, didSelectItemAt section: NSInteger) {
        //
        
        var isNeedInsert = true
        var array : Array<IndexPath> = []
        var deleteArray : Array<IndexPath> = []
        for count in 0...(filterManager.configArray[section].filterNumber - 1) {
            array.append(IndexPath.init(row: count, section: section))
        }

        if selectedSection != -1 {
            for count in 0...(filterManager.configArray[selectedSection].filterNumber - 1) {
                deleteArray.append(IndexPath.init(row: count, section: selectedSection))
            }
        }
        if selectedSection == section {
            selectedSection = -1
            isNeedInsert = false
        }else {
            selectedSection = section;
        }
        
    
        self.listCollectionView.performBatchUpdates({
            //self.listCollectionView.insertItems(at: array)
            if deleteArray.count > 0 {
                self.listCollectionView.deleteItems(at: deleteArray)
            }
            
            if isNeedInsert {
                self.listCollectionView.insertItems(at: array)
            }
        }){ (isFinish) in
            
        }
        print("")
    }
    
    func getFilters(filterInfo:FilterInfo) -> Array<BasicOperation> {
        let image = UIImage.init(contentsOfFile: filterInfo.lookImageName)!
        filter.lookupImage = PictureInput.init(image: image )
        return [filter]
    }
    
    func getCurrentFilters() -> Array<BasicOperation>! {
        
        if (currentFilterInfo != nil) {
            let image = UIImage.init(contentsOfFile: currentFilterInfo!.lookImageName)!
            let newFilter = LookupFilter16.init()
            newFilter.lookupImage = PictureInput.init(image: image )
            return [newFilter]
        }
        return []
    }
}
