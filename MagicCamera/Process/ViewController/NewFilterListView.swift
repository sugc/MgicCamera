//
//  NewFilterListView.swift
//  MagicCamera
//
//  Created by sugc on 2018/3/1.
//  Copyright © 2018年 sugc. All rights reserved.
//

import Foundation
import UIKit
import GPUImage

protocol newFilterListViewProtocol:NSObjectProtocol {
    func applyFilter(filters:Array<GPUImageFilter>)
    func applyLookUpImage(lookUpImage:UIImage?)
    func didbeganApplyFilter()
    func shoulApplyHeaderAction() -> Bool
}

class NewFilterListView : UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FilterListViewHeaderDelegate {
    
    var listCollectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    weak var filterDelegate : newFilterListViewProtocol?
    var filterManager : FilterManager!
    var lastSelectIndex : IndexPath! = IndexPath.init(row: -1, section: -1)
    var dataArray : Array<Any>!
    var selectedSection : Int!
    var currentFilterInfo : FilterInfo?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        comonInit()
    }
    
    func comonInit()  {
        layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: 60, height: 70)
        layout.headerReferenceSize = CGSize.init(width: 60, height: 70)
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
        
        let frame = CGRect.init(x: 0, y: (self.height - 70) / 2, width: self.width, height: 70)
        listCollectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        
        listCollectionView.backgroundColor = UIColor.clear
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        registerNib()
        selectedSection = -1
        let configPath = Bundle.main.path(forResource: "filterResourse", ofType: nil)
        filterManager = FilterManager.init(cofigPath: configPath!)
        self.isExclusiveTouch = true
        self.addSubview(listCollectionView)
    }
    
    
    
    func registerNib() {
        let cellNib = UINib(nibName: "FilterListViewCell", bundle: nil)
        listCollectionView.register(cellNib, forCellWithReuseIdentifier: "FilterListViewCell")
        let hederNib = UINib(nibName: "FilterListViewHeader", bundle: nil)
        listCollectionView.register(hederNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "FilterListViewHeader")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        let str = String.init(format: "%ld", indexPath.row)
        cell.titleLabel.text = str as String
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind != UICollectionElementKindSectionHeader {
            
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
        
        var filters : Array<GPUImageFilter> = []
        let cell = collectionView.cellForItem(at: indexPath) as? FilterListViewCell
        if (lastSelectIndex == indexPath) {
            cell?.isSelect = false
            lastSelectIndex = IndexPath.init(row: -1, section: -1)
            currentFilterInfo = nil
        }else {
            filterDelegate?.didbeganApplyFilter()
            cell?.isSelect = true
            let filterInfo = filterManager.configArray[indexPath.section].filterInfos[indexPath.row]
            filters = getFilters(filterInfo: filterInfo)
            //            image = UIImage.init(contentsOfFile: filterInfo.filterFileName)!
            lastSelectIndex = indexPath
            currentFilterInfo = filterInfo
        }
        
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        //应用滤镜
        //        filterDelegate?.applyLookUpImage(lookUpImage: image)
        filterDelegate?.applyFilter(filters: filters)
    }
    
    func FilterListViewHeader(_ hederView: FilterListViewHeader?, didSelectItemAt section: NSInteger) {
        
        let isNeedApply = filterDelegate!.shoulApplyHeaderAction()
        if !isNeedApply && section != selectedSection{
            return
        }
        
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
    
    func getFilters(filterInfo:FilterInfo) -> Array<GPUImageFilter> {
        
        let fileName = filterInfo.filterFileName!
        var filter : GPUImageFilter? = nil
        
        if fileName.hasSuffix(".acv") {
            let url = URL.init(fileURLWithPath: fileName)
            filter = GPUImageToneCurveFilter.init(acvurl: url)
        }
        
        if fileName.hasSuffix(".png") {
            let image = UIImage.init(contentsOfFile: filterInfo.filterFileName)!
            filter = LookupFilter16()
            let lookupImage = GPUImagePicture.init(image: image)
            let lookupFilter : LookupFilter16 = filter as! LookupFilter16
            lookupFilter.lookupImage = lookupImage
        }
        
        
        return [filter!]
    }
    
    func getCurrentFilters() -> Array<GPUImageFilter>! {
        
        if (currentFilterInfo != nil) {
            
            let fileName = currentFilterInfo!.filterFileName!
            var filter : GPUImageFilter? = nil
            
            if fileName.hasSuffix(".acv") {
                let url = URL.init(fileURLWithPath: fileName)
                filter = GPUImageToneCurveFilter.init(acvurl: url)
            }
            
            if fileName.hasSuffix(".png") {
                let image = UIImage.init(contentsOfFile: currentFilterInfo!.filterFileName)!
                filter = LookupFilter16()
                let lookupImage = GPUImagePicture.init(image: image)
                let lookupFilter : LookupFilter16 = filter as! LookupFilter16
                lookupFilter.lookupImage = lookupImage
                lookupFilter.intensity = 0.5
            }
            
            return [filter!]
        }
        return []
    }
    
    //
    func selectItemAtIndexPath(path:IndexPath) {
        if path.section == -1 {
            if selectedSection != -1 {
                FilterListViewHeader(nil, didSelectItemAt: selectedSection)
            }
            return
        }
        
        if path.section != selectedSection {
            FilterListViewHeader(nil, didSelectItemAt: path.section)
        }
        
        if path.section != lastSelectIndex.section ||
            path.row != lastSelectIndex.row {
            collectionView(listCollectionView, didSelectItemAt: path)
        }else {
            listCollectionView.scrollToItem(at: path, at: UICollectionViewScrollPosition.centeredHorizontally, animated: true)
        }
    }
    
    deinit {
        print("filterListView deinit")
    }
    
}

