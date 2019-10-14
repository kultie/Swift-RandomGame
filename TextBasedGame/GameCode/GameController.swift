//
//  GameController.swift
//  TextBasedGame
//
//  Created by longnt on 10/8/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import Foundation
import SpriteKit

enum Direction: Int {
    case UP, DOWN, LEFT, RIGHT
}

class GameController{
    
    var boardSize = 25
    let cameraSize = 25
    let cellSize = 30
    let scene: GameScene!
    var board: GameBoard!
    
    var top = 0
    var bottom = 0
    var left = 0
    var right = 0
    
    var player: Character!
    
    var enemies: [Enemy:Int] = [:]
    
    var centerX = 0
    var centerY = 0
    
    var chestCount = 0
    var enemiesCount = 0
    
    init(_ scene: GameScene){
        self.scene = scene
        createGameBoard()
    }
    
    func createGameBoard() {
        let mapData = getMapData()
        boardSize = mapData["size"].int!
        centerX = (boardSize - 1)/2
        centerY = (boardSize - 1)/2
        board = GameBoard(boardSize,mapData, self)
        player = Character(centerX,centerY,self)
        board.updateCell(player.posX, player.posY, CellType.PLAYER)
        drawBoard()
       scene.updateChestCount(chestCount)
        scene.updateEnemyCount(enemiesCount)

    }
    
    func getMapData()-> JSON{
        let filepath = Bundle.main.path(forResource: "map(\(Int.random(in: 1...3)))", ofType: "json")
        var jsonString: String!
        do {
            jsonString = try String(contentsOfFile: filepath!)
            print(jsonString)
        } catch {
            // contents could not be loaded
        }
        
        let data = jsonString.data(using: .utf8)!
        var json: JSON!
        do {
            json = try JSON(data: data)
        } catch {
            // contents could not be loaded
        }
        return json

    }
    
    func drawBoard(){
        
        let camY = min(max(player.posY,(cameraSize + 1) / 2),boardSize - (cameraSize - 1) / 2)
        let camX = min(max(player.posX,(cameraSize + 1) / 2),boardSize - (cameraSize - 1) / 2)
        bottom = max(0,camY - (cameraSize + 1) / 2)
        top = bottom + cameraSize
        
        left = max(0, camX - (cameraSize + 1) / 2)
        right = left + cameraSize
        board.labelPool.recycleAll()
        for j in bottom..<top{
            for i in left..<right{
                let cell = board.getCell(i, j)
                cell.setMark(board.labelPool.spawn()!)
                let label = cell.getMark()
                label.position = CGPoint(x: (i - left) * cellSize  - (cellSize * (cameraSize - 1) / 2), y: (j - bottom) * cellSize - (cellSize * (cameraSize - 1) / 2) + 100)
                label.fontSize = CGFloat(cellSize)
                scene.addChild(label)
            }
        }
    }
    
    func move(_ dir: Direction){
        player.move(dir)
        updateBoard()
    }
    
    func checkValidMove(_ x: Int, _ y: Int)-> Bool{
        if(board.outOfBound(x,y)){
            return false
        }
        if(!board.getCell(x, y).passable()){
            return false
        }
        
        return true;
    }
    
    func targetFrontCell(){
        let (cell, index) = player.getFrontCell()
        if let _cell = cell {
            if(_cell.type == CellType.NORMAL){
                _cell.updateCell(CellType.TARGETTING)
            }
            else if(_cell.type == CellType.CHEST){
                _cell.updateCell(CellType.CHESTOPENED)
                print("You have opened a chest")
                openChest()
            }
            else if(_cell.type == CellType.ENEMY){
                let enemy = enemies.first (where: {(k,v) in return v == index})!.key
                if(!enemy.takeDamage()){
                     _cell.updateCell(CellType.NORMAL)
                    killEnemy(enemy);
                    print("Killed a enemy")
                }
                
            }
        }
        updateBoard()
        scene.updateChestCount(chestCount)
        scene.updateEnemyCount(enemiesCount)
    }
    
    func updateBoard(){
        for e in enemies.keys{
            e.update()
        }
        drawBoard()
    
    }
    
    func addEnemy(_ x: Int, _ y: Int){
        enemies[Enemy(x,y,self)] = y*boardSize + x
        enemiesCount += 1
    }
    
    func updateEnemy(_ e: Enemy, _ x: Int, _ y: Int){
         enemies[e] = y*boardSize + x
    }
    
    func killEnemy(_ e: Enemy){
        e.status = false
        enemiesCount -= 1
    }
    
    func openChest(){
        chestCount -= 1
    }
    
    func addChest(){
        chestCount += 1
    }
}



