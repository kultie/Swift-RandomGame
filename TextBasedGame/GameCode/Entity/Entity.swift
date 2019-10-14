//
//  Entity.swift
//  TextBasedGame
//
//  Created by longnt on 10/9/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import Foundation
import SpriteKit

class Entity{
    var posX: Int
    var posY: Int
    var gameController: GameController
    init(_ x: Int, _ y: Int, _ gameController: GameController) {
        self.posX = x
        self.posY = y
        self.gameController = gameController
    }
}

enum Facing{ case UP, DOWN, LEFT, RIGHT}
class Character: Entity{
    var facing = Facing.UP
    
    override init(_ x: Int, _ y: Int, _ gameController: GameController) {
        super.init(x, y, gameController)
    }
    
    func updateFacing(_ value: Facing){
        facing = value
    }
    
    func getIndexFacingAt() -> Int{
        var deltaX = 0
        var deltaY = 0
        
        switch facing {
            case Facing.UP:
                deltaY = 1
                break
            case Facing.DOWN:
                deltaY = -1
                break
            case Facing.LEFT:
                deltaX = -1
                break
            case Facing.RIGHT:
                deltaX = 1
                break
        }
        let nextIndex = (posY + deltaY) * gameController.boardSize + (posX + deltaX)
        return nextIndex
    }
    
    func getFrontCell() -> (GameCell?,Int){
        let index = getIndexFacingAt()
        if(index >= 0 && index < gameController.board.board.count){
            let cell = gameController.board.board[index]
            if(cell.interactable()){
                return (cell,index)
            }
        }
        return (nil,-1)
    }
    
    func move(_ dir: Direction){
        var newX = posX
        var newY = posY
        var deltaX = 0
        var deltaY = 0
        let(frontCell, index) = getFrontCell()
        if let _frontCell = frontCell{
            if(_frontCell.type == CellType.TARGETTING){
                            _frontCell.updateCell(CellType.NORMAL)
            }
        }
        switch dir {
        case Direction.UP:
            deltaY = 1
            updateFacing(Facing.UP)
            break;
        case Direction.DOWN:
            deltaY = -1
            updateFacing(Facing.DOWN)
            break;
        case Direction.LEFT:
            deltaX = -1
            updateFacing(Facing.LEFT)
            break;
        case Direction.RIGHT:
            deltaX = 1
            updateFacing(Facing.RIGHT)
            break;
        }
        let facing = atan2(-CGFloat(deltaX),CGFloat(deltaY))
        gameController.scene.updateActionButtonRotation(facing)
        
        if(gameController.checkValidMove(newX + deltaX, newY + deltaY)){
            newX = newX + deltaX
            newY = newY + deltaY
            let oldCell = gameController.board.getCell(posX, posY)
            let newCell = gameController.board.getCell(newX, newY )
            if(oldCell.type == CellType.PLAYER){
                oldCell.updateCell(CellType.NORMAL)
            }
            newCell.updateCell(CellType.PLAYER)
            posX = newX
            posY = newY
        }
    }
}

protocol Interactable: Hashable{
    func update()
}

class Chest: Entity, Interactable{
    func update() {
        
    }
    
    static func == (lhs: Chest, rhs: Chest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var hashValue: Int{
        get{
            return UUID().hashValue
        }
    }
}

class Enemy: Entity, Interactable {
    var status = true
    var health = 2
    func update() {
        if(status){
            var newX = posX
            var newY = posY
            var deltaX = 0
            var deltaY = 0
            
            let dir = Direction(rawValue: Int.random(in: 0...3))!
            
            switch dir {
            case Direction.UP:
                deltaY = 1
                break;
            case Direction.DOWN:
                deltaY = -1
                break;
            case Direction.LEFT:
                deltaX = -1
                break;
            case Direction.RIGHT:
                deltaX = 1
                break;
            }
            
            if(gameController.checkValidMove(newX + deltaX, newY + deltaY)){
                newX = newX + deltaX
                newY = newY + deltaY
                let oldCell = gameController.board.getCell(posX, posY)
                let newCell = gameController.board.getCell(newX, newY )
                if(oldCell.type == CellType.ENEMY){
                     oldCell.updateCell(CellType.NORMAL)
                }
                newCell.updateCell(CellType.ENEMY)
                posX = newX
                posY = newY
            }
            gameController.updateEnemy(self, posX, posY)
        }
       
    }
    
    static func == (lhs: Enemy, rhs: Enemy) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    let _hasValue = UUID().hashValue
    var hashValue: Int{
        get{
            return _hasValue
        }
    }
    
    func takeDamage()-> Bool{
        health -= 1
         return health > 0
    }
}
