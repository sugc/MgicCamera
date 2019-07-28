//
//  PhotoPickerViewController.swift
//  Purika
//
//  Created by zj－db0548 on 2017/1/6.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


protocol PickerProtocol : NSObjectProtocol{
    func pickImage(images:Array<UIImage>)
}

enum pickerType {
    case normal
    case selected
}

class PhotoPickerViewController: UIViewController, photoPickerProtocol, selectViewDelegate{
    
    private var photoView : UICollectionView!
    private var selectedView : UICollectionView!
    private var bottomView : UIView!
    private var photoLayout : UICollectionViewFlowLayout!
    private var selectLayout : UICollectionViewFlowLayout!
    private var handler : PhotoPickerHandler!
    private var selectHandler : SelectViewHandler! = SelectViewHandler()
    private var cellW : CGFloat!
    private var cellH : CGFloat!
    private var comfirmButton : UIButton!
    private var titleLabel : UILabel!
    private var tipsLabel : UILabel!
    
    weak public var delegate : PickerProtocol?
    public var imageArray : Array<UIImage> = []
    public var type : pickerType!
    public var maxSelect : NSInteger! = 3
    private var currentSelect : NSInteger! = 0
    private var isShowAnimate : Bool = true
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        self.commonInit()
        self.layout(type: self.type)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func commonInit()  {
        handler = PhotoPickerHandler()
        handler.data = PhotoUtil.getAllPhoto()
        handler.delegate = self;
        selectHandler.delegate = self
    }
    
    
    func layout(type:pickerType) {
        
        let leftButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 40,
                                                height: 40 ))
        leftButton.setImage(UIImage(named:"icon_back_normal"), for: UIControl.State.normal)
        leftButton.setImage(UIImage(named:"icon_back_highlight"), for: UIControl.State.highlighted)
        leftButton.addTarget(self,
                             action: #selector(goBack) ,
                             for: UIControl.Event.touchUpInside)
        let lineView = UIView.init(frame: CGRect.init(x: 0,
                                                      y: 39,
                                                      width: self.view.width,
                                                      height: 1))
        lineView.backgroundColor = UIColor.gray
        self.view.addSubview(lineView)
        self.view.addSubview(leftButton)
        
        var pickerRect : CGRect!
        let bottomFrame = CGRect(x: 0,
                                 y: UIScreen.main.bounds.height - 90,
                                 width: UIScreen.main.bounds.width,
                                 height: 90)
        bottomView = UIView(frame: bottomFrame)
        bottomView.backgroundColor = UIColor.black
        
        titleLabel = UILabel(frame: CGRect(x: 5,
                                           y: 0,
                                           width: 140,
                                           height: 20))
        titleLabel.textColor = UIColor.white
        titleLabel.text = String(format: "需选择（%d/%d)张",
                                 selectHandler.data.count,maxSelect)
        pickerRect = CGRect(x: 0,
                            y: 40,
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height - 100)
        
        selectLayout = UICollectionViewFlowLayout()
        let selectRect = CGRect(x: 0,
                                y: 30,
                                width: UIScreen.main.bounds.width,
                                height: 60)
        selectedView = UICollectionView(frame: selectRect,
                                        collectionViewLayout: selectLayout)
        selectLayout.itemSize = CGSize(width: selectedView.height - 10,
                                       height: selectedView.height - 10)
        selectLayout.minimumLineSpacing = 15
        selectLayout.minimumInteritemSpacing = 0.1
        selectLayout.sectionInset = UIEdgeInsets(top: 5,
                                                 left: 5,
                                                 bottom: 0,
                                                 right: 0)
        selectLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        selectedView.backgroundColor = UIColor.black
        selectedView.register(PhotoPickerCell.classForCoder(), forCellWithReuseIdentifier: "selectCell")
        selectedView.delegate = selectHandler
        selectedView.dataSource = selectHandler

        photoLayout = UICollectionViewFlowLayout()
        let cellW = (UIScreen.main.bounds.width - 3 * 5) / 4.0
        photoLayout.itemSize = CGSize(width: cellW, height: cellW)
        photoLayout.minimumLineSpacing = 5.0
        photoLayout.minimumInteritemSpacing = 5.0
        photoView = UICollectionView(frame: pickerRect,
                                     collectionViewLayout: photoLayout)
        photoView.backgroundColor = UIColor.gray
        photoView.delegate = handler
        photoView.dataSource = handler
        photoView.register(PhotoPickerCell.classForCoder(), forCellWithReuseIdentifier: "collectionCell")
        
        
        
        self.view.addSubview(photoView)
        self.view.addSubview(bottomView)
        bottomView.addSubview(selectedView)
        
        comfirmButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 45,
                                               y: 0,
                                               width: 40,
                                               height: 20))
        comfirmButton.setImage(UIImage(named:"icon_select_next"), for: UIControl.State.normal)
        comfirmButton.addTarget(self,
                                action: #selector(comfirm),
                                for: UIControl.Event.touchUpInside)
        comfirmButton.isHidden = true
        
        let tipsText = NSString(string: "已达最大照片数")
        let tipSize = tipsText.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)])
        tipsLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width - tipSize.width - 20) / 2.0,
                                          y: (UIScreen.main.bounds.height - tipSize.height) / 2.0,
                                          width: tipSize.width + 20,
                                          height: tipSize.height + 5))
        tipsLabel.text = tipsText as String
        tipsLabel.font = UIFont.systemFont(ofSize: 18)
        tipsLabel.textColor = UIColor.white
        tipsLabel.textAlignment = NSTextAlignment.center
        tipsLabel.alpha = 0.0
        tipsLabel.backgroundColor = UIColor.gray
        tipsLabel.layer.cornerRadius = tipsLabel.height / 2.0
        tipsLabel.layer.masksToBounds = true
        bottomView.addSubview(comfirmButton)
        bottomView.addSubview(titleLabel)
        self.view.addSubview(tipsLabel)
    }
    
    //添加图片
    func addImage(image: UIImage) {
        
        var newImage = image
        
        if image.size.width > 1024 {
            let ratio = 1024 / image.size.width
            newImage = image.imageWithRatio(ratio: ratio)
        }
        
        if selectHandler.data.count > maxSelect - 1 {
            isShowAnimate = false;
            return
        }
        
        isShowAnimate = true;
        if type == pickerType.selected {
            if selectHandler.data.count == (maxSelect - 1) {
                comfirmButton.isHidden = false
            }
        }
        
        if type == pickerType.normal {
            if selectHandler.data.count >= 1 {
                comfirmButton.isHidden = false
            }
        }
        
        selectHandler.data.append(newImage)
    }
    
    
    func addImageAnotation(starRect: CGRect) {
        
        if !isShowAnimate {
            showTips()
            return
        }

        let imageView = UIImageView(frame: starRect)
        self.view.addSubview(imageView)
        imageView.image = selectHandler.data.last
        
        let path : IndexPath = IndexPath(item: selectedView.numberOfItems(inSection: 0) - 1, section: 0)
        let cell = selectedView.cellForItem(at: path)
        var rect : CGRect!
        let itemSize = selectLayout.itemSize
        if cell == nil {
            rect = CGRect(x: selectLayout.sectionInset.top,
                          y: selectLayout.sectionInset.left,
                          width: itemSize.width,
                          height: itemSize.height)
        }else{
            rect = cell?.frame
            rect = CGRect(x: rect.origin.x + itemSize.width + 15,
                          y: rect.origin.y,
                          width: rect.width,
                          height: rect.height)
        }
        
        let newFrame = CGRect(x: rect.origin.x - selectedView.contentOffset.x,
                              y: bottomView.top + selectedView.top + rect.origin.y,
                              width: rect.width,
                              height: rect.height)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.allowAnimatedContent, animations: {
                        imageView.frame = newFrame
                        self.updateImageNum(num: self.selectHandler.data.count)
        }, completion: {(finish:Bool)in
            self.selectedView.reloadData()
            imageView.removeFromSuperview()
        })
    }
    
    func updateImageNum(num: NSInteger) {
        self.titleLabel.text = String(format: "需选择（%d/%d)张",
                                      num,self.maxSelect)
        if num == maxSelect {
            self.comfirmButton.isHidden = false
        }else {
            self.comfirmButton.isHidden = true
        }
    }

    @objc func comfirm() {
        if delegate != nil {
            delegate?.pickImage(images: selectHandler.data)
        }
    }
    
    func showTips (){
        UIView.animate(withDuration: 0.3, animations: {
            self.tipsLabel.alpha = 1.0
        }, completion: {(isCompeleted)->() in
            self.tipsLabel.alpha = 0
        })
        
    }
    
    @objc func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    deinit {
        print("release photoPicker")
    }
}
