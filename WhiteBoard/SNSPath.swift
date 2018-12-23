//
//  SNSPath.swift
//  WhiteBoard
//
//  Created by Asad Khan on 12/17/18.
//  Copyright © 2018 Asad Khan. All rights reserved.
//

import Foundation


struct SNSPoint:Codable {
    
    var x: CGFloat
    var y: CGFloat
}


struct SNSPath:Codable {
    
    var points:     [SNSPoint]
    
    var colorInHex: String
    
    init(point:CGPoint, color:String) {
        
        self.colorInHex = color
        points = [SNSPoint]()
        let newPoint = SNSPoint.init(x: point.x, y: point.y)
        
        points.append(newPoint)
        
    }
    
    mutating func add(point: CGPoint){
        let newPoint = SNSPoint.init(x: point.x, y: point.y)
        points.append(newPoint)
    }
    
    func encode()->Data?{
        
        let encoder = JSONEncoder.init()
        do {
            return try encoder.encode(self)
        } catch  {
            print(error)
        }
        
        return nil
    }
}
