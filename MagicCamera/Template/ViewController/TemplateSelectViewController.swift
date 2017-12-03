//
//  TemplateSelectView.swift
//  Purika
//
//  Created by zj－db0548 on 2016/12/22.
//  Copyright © 2016年 魔方. All rights reserved.
//

import Foundation

class TemplateSelectViewController: UIViewController,
                                    WaterFlowLayoutDelegate,
                                    UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    PickerProtocol
{
    
    var collectionView : UICollectionView!
    var waterLayout : WaterFlowLayout!
    var dataArray : Array<Any> = []
    let width = (UIScreen.main.bounds.size.width - 10.0) / 3
    private var modeArray : Array<JigsawModel>!
    private var selectNum : Int! = 0
    
    override func viewDidLoad() {
        
        data()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func data()  {
        
        //解析json,获取所有的模板
        modeArray = self.getTemplate(fileName: "Template")
        
        let filePath = Bundle.main.path(forResource: "TemplateOutLine", ofType: "plist");
        let tempArray = NSArray.init(contentsOfFile: filePath!)
        
        
        for i in 0...((tempArray?.count)! - 1) {
            let attr = tempArray?.object(at: i) as! Dictionary<String, Any>
            var dic = Dictionary<String, Any>()
            dic["tempImage"] = attr["tempImage"]
            dic["index"] = attr["index"]
            dataArray.append(dic)
        }

    }
    
    func layout() {
        self.view.backgroundColor = UIColor.black
        let leftButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 40,
                                                height: 40 ))
        leftButton.setImage(UIImage(named:"icon_share_goBack"), for: UIControlState.normal)
        leftButton.addTarget(self,
                             action: #selector(goBack) ,
                             for: UIControlEvents.touchUpInside)
        let leftItem = UIBarButtonItem(customView: leftButton)
        self.navigationItem.leftBarButtonItem = leftItem
        
        waterLayout = WaterFlowLayout()
        waterLayout.delegate = self
        
       let coFrame = CGRect(x: 0,
                            y: 0,
                            width: UIScreen.main.bounds.width,
                            height: UIScreen.main.bounds.height)
        collectionView = UICollectionView(frame: coFrame,
                                          collectionViewLayout: waterLayout)
        collectionView.register(UICollectionViewCell.classForCoder(),
                                forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.color(hex: 0xeeeeee, alpha: 0.8)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
    }
    
    func size(in indexPath:IndexPath) -> CGSize {
        
        let dic = dataArray[indexPath.row] as! Dictionary<String, Any>
        let imageName = dic["tempImage"] as! String
        let imagePath = Bundle.main.path(forResource: imageName, ofType: nil)
        let image = UIImage(contentsOfFile: imagePath!)
        let ratio = (image?.size.height)! / (image?.size.width)!
        let height = width * ratio
        
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //选择模板后进入照片选择页
        selectNum = indexPath.row
        let picker = PhotoPickerViewController()
        picker.type = pickerType.selected
        picker.delegate = self;
        let model = modeArray[selectNum]
        picker.maxSelect = model.rectArray.count
        self.navigationController?.pushViewController(picker, animated: true)
        //获取对应的model
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(frame: (cell.contentView.bounds))
        let dic = dataArray[indexPath.row] as! Dictionary<String, Any>
        let imageName = dic["tempImage"] as! String
        let imagePath = Bundle.main.path(forResource: imageName, ofType: nil)
        let image = UIImage(contentsOfFile: imagePath!)

        imageView.image = image
        cell.contentView.addSubview(imageView)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    func pickImage(images: Array<UIImage>) {
//        let VC = JigsawViewController()
//        VC.model = modeArray[selectNum]
//        VC.imageArray = images
//        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //获取所有的model
    func getTemplate(fileName:String)->Array<JigsawModel> {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "plist");
        let tempArray = NSArray.init(contentsOfFile: filePath!)
        var array : Array<JigsawModel> = []
        
        for i in 0...(tempArray?.count )! - 1 {
            
            let mode = JigsawModel()
            
            let dic = tempArray?[i] as! Dictionary<String, Any>
            
            let textStrArray = dic["textArray"] as! Array<Dictionary<String, Any>>
            var textArray : Array<Dictionary<String, Any>> = []
            for dics in textStrArray {
                var textDic : Dictionary<String, Any> = [:]
                textDic["text"] = dics["text"]
                textDic["frame"] = CGRect.getRect(array: dics["frame"] as! Array<NSNumber>)
                
                let fontAttrDic = dics["fontAttr"] as! Dictionary<String,Any>
                let KernAttr = fontAttrDic["NSKernAttributeName"] as! NSNumber
                let fontName = fontAttrDic["fontName"] as! String
                let alpha = fontAttrDic["alpha"] as! NSNumber
                let colorName = fontAttrDic["NSForegroundColorAttributeName"] as! NSNumber
                var fontSize = (fontAttrDic["fontSize"] as! NSNumber).doubleValue
                fontSize = fontSize * Double(UIScreen.main.bounds.width.native) / 375
                let lineSpacing = fontAttrDic["lineSpacing"] as! NSNumber
                
                let font = UIFont(name: fontName, size: CGFloat(fontSize))
                let color = UIColor.color(hex: colorName.intValue, alpha: CGFloat(alpha))
                let paraStyle = NSMutableParagraphStyle()
                paraStyle.lineSpacing = CGFloat(lineSpacing)
                
                
                let textAttr: Dictionary<String, Any> = [
                    NSFontAttributeName :font!,
                    NSForegroundColorAttributeName : color,
                    NSKernAttributeName : 5,
                    NSParagraphStyleAttributeName : paraStyle
                ]

                
                textDic["fontAttr"] = textAttr
                textArray.append(textDic)
            }
            
            let rectStrArray = dic["rectArray"] as! Array<Any>
            var rectArray : Array<CGRect> = []
            
            for i in 0...rectStrArray.count - 1 {
                
                var attrArray = rectStrArray[i] as! Array<NSNumber>
                
                for i in 0...3 {
                    attrArray[i] = NSNumber(value: attrArray[i].doubleValue)
                }
                
                let rect = CGRect.getRect(array: attrArray)
                rectArray.append(rect)
            }
            
            let ratio = dic["ratio"] as! Float
            mode.ratio = ratio
            mode.textArray = textArray
            mode.rectArray = rectArray
            array.append(mode)
        }
        return array
    }
    
    func goBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }

    deinit {
        
        print("release template")
    }
}










