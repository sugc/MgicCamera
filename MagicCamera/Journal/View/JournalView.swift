//
//  JournalView.swift
//  Purika
//
//  Created by sugc on 06/07/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

import Foundation
import GPUImage

@objc protocol JournalViewDelegate : NSObjectProtocol {
    
    @objc optional func selectImageAtIndex(index:Int, filterIndexPath:IndexPath!)
}

class JournalView: UIView, UITextViewDelegate, TouchTextViewDelegate{
    
    
    var imgWidth : CGFloat!
    var imgHeight : CGFloat!
    /*******************************************************************/
   
    var delegate : JournalViewDelegate!
    var imageArray : Array<UIImage>!
    /******************************************************************/
    var backBtn: UIButton!
    var saveBtn: UIButton!
    var drawView: UIView!
    var backImageView: UIImageView!  //背景图片, 可空
    var foreImageView: UIImageView!  //前景图片, 可空
    var modelView: UICollectionView! //模板视图
    
    /******************************************************************/
    var textViewArray: Array<TouchTextView>! = []
    var decorateImageViewArray: Array<UIImageView>! = []
    var cutViewArray : Array<CutView>! = []
    var selectTextView : TouchTextView?
    var masksView : UIView?
    
    var filterIndexArray : Array<IndexPath>!
    var selectIndex : Int = -1
    var transRatio : CGFloat!
    var lastIndex : Int = -1
    var originIndex : Int = -1
    var lastPoint : CGPoint!
    var isAnimate : Bool = false
    
    /*****************************************************************/
    //数据结构
    
    var model : JournalModel! {
        didSet{
            layout()
            let path = IndexPath.init(row: -1, section: -1)
            filterIndexArray = Array.init(repeating: path, count: model.imageArray.count)
        }
    }
    /*
     _示例图片
     生成图片宽高比
     背景图片， 前景图片  ----可空
     用户选择图片图片位置
     文字位置_内容_字体_是否可编辑
     装饰图片位置_图片名称
     
     */

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func layout() -> Void {
        
        let ratio = model.finalSize.height / model.finalSize.width
        imgWidth = width
        imgHeight = width *  ratio
        if imgHeight > height {
            imgHeight = height
            imgWidth = imgHeight / ratio
        }
        
        let imageFrame = CGRect(x: (width - imgWidth) / 2,
                                y: (height - imgHeight) / 2,
                                width: imgWidth,
                                height: imgHeight)
        drawView = UIView.init(frame: imageFrame)
        transRatio = model.finalSize.width / drawView.width
        backImageView = UIImageView.init(frame: drawView.bounds)
        foreImageView = UIImageView.init(frame: drawView.bounds)
        foreImageView.backgroundColor = UIColor.clear
        
        backImageView.isUserInteractionEnabled = true
        //use guard let please
        
        if model.backImage != nil {
            backImageView.image = UIImage.init(contentsOfFile: model.backImage!)
        }
        
        if model.backColor != nil {
            backImageView.backgroundColor = UIColor.color(hex: model.backColor!, alpha: 1)
        }
        
        if model.foreImage != nil {
            foreImageView.image = UIImage.init(contentsOfFile: model.foreImage!)
        }
        
        self.addSubview(drawView)
        self.drawView.addSubview(backImageView)
        self.drawView.addSubview(foreImageView)
        
        layoutTextView()
        layoutCutView()
        layoutImageView()
        masksView = UIView(frame:CGRect.zero)
        masksView?.backgroundColor = UIColor.clear
        masksView?.layer.borderWidth = 2.0
        masksView?.isUserInteractionEnabled = false
        self.foreImageView.addSubview(masksView!)
        self.addGesture()
    }
    
