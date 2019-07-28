//
//  AutoScrollView.swift
//  Purika
//
//  Created by zj－db0548 on 2017/3/20.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation

class AutoScrollView: UIView, UIScrollViewDelegate {
    
    private var timer : Timer!
    private var scrollView : UIScrollView!
    private var pageControl : UIPageControl!
    private var imageViewArray : Array<UIImageView>! = []
    private var currentImageIndex : Int = 0
    var imageArray : Array<UIImage>! = [] {
        
        didSet {
            self.initImages()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollView = UIScrollView(frame: self.bounds)
        self.scrollView.contentSize = CGSize(width: frame.width * 3,
                                  height: frame.height)
        self.scrollView.isPagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.bounces  = false
        self.scrollView.delegate = self
        scrollView.contentOffset = CGPoint(x: scrollView.width, y: 0)
        self.addSubview(scrollView)
        commonInit()
    }
    
    func commonInit() {
        for i in 0...2 {
            let imageView = UIImageView(frame: CGRect(x: CGFloat(i) * self.width,
                                                      y: 0,
                                                      width: self.width,
                                                      height: self.height))
            
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            self.scrollView.addSubview(imageView)
            imageViewArray.append(imageView)
        }
        
    }
    
    
    func initImages() {
        let imageNum = imageArray.count
        let size = CGSize(width: imageNum * 10, height: 10)
        
        if pageControl != nil {
            pageControl.removeFromSuperview()
        }
        
        pageControl = UIPageControl(frame: CGRect(x: (self.width - size.width) / 2.0,
                                                  y: self.height - size.height,
                                                  width: size.width,
                                                  height: size.height))
        pageControl.numberOfPages = imageNum
        pageControl.pageIndicatorTintColor = UIColor.color(hex: 0x123456, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(pageControl)
        
        for i in 0...2 {
            let imageView = imageViewArray[i]
            imageView.image = imageArray[i]
        }
        startScroll()
    }

    //开始循环播放
    func startScroll()  {
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.0,
                                     target: self,
                                     selector: #selector(scroll),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func scroll() {
        UIView.animate(withDuration: 0.5,
                       animations: {
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.width * 2, y: 0)
        }, completion: {(complete)->() in
            self.changeImageAndTrans()
        })
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.changeImageAndTrans()
    }
    
    //替换图片, 并设置contentOffSet
    func changeImageAndTrans() {
        if scrollView.contentOffset.x == 0 {
            
            currentImageIndex = currentImageIndex - 1
            if currentImageIndex < 0 {
                currentImageIndex = imageArray.count - 1
            }
        }else
            if scrollView.contentOffset.x == scrollView.width * 2 {
            currentImageIndex = (currentImageIndex + 1) % imageArray.count
        }
        
        scrollView.contentOffset = CGPoint(x: scrollView.width, y: 0)
        for i in 0...2 {
            let imageView = imageViewArray[i]
            imageView.image = imageArray[(currentImageIndex + i) % imageArray.count]
        }
        pageControl.currentPage = currentImageIndex
    }
}

















