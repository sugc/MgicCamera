//
//  JournalTemplateViewController.swift
//  Purika
//
//  Created by zj－db0548 on 2017/7/30.
//  Copyright © 2017年 魔方. All rights reserved.
//

import Foundation


class JournalTemplateViewController : UIViewController,
    WaterFlowLayoutDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    PickerProtocol
{
    
    var collectionView : UICollectionView!
    var waterLayout : WaterFlowLayout!
    var dataArray : Array<Dictionary<String,String>> = []
    var model : JournalModel!
    let width = (UIScreen.main.bounds.size.width - 10.0) / 2
    private var modeArray : Array<JigsawModel>!
    private var selectNum : Int! = 0
    
    override func viewDidLoad() {
        
        data()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func data()  {
        
        //修改成从数据库获取
        
        //获取所有文件的路径
        var path = Bundle.main.path(forResource: "journalConfig", ofType: "plist");
        dataArray = NSArray.init(contentsOfFile: path!) as! Array<Dictionary<String, String>>
        
//        let fileManager = FileManager.default
//
//        do {
//            
//            let tempArray = try fileManager.contentsOfDirectory(atPath: path!)
//
//            for fileName in tempArray {
//                if fileName != ".DS_Store" {
//                    let finalName = path?.appending("/").appending(fileName).appending("/template.jpg")
//                    dataArray.append(finalName!)
//                }
//            }
//        } catch  {
//
//        }
    }
    
    func layout() {
        self.view.backgroundColor = UIColor.white
        let leftButton = UIButton(frame: CGRect(x: 0,
                                                y: 0,
                                                width: 40,
                                                height: 40 ))
        leftButton.setImage(UIImage(named:"icon_back_normal"), for: UIControlState.normal)
        leftButton.setImage(UIImage(named:"icon_back_highlight"), for: UIControlState.highlighted)
        leftButton.addTarget(self,
                             action: #selector(goBack) ,
                             for: UIControlEvents.touchUpInside)
        let lineView = UIView.init(frame: CGRect.init(x: 0,
                                                      y: 39,
                                                      width: self.view.width,
                                                      height: 1))
        lineView.backgroundColor = UIColor.gray
        self.view.addSubview(lineView)

        self.view.addSubview(leftButton)
        
        waterLayout = WaterFlowLayout()
        waterLayout.numOfRow = 2
        waterLayout.delegate = self
        
        let coFrame = CGRect(x: 0,
                             y: 40,
                             width: UIScreen.main.bounds.width,
                             height: UIScreen.main.bounds.height)
        collectionView = UICollectionView(frame: coFrame,
                                          collectionViewLayout: waterLayout)
        collectionView.bounces = true
        collectionView.register(UICollectionViewCell.classForCoder(),
                                forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor.color(hex: 0xeeeeee, alpha: 0.8)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
    }
    
    func size(in indexPath:IndexPath) -> CGSize {
        
//        let path = dataArray[indexPath.row]
//        let image = UIImage(contentsOfFile: path)
        
        let dic  = dataArray[indexPath.row]
        let image = UIImage(named:dic["TempImageName"]!)
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
        let picker = PhotoPickerViewController()
        picker.type = pickerType.selected
        picker.delegate = self;
        //获取model
        let dic  = dataArray[indexPath.row]
        let modeID = dic["ModeID"]!
        let path = Bundle.main.path(forResource: modeID, ofType: nil)
        model = JournalModel.init(configPath: path!)
        picker.maxSelect = model.imageArray.count
        self.navigationController?.pushViewController(picker, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = UIImageView(frame: (cell.contentView.bounds))
    
//        let imageName = dataArray[indexPath.row]
//        let image = UIImage(contentsOfFile: imageName)
        let dic  = dataArray[indexPath.row]
        let image = UIImage(named:dic["TempImageName"]!)
        
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
        
        let journalVC = JournalViewController()
        journalVC.model = model
        journalVC.imageArray = images
        self.navigationController?.pushViewController(journalVC, animated: false)
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
        
        print("release journaltemplate")
    }
}