    func layoutCutView() -> Void {
        
        for i in 0...(model.imageArray.count - 1) {
            let rect = model.imageArray[i]
            let cutView = CutView.init(frame: CGRect(x: rect.origin.x / transRatio,
                                                     y: rect.origin.y / transRatio,
                                                     width: rect.width / transRatio,
                                                     height: rect.height / transRatio))
            self.backImageView.addSubview(cutView)
            cutView.image = imageArray[i]
            cutViewArray.append(cutView)
        }
        
    }
    
    func layoutImageView() -> Void {
        //装饰用
        if model.decorateImageArray?.count == 0 {
            return
        }
        for i in 0...((model.decorateImageArray?.count)! - 1) {
            
            let decStruct = model.decorateImageArray?[i]
            
            let rect = decStruct!.postion!
            let cutView = UIImageView.init(frame: CGRect(x: rect.origin.x / transRatio,
                                                     y: rect.origin.y / transRatio,
                                                     width: rect.width / transRatio,
                                                     height: rect.height / transRatio))
            self.backImageView.addSubview(cutView)
            cutView.image = UIImage.init(contentsOfFile: (decStruct?.decorateImagegName)!) 
            decorateImageViewArray.append(cutView)
        }

    }
    
    func layoutTextView() -> Void {
        //
        guard model.textArray != nil else {
            return
        }
        
        for texStruct in model.textArray! {
            let textView = TouchTextView.init(frame: CGRect(x: texStruct.position.origin.x / transRatio,
                                                         y: texStruct.position.origin.y / transRatio,
                                                         width: texStruct.position.width / transRatio,
                                                         height: texStruct.position.height / transRatio ))
            
            var fontAttrDic = texStruct.fontAttrDic!
            var font = fontAttrDic[NSAttributedString.Key.font] as! UIFont
            font = font.withSize(texStruct.fontSize / transRatio)
            fontAttrDic[NSAttributedString.Key.font] = font
            textView.typingAttributes = fontAttrDic as! [NSAttributedString.Key : Any]
            textView.text = texStruct.content
            textView.textColor = UIColor.color(hex: texStruct.textColor, alpha: 1)
            textView.backgroundColor = UIColor.clear
            textView.isScrollEnabled = false
            textView.delegate = self
            textView.touchDelegate = self
            textView.textAlignment = NSTextAlignment.center
//            let finalSize = textView.sizeThatFits(CGSize(width: textView.width, height: textView.height + 5))
//            textView.frame = CGRect(x: textView.frame.minX,
//                                    y: textView.frame.minY,
//                                    width: textView.width,
//                                    height: finalSize.height)
            self.drawView.addSubview(textView)
            textViewArray.append(textView)
        }
    }
    
    func getSelectViewFrame() -> CGRect {
        
        let returRect = CGRect(x: self.frame.origin.x + drawView.frame.origin.x + (selectTextView?.frame.origin.x)!,
            y: self.frame.origin.y + drawView.frame.origin.y + (selectTextView?.frame.origin.y)!,
            width: (selectTextView?.frame.width)!,
            height: (selectTextView?.frame.height)!)
        
        return returRect
    }


    //************************textViewDelegate***********************//
    
    func textViewWillBeginEdit(textView: TouchTextView) {
        selectTextView = textView
    }
    
