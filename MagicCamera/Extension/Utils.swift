//
//  Utils.swift
//  Purikura
//
//  Created by zj－db0548 on 16/11/14.
//  Copyright © 2016年 sugc. All rights reserved.
//

import Foundation
import UIKit

struct Line {
    var firstPoint : CGPoint!
    var nextPoint : CGPoint!
}

//判断两条直线是否相交
func isLineIntersect (firstLine: Line, nextLine:Line)->Bool {
    
    return false;
}

//判断两个多边形是否相交
func isPolygonIntersect (firstPolygon:Array<Line>, nextPolygon:Array<Line>)->Bool {
    
    for firstLine in firstPolygon {
        
        for  nextLine in nextPolygon {
            
            if isLineIntersect(firstLine: firstLine, nextLine: nextLine) {
                return false;
            }
        }
        
    }
    
    return false;
}

//判断一个点是否在多边形内
func isInsidePolygon (point:CGPoint, polygon:Array<CGPoint>) ->Bool{
    
    var count:Int = 0
    for i in 0...(polygon.count - 1){
        let firstP = polygon[i]
        let second :CGPoint!
        
        if i == (polygon.count - 1) {
            second = polygon.first
        }else{
            second = polygon[i+1]
        }
        if firstP.y == second.y {
            continue
        }
        
        var x : CGFloat
        if firstP.x == second.x {
            x = firstP.x
        }else{
            let k = (second.y - firstP.y) / (second.x - firstP.x)
            let b = firstP.y - k * firstP.x
            x = (point.y - b) / k
        }
        
        if x >= point.x {
            
            if (x >= firstP.x && x <= second.x)||(x <= firstP.x && x >= second.x) {
                count += 1
            }
        }
    }
    
    return (Int(count % 2) == 1)
}

//判断是否是一个多边形
func isAPolygon (polygon:Array<CGPoint>) {

}

func isPointNearBy(firstPoint:CGPoint, secondPoint:CGPoint)->Bool {
    
    let distance = pow(pow((firstPoint.x - secondPoint.x),2) + pow((firstPoint.y - secondPoint.y), 2), 0.5)
    
    if distance < 20 {
        return true
    }
    
    return false;
}

func distance(firstPoint:CGPoint, secondPoint:CGPoint)->CGFloat {
    
    let distance = pow(pow((firstPoint.x - secondPoint.x),2) + pow((firstPoint.y - secondPoint.y), 2), 0.5)
    
    return distance
}
