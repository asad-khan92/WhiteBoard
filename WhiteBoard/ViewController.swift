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
    
    @IBOutlet weak var canvas:      DrawingView!
    @IBOutlet weak var nameField:   UITextField!
    @IBOutlet weak var userID:      UITextField!
    @IBOutlet weak var nameBox:     UIView!
    
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
        self.canvas.isUserInteractionEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func undoPath(_ sender: Any) {
        
        let lastPathKey = self.canvas.allKeys.last
        if let key = lastPathKey, boardName != ""{
            FBWhiteBoardManager.shared.removePath(boardID: boardName, pathID:key)
//            self.canvas.allPaths.removeLast()
//            self.canvas.allKeys.removeLast()
//            self.canvas.setNeedsDisplay()
        }
       // FBWhiteBoardManager.shared.resetValues(boardID: id+)
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
}

extension ViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         
            
            boardName =  self.nameField.text!
            userId    = self.userID.text!
            
            // check if user name and board id is entered
            if userId != "", boardName != ""{
                
                self.canvas.isUserInteractionEnabled = true
                self.nameBox.isHidden = true
                self.canvas.setBoardObservers()
                textField.resignFirstResponder()
                
                 return true
            }
       
        
        return false
    }
}