    //添加手势
    func addGesture()  {
        let pressGesture = UILongPressGestureRecognizer(target: self, action:#selector(longPress(gesture:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        self.backImageView.addGestureRecognizer(pressGesture)
        self.backImageView.addGestureRecognizer(tapGesture)
        tapGesture.require(toFail: pressGesture)
    }
    
    @objc func tap(gesture : UITapGestureRecognizer) {
        let point = gesture.location(in: self.backImageView)
        for i in 0...(cutViewArray.count - 1) {  
            let cutView = cutViewArray[i]
            if cutView.isPositionInView(position: point) {
                var path : IndexPath! = IndexPath.init(row: -1, section: -1)
                if i == selectIndex {
                    selectIndex = -1
                    masksView?.layer.borderColor = UIColor.clear.cgColor
                }else {
                    selectIndex = i
                    masksView?.layer.borderColor = UIColor.yellow.cgColor
                    masksView?.frame = cutView.frame
                    path = filterIndexArray[i]
                }
                
                delegate.selectImageAtIndex!(index: 0, filterIndexPath: path)
                break
            }
        }
    }
    //交换图片
    @objc func longPress(gesture : UILongPressGestureRecognizer)  {
        
        let point = gesture.location(in: self.backImageView)
        var isViewChanged = false
        for i in 0...(cutViewArray.count - 1) {
            
            let cutView = cutViewArray[i]
            if cutView.isPositionInView(position: point) {
                if lastIndex != i {
                    isViewChanged = true
                }
                lastIndex = i
                break
            }
        }
        
        let selectView = cutViewArray[lastIndex]
        if gesture.state == UIGestureRecognizer.State.began {
            isAnimate = false
            originIndex = lastIndex
            masksView?.frame = selectView.frame
            masksView?.layer.borderColor = UIColor.red.cgColor
            lastPoint = point
        }
        
        
        if gesture.state == UIGestureRecognizer.State.changed {
            
            if isAnimate {
                lastPoint = point
                return
            }
            
            masksView?.frame = CGRect(x: (masksView?.left)! + (point.x - lastPoint.x),
                                     y: (masksView?.top)! + (point.y - lastPoint.y),
                                     width: (masksView?.width)!,
                                     height: (masksView?.height)!)
            lastPoint = point
            
            if isViewChanged {
                isAnimate = true
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.masksView?.frame = selectView.frame
                }, completion: {finished in
                    self.isAnimate = false
                })
            }
        }
        
        if gesture.state == UIGestureRecognizer.State.ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.masksView?.frame = selectView.frame
            }, completion: {finished in
                var image = self.imageArray[self.originIndex]
                self.imageArray[self.originIndex] = self.imageArray[self.lastIndex]
                self.imageArray[self.lastIndex] = image
                
                image = self.cutViewArray[self.lastIndex].image
                self.cutViewArray[self.lastIndex].image = self.cutViewArray[self.originIndex].image
                self.cutViewArray[self.originIndex].image = image
                self.masksView?.layer.borderColor = UIColor.clear.cgColor
                
                if self.selectIndex != -1 {
                    self.selectIndex = self.lastIndex
                    self.masksView?.layer.borderColor = UIColor.yellow.cgColor
                }
            })
        }
    }
    
    func setFilter(filters:Array<GPUImageFilter>) {
        //
        if selectIndex == -1 {
            return
        }
        
        let oriImage = imageArray[selectIndex]
        if filters.count == 0 {
            cutViewArray[selectIndex].image = oriImage;
            return
        }
        
        let filter = filters.first!
        filter.removeAllTargets()
       
        let inputImage = GPUImagePicture.init(image: oriImage)
        inputImage?.addTarget(filter)
        filter.useNextFrameForImageCapture()
        inputImage?.processImage()
        let filteredImage = filter.imageFromCurrentFramebuffer()
        
        self.cutViewArray[self.selectIndex].image = filteredImage
    }
    
    func applyFilterWithLookUpImage(lookupImage:UIImage?) {
        if selectIndex == -1 {
            return
        }
        var saveImage = imageArray[selectIndex]
        if lookupImage != nil {
            let oriImage = imageArray[selectIndex]
            let lookupFilter = LookUpFilter(lookupImage: lookupImage!)
            lookupFilter.sourceImage = oriImage
            lookupFilter.prepare()
            lookupFilter.render()
            saveImage = lookupFilter.getSaveImage()
            
        }
        self.cutViewArray[self.selectIndex].image = saveImage
    }
    
    func setIndexPath(path:IndexPath!)  {
        if selectIndex == -1 {
            return
        }
        filterIndexArray[selectIndex] = path
    }
    
}
