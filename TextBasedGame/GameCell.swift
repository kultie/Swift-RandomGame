//
//  GameCell.swift
//  TextBasedGame
//
//  Created by longnt on 10/8/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import Foundation
import SpriteKit

class GameCell{
    var shape: SKShapeNode!    
    
    func setShape(_ shape: SKShapeNode){
        self.shape = shape
    }
    
    func getShape() -> SKShapeNode{
        return shape
    }
}
