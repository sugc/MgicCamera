//
//  MultiJigsawViewController.swift
//  Purika
//
//  Created by sugc on 20/06/2017.
//  Copyright © 2017 魔方. All rights reserved.
//

import Foundation
import GPUImage

class JournalViewController : UIViewController, ConfirmTextViewDelegate, FilterListViewProtocol, JournalViewDelegate {
    
    
    //预览宽高比
    var width : CGFloat!
    var height : CGFloat!
    
    //文字
    //图片
    //滤镜
    //
    
    /*******************************************************************/
    var backBtn: UIButton!
    
    var saveBtn: UIButton!
    
    var maskView : UIView!
    
    var journalView : JournalView!
    
    var inputTextView : UITextView!
    
    var ainputTextView : ConfirmTextView!
    
    var filterListView : FilterListView!
    
    
    /***************************************************************/

    var modelPath : String!
    
    var imageArray : Array<UIImage>!
    
    var model : JournalModel!
    
    var gesture : UITapGestureRecognizer!
    
    var isShowTextView : Bool = false
    
    
    let journalViewTopY : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        layout()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyBoardNotification()
    }
    
    func layout() -> Void {
        
        
        ainputTextView = ConfirmTextView.init(frame: CGRect(x: 0,
                                                            y: UIScreen.main.bounds.height,
                                                            width: UIScreen.main.bounds.width,
                                                            height: 40 ))
        ainputTextView.delegate = self
        
        let path = Bundle.main.path(forResource: "M2", ofType: nil)
        
        guard path != nil else {
            return
        }
        
        let model = JournalModel.init(configPath: path!)
        journalView = JournalView.init(frame: CGRect(x: 0,
                                                     y: journalViewTopY,
                                                     width: ScreenWidth,
                                                     height: ScreenHeight - 160 - journalViewTopY))
        journalView.imageArray = imageArray
        journalView.model = model
        journalView.delegate = self
        
        maskView = UIView.init(frame: self.view.bounds)
        maskView.isHidden = true
        gesture = UITapGestureRecognizer.init(target: self, action: #selector(hideKeyBoard))
        maskView.addGestureRecognizer(gesture)
        
        
        let bottomView = UIView.init(frame: CGRect.init(x: 0,
                                                        y: ScreenHeight - 160,
                                                        width: ScreenWidth,
                                                        height: 160))
        bottomView.backgroundColor = UIColor.color(hex: 0xf3f3f3, alpha: 1)
        let confirmBtn = UIButton.init(frame: CGRect.init(x: (ScreenWidth - 60) / 2.0,
                                                          y: bottomView.height - 50 - 10,
                                                          width: 50,
                                                          height: 50))
        confirmBtn.backgroundColor = UIColor.black
        confirmBtn.layer.cornerRadius = 25
        confirmBtn.layer.masksToBounds = true
        confirmBtn.addTarget(self,
                            action: #selector(saveImage),
                            for: UIControlEvents.touchUpInside)
        
        backBtn = UIButton.init(frame: CGRect(x: 15,
                                              y: (bottomView.height - 30) / 2.0,
                                              width: 30,
                                              height: 30))
        backBtn.center = CGPoint.init(x: 15, y: confirmBtn.center.y) 
        backBtn.addTarget(self,
                          action: #selector(goBack),
                          for: UIControlEvents.touchUpInside)
        
        backBtn.setImage(UIImage.init(named: "icon_back_normal"), for: UIControlState.normal)
        
        bottomView.addSubview(confirmBtn)
        bottomView.addSubview(backBtn)
        
        
        filterListView = FilterListView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: 90))
        filterListView.filterDelegate = self
        
        bottomView.addSubview(filterListView)
        self.view.backgroundColor = UIColor.color(hex: 0xb3b3b3, alpha: 1.0)
        self.view.addSubview(journalView)
        self.view.addSubview(maskView)
        self.view.addSubview(ainputTextView)
        self.view.addSubview(bottomView)
    }
    
    
    func hideKeyBoard() {
        self.maskView.isHidden = true
        self.view.endEditing(true)
    }
    func goBack()  {
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveImage()  {
        let ratio = journalView.drawView.height / journalView.drawView.width
        
        var size = CGSize(width: 1280, height: 1280 * ratio)
        if ratio > 1.0 {
            size = CGSize(width: 1280 / ratio, height: 1280)
        }
        
        let resultImage = journalView.drawView.renderImage(finalSize: size)
        resultImage?.save(completion: { (url, error) in
            let storyBoard = UIStoryboard.init(name: "SaveAndShareViewController", bundle: nil)
            let saveVC = storyBoard.instantiateViewController(withIdentifier: "SaveAndShareViewController")
            self.navigationController?.pushViewController(saveVC, animated: true)
        }) 
    }
    

    //delegate
    func viewFrameChanged(finalFrame: CGRect!) {
        //
        let frame = journalView.getSelectViewFrame()
        
        var currentY = journalView.frame.origin.y - (frame.maxY + 20 - ainputTextView.frame.origin.y);
        
        if currentY > journalViewTopY {
            currentY = journalViewTopY
        }
        
        journalView.frame = CGRect(x: journalView.frame.minX,
                                   y: currentY,
                                   width: self.view.bounds.width,
                                   height: self.view.bounds.height)
    }
    
    func textChanged(text: String) {
        journalView.selectTextView?.text = text
        
    }
    
    func addKeyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoradWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        self.maskView.isHidden = false
       
    }
    
    func keyboardDidHide(notification:NSNotification) {
        isShowTextView = false;
    }
    
    func keyboardWillHide(notification:NSNotification) {
        self.maskView.isHidden = true
        
        let userInfo = notification.userInfo!
        let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        UIView.animate(withDuration: 0.1, animations: {
            self.ainputTextView.frame = CGRect(x: 0,
                                               y: UIScreen.main.bounds.height,
                                               width: frame.width,
                                               height: self.ainputTextView.height)
            self.journalView.frame = CGRect(x: self.journalView.left,
                                            y: self.journalViewTopY,
                                            width: self.journalView.height,
                                            height: self.journalView.height)
        }) { (isFinish) in
            
        }
    }
    
    func keyBoradWillChangeFrame(notification:NSNotification) {
        
        if !isShowTextView {
            isShowTextView = true
            DispatchQueue.main.async {
                self.ainputTextView.text = self.journalView.selectTextView?.text
            }
        }
        
        let userInfo = notification.userInfo!
        let frame = userInfo[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let animateTime = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        //        inputTextView.becomeFirstResponder()
        UIView.animate(withDuration: animateTime, animations: {
            self.ainputTextView.changeFrame(newFrame: CGRect(x: 0,
                                                             y: frame.origin.y - self.ainputTextView.height,
                                                             width: frame.width,
                                                             height: self.ainputTextView.height))
        })
    }
    
    func didbeganApplyFilter() {
        
    }
    
    func applyFilter(filters: Array<BasicOperation>) {
//        journalView.setFilter(filters: filters)
    }
    
    func applyLookUpImage(lookUpImage: UIImage?) {
        journalView.applyFilterWithLookUpImage(lookupImage:lookUpImage)
        journalView.setIndexPath(path: filterListView.lastSelectIndex)
    }
    
    func selectImageAtIndex(index: Int, filterIndexPath: IndexPath!) {
        filterListView.selectItemAtIndexPath(path: filterIndexPath!)
    }
    
    deinit {
        maskView.removeGestureRecognizer(gesture)
        print("dinit journal VC")
    }

}
