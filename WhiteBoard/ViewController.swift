//
//  ViewController.swift
//  WhiteBoard
//
//  Created by Asad Khan on 12/11/18.
//  Copyright © 2018 Asad Khan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var canvas: DrawingView!
    @IBOutlet weak var canvasScrollView: UIScrollView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnScroll: UIButton!
    @IBOutlet weak var btnStroke: UIButton!
    @IBOutlet weak var btnColor: UIButton!
    
    var boardName = ""{
        didSet{
            self.canvas.boardID = boardName.lowercased()
        }
    }
    
    var userId = ""{
        didSet{
            self.canvas.userID = userId.lowercased()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        canvasScrollView.delegate = self
        boardName = "WhiteBoardTry"
        userId = "Wid-1"
        
        if userId != "", boardName != ""{
            self.canvas.setBoardObservers()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        clearWhiteBoard()
        print("Somebody is drawing...")
        self.canvas.setBoardObservers()
        self.canvas.setNeedsDisplay()
    }
    
    func clearWhiteBoard()
    {
        if boardName != ""{
            FBWhiteBoardManager.shared.resetValues(boardID: boardName)
            
            self.canvas.resetPath()
            self.canvas.currentSNSPath = nil
            self.canvas.allPaths.removeAll()
            self.canvas.allKeys.removeAll()
            self.canvas.setNeedsDisplay()
        }
    }
    
    @IBAction func undoPath(_ sender: Any) {
        
        let lastPathKey = self.canvas.allKeys.last
        if let key = lastPathKey, boardName != ""{
            FBWhiteBoardManager.shared.removePath(boardID: boardName, pathID:key)
            self.canvas.allPaths.removeLast()
            self.canvas.allKeys.removeLast()
            self.canvas.setNeedsDisplay()
        }
    }
    
    @IBAction func clearCanvas(_ sender: Any) {
        
        if boardName != ""{
            FBWhiteBoardManager.shared.resetValues(boardID: boardName)
            self.canvas.resetPath()
            self.canvas.currentSNSPath = nil
            self.canvas.allPaths.removeAll()
            self.canvas.allKeys.removeAll()
            self.canvas.setNeedsDisplay()
        }
    }
    
    @IBAction func actionScroll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.canvas.isUserInteractionEnabled = false
            self.canvasScrollView.isScrollEnabled = true
        }
        else{
            self.canvas.isUserInteractionEnabled = true
            self.canvasScrollView.isScrollEnabled = false
        }
    }
    
    @IBAction func actionColor(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.canvas.strokeColor = UIColor.orange
        }
        else{
            self.canvas.strokeColor = UIColor.black
        }
    }
    
    @IBAction func actionStroke(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            self.canvas.strokeWidth = 5
        }
        else{
            self.canvas.strokeWidth = 2
        }
    }
}

extension ViewController: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return canvas
    }
}
