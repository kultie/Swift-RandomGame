//
//  GameBoard.swift
//  TextBasedGame
//
//  Created by longnt on 10/8/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import Foundation
import SpriteKit
enum CellType{case NORMAL, BUSY, BLOCK, PLAYER, TARGETTING, CHEST, CHESTOPENED, ENEMY}
class GameCell: Copying{
    var type: CellType
    private var mark: SKLabelNode!
    
    required init(original: GameCell) {
        self.type = original.type
        self.convertMark(self.type)
    }
    
    init(_ type: CellType){
        self.type = type
    }
    
    func setMark(_ mark: SKLabelNode){
        mark.removeFromParent()
        self.mark = mark
        convertMark(self.type)
    }
    
    func updateCell(_ type: CellType){
        self.type = type
        if(self.mark != nil){
            convertMark(self.type)
        }
    }
    
    func getMark() -> SKLabelNode{
        return mark
    }
    
    func convertMark(_ type: CellType){
        mark.fontColor = SKColor.white
        switch type {
        case CellType.BLOCK:
            mark.text = "#"
          
        case CellType.BUSY:
            mark.text = "X"
             break;
        case CellType.NORMAL:
             mark.text = "."
             break;
        case CellType.PLAYER:
            mark.text = "O"
            break;
        case CellType.CHEST:
            mark.text = "▢"
            mark.fontColor = SKColor.yellow
            break;
        case CellType.CHESTOPENED:
            mark.text = "▢"
            break;
        case CellType.TARGETTING:
            mark.text = "▢"
            mark.fontColor = SKColor.red
        case CellType.ENEMY:
            mark.text = "X"
            mark.fontColor = SKColor.orange
        }
    }
    
    func passable() -> Bool{
        return self.type == CellType.NORMAL || self.type == CellType.TARGETTING
    }
    
    func interactable()-> Bool{
        return passable() || self.type == CellType.CHEST || self.type == CellType.ENEMY || self.type == CellType.CHESTOPENED
    }
}

class GameBoard{
    var board: [GameCell] = []
    var size = 0
    
    let gameController: GameController!
    
    let overPopLimit = 8
    let starvationLimit = 5
    let birthLimit = 4
    
    var labelPool: ObjectPool<SKLabelNode>
    
    init(_ size: Int, _ mapData: JSON, _ gameController: GameController){
        self.size = size
        self.gameController = gameController
        var data = mapData["map"]
        let rnd = Int.random(in: 1...4)
        labelPool = ObjectPool<SKLabelNode>({ () -> SKLabelNode? in
            return SKLabelNode(text: "_")
        })
        for _ in 0..<rnd{
           data = rotateData(data)
        }
        
        for i in 0..<size*size{
            var cell: GameCell
            if(data[i].int == 0){
                cell = GameCell(CellType.NORMAL)
            }
            else if (data[i].int == 1){
                cell = GameCell(CellType.BLOCK)
            }
            else if(data[i].int == 2){
                cell = GameCell(CellType.CHEST)
                  gameController.addChest()
            }
            else if(data[i].int == 3){
                cell = GameCell(CellType.ENEMY)
                gameController.addEnemy(i % size, i / size)
            }
            else{
                cell = GameCell(CellType.BUSY)
            }
            board.append(cell)
        }
    }
    
    func rotateData(_ data: JSON) -> JSON{
        return reverseColumns(transpose(data))
    }
    
    func reverseColumns(_ data: JSON) -> JSON{
        var tmpData = data
        for i in 0 ..< size{
            var j = 0
            var k = size - 1
            while(j < k){
                let tmp = tmpData[i * size + j]
                tmpData[i * size + j] = tmpData[i * size + k]
                tmpData[i * size + k] = JSON(tmp)
                j += 1
                k -= 1
            }
        }
        return tmpData
    }
    
    func transpose(_ data: JSON) -> JSON{
        var tmpData = data
        for i in 0 ..< size{
            for j in i..<size{
                let tmp = tmpData[i * size + j]
                tmpData[i * size + j ] = tmpData[j * size + i]
                tmpData[j * size + i] = JSON(tmp)
            }
        }
        return tmpData
    }
    
    func updateCell(_ x: Int, _ y: Int, _ type: CellType){
        let index = y*size + x
        board[index].updateCell(type)
    }
    
    func getCell(_ x: Int, _ y: Int) -> GameCell{
        let index = y * size + x
        return board[index]        
    }
    
    func outOfBound(_ x: Int, _ y: Int) -> Bool{
        if(x<0 || x >= size || y < 0 || y >= size){
            return true
        }
        return false
    }
}



