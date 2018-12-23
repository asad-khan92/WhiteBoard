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
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nameBox: UIView!
    
    var id = ""{
        didSet{
            self.canvas.id = id.lowercased()
            self.canvas.setBoardObservers()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.canvas.isUserInteractionEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }


    @IBAction func undoPath(_ sender: Any) {
        
        let lastPathKey = self.canvas.allKeys.last
        if let key = lastPathKey, id != ""{
            FBWhiteBoardManager.shared.removePath(boardID: id, pathID:key)
//            self.canvas.allPaths.removeLast()
//            self.canvas.allKeys.removeLast()
//            self.canvas.setNeedsDisplay()
        }
       // FBWhiteBoardManager.shared.resetValues(boardID: id+)
    }
    @IBAction func clearCanvas(_ sender: Any) {
        
        if id != ""{
            FBWhiteBoardManager.shared.resetValues(boardID: id)
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
        if (textField.text?.count)! > 0{
         textField.resignFirstResponder()
            
            id =  textField.text!
            self.canvas.isUserInteractionEnabled = true
            
            self.nameBox.isHidden = true
        return true
        }
        return false
    }
}
