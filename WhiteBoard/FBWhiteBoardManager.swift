//
//  FBWhiteBoardManager.swift
//  WhiteBoard
//
//  Created by Asad Khan on 12/17/18.
//  Copyright © 2018 Asad Khan. All rights reserved.
//

import Foundation


class FBWhiteBoardManager{
    
    static let shared: FBWhiteBoardManager = FBWhiteBoardManager()
    lazy var ref: DatabaseReference! = Database.database().reference()
    
    let pathsInLine = NSMutableSet()
    
    func createBoardWith(id:String,data:Data){
        
        ref.child(id)
        
        ref.setValue(data)
    }
    
    func updateBoard(id:String,path:SNSPath)->String{
        
        let key = ref.child(id).childByAutoId()
        pathsInLine.add(key)
        if let dic = path.dictionary{
            key.setValue(dic) { (error, ref) in
                
                if error == nil{
                    self.pathsInLine.remove(key)
                }
            }
        }
        return key.key!
    }
    
    func observeChanges(for boardID:String,response:@escaping (DataSnapshot)->Void){
        
        ref.child(boardID).observe(.childAdded, with: { (snapshot) in
            response(snapshot)
        }) { (error) in
            
        }
        
    }
    
    func observeBoardCleared(for boardID:String,response:@escaping (DataSnapshot)->Void){
        
        ref.child(boardID).observe(.childRemoved, with: { (snapshot) in
            response(snapshot)
        }) { (error) in
            
        }
    }
    func removePath(boardID:String,pathID:String){
        
        ref.child(boardID).child(pathID).removeValue()
    }
    func resetValues(boardID:String){
        ref.child(boardID).removeValue()
    }
}

