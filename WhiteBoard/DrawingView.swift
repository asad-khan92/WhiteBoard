//
//  DrawingView.swift
//  WhiteBoard
//
//  Created by Asad Khan on 12/11/18.
//  Copyright © 2018 Asad Khan. All rights reserved.
//

import UIKit
import CoreGraphics
import CodableFirebase
class DrawingView: UIView {
    
    
    @IBInspectable
    public var strokeColor: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var strokeWidth: CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var currentTouch: UITouch?
    var currentPath:Array<CGPoint>?
    var currentSNSPath: SNSPath?
    var allPaths =  [SNSPath]()
    var allKeys  =  [String]()
    
    var boardID:String  = ""
    var userID:String   = ""
    //MARK: Drawing Functions
    
    let firebase = FBWhiteBoardManager.shared
    
    
    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        self.addFromFirebase()
//    }
//
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let context = UIGraphicsGetCurrentContext()
        context!.beginPath()
        context!.setLineWidth(strokeWidth)
        context!.setStrokeColor(strokeColor.cgColor);
        
        
            for path in allPaths{
                
                let pathArray  = path.points
                
                if path.userID != self.userID{
                    let color = UIColor.init(hexString:path.colorInHex )
                    context!.setStrokeColor(color.cgColor)
                }else{
                    context!.setStrokeColor(strokeColor.cgColor)
                }
                if let firstPoint = pathArray.first{
                        
                        context!.move(to:CGPoint.init(x:firstPoint.x , y: firstPoint.y) )
                        
                    if pathArray.count > 1{
                            
                        for i  in 1...pathArray.count - 1{
                            let point = pathArray[i]
                             context?.addQuadCurve(to: CGPoint.init(x:point.x,y:point.y), control: CGPoint.init(x:point.x,y:point.y))
                           // context!.addLine(to: CGPoint.init(x:point.x,y:point.y))
                            }
                        }
                    
                        context!.drawPath(using: .stroke)
                    
                }
            }
        
        
        if let firstPath = currentPath?.first{
            
            context!.move(to: firstPath)
            
            if currentPath!.count > 1{
                
                for i  in 1...currentPath!.count - 1{
                    context!.addLine(to: currentPath![i])
                }
            }
            
            context!.drawPath(using: .stroke)
        }
        
        context!.setStrokeColor(strokeColor.cgColor)
    }
    
    
    
    //MARK: Touch Functions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if currentPath == nil{
            currentTouch  = UITouch()
            currentTouch  = touches.first
            let currentPoint = currentTouch?.location(in: self)
            
            if let point = currentPoint{
                currentPath = [CGPoint]()
                currentPath?.append(point)
                
                currentSNSPath = SNSPath.init(point: point, color:strokeColor.toHexString(),id:self.userID)
                
            }else{
                print("find an empty touch")
            }
        }
        setNeedsDisplay()
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        add(touches:touches)
        setNeedsDisplay()
        //self.sendToFirebase()
        //resetPath(sendToFirebase: true)
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        add(touches:touches)
        self.sendToFirebase()
        resetPath()
        super.touchesEnded(touches, with: event)
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.sendToFirebase()
        resetPath()
        print("Touch Cancelled")
        setNeedsDisplay()
        super.touchesBegan(touches, with: event)
    }
    
    //MARK: Oservers
    //MARK: Observers
    
    func setBoardObservers(){
        
        observeBoardCleared()
        addFromFirebase()
    }
    
    func addFromFirebase(){
        
        FBWhiteBoardManager.shared.observeChanges(for: boardID) { (snapshot) in
            
            if snapshot.exists(){
                do {
                    let model = try FirebaseDecoder().decode(SNSPath.self, from: snapshot.value!)
                    print(model)
                    
                    let firstPoint = model.points.first
                    let currentPoint = CGPoint(x: firstPoint!.x, y: firstPoint!.y)
                    if model.userID == self.userID{
                        self.currentSNSPath = SNSPath.init(point: currentPoint, color: model.colorInHex, id: self.boardID)
                    }else{
                        self.currentSNSPath = SNSPath.init(point: currentPoint, color:"#D85D2C", id: self.boardID)
                    }
                    for point in model.points{
                        let p = CGPoint(x: point.x, y: point.y)
                        self.currentSNSPath?.add(point: p)
                    }
                } catch let error {
                    print(error)
                }
            }
            
            //self.sendToFirebase()
            self.resetPath()
            if let path = self.currentSNSPath, (self.allKeys.filter{$0 == snapshot.key}).count == 0{
                self.allPaths.append(path)
                self.allKeys.append(snapshot.key)
            }
            self.setNeedsDisplay()
        }
        
    }
    
    
    func observeBoardCleared(){
        
        FBWhiteBoardManager.shared.observeBoardCleared(for:boardID) { (snapshot) in
            
            self.resetDrawing(key: snapshot.key)
        }
    }
    
    func resetPath(){
        currentTouch  = nil
        currentPath   = nil
        
    }
    func resetDrawing(key:String){
        
        if allKeys.count > 0{
            allKeys.removeLast()
            allPaths.removeLast()
            //self.resetPath()
            setNeedsDisplay()
        }
    }
    func sendToFirebase(){
        
        if let pathToSend = currentSNSPath{
            
                let returnKey = FBWhiteBoardManager.shared.updateBoard(id: boardID, path: pathToSend)
            allKeys.append(returnKey)
            allPaths.append(pathToSend)
            //allKeys.append(returnKey)
        }
    }
    func add(touches:Set<UITouch>){
        
        if currentPath != nil{
            
            for touch in touches{
                if touch == currentTouch{
                    
                    let currentPoint = currentTouch?.location(in: self)
                    
                    if let point = currentPoint{
                        currentPath?.append(point)
                        currentSNSPath?.add(point: point)
                        
                    }else{
                        print("find an empty touch")
                    }
                }
            }
        }
        
        setNeedsDisplay()
    }
}
