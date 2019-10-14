//
//  GameScene.swift
//  TextBasedGame
//
//  Created by longnt on 10/8/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var gameController: GameController!
    
    var upButton: SKShapeNode!
    var downButton: SKShapeNode!
    var leftButton: SKShapeNode!
    var rightButton: SKShapeNode!
    var actionButton: SKSpriteNode!
    
    var enemyRemainLabel: SKLabelNode!
    var chestRemainLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
               createGameUI()
        self.gameController = GameController(self) 
    }
    
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.nodes(at: location)
            for node in touchedNode {
                if node.name == "action"{
                    gameController.targetFrontCell()
                }
                if node.name == "up" {
                    gameController.move(Direction.UP)
                }
                if node.name == "down" {
                    gameController.move(Direction.DOWN)
                }
                if node.name == "left" {
                    gameController.move(Direction.LEFT)
                }
                if node.name == "right" {
                    gameController.move(Direction.RIGHT)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    let buttonPoint = 50
    
    func createGameUI(){
        //Up Button
        upButton = SKShapeNode()
        upButton.name = "up"
        upButton.zPosition = 1
        upButton.fillColor = SKColor.cyan
        upButton.position = CGPoint(x:0, y:(frame.size.height / -2) + 320)
        let up_TopCorner = CGPoint(x:0, y:buttonPoint)
        let up_bottomCorner = CGPoint(x: -buttonPoint, y: -buttonPoint)
        let up_middle = CGPoint(x: buttonPoint, y: -buttonPoint)
        let up_path = CGMutablePath()
        up_path.addLine(to: up_TopCorner)
        up_path.addLines(between: [up_TopCorner, up_bottomCorner, up_middle])
        upButton.path = up_path
        self.addChild(upButton)
        
        //Down Button
        downButton = SKShapeNode()
        downButton.name = "down"
        downButton.zPosition = 1
        downButton.fillColor = SKColor.cyan
        downButton.position = CGPoint(x:0, y:(frame.size.height / -2) + 80)
        let down_TopCorner = CGPoint(x:0, y:-buttonPoint)
        let down_bottomCorner = CGPoint(x: -buttonPoint, y: buttonPoint)
        let down_middle = CGPoint(x: buttonPoint, y: buttonPoint)
        let down_path = CGMutablePath()
        down_path.addLine(to: down_TopCorner)
        down_path.addLines(between: [down_TopCorner, down_bottomCorner, down_middle])
        downButton.path = down_path
        self.addChild(downButton)
        
        //Left Button
        leftButton = SKShapeNode()
        leftButton.name = "left"
        leftButton.zPosition = 1
        leftButton.fillColor = SKColor.cyan
        leftButton.position = CGPoint(x:-120, y:(frame.size.height / -2) + 200)
        let left_TopCorner = CGPoint(x:buttonPoint, y:buttonPoint)
        let left_bottomCorner = CGPoint(x: buttonPoint, y: -buttonPoint)
        let left_middle = CGPoint(x: -buttonPoint, y: 0)
        let left_path = CGMutablePath()
        left_path.addLine(to: left_TopCorner)
        left_path.addLines(between: [left_TopCorner, left_bottomCorner, left_middle])
        leftButton.path = left_path
        self.addChild(leftButton)
        
        //Right Button
        rightButton = SKShapeNode()
        rightButton.name = "right"
        rightButton.zPosition = 1
        rightButton.fillColor = SKColor.cyan
        rightButton.position = CGPoint(x:120, y:(frame.size.height / -2) + 200)
        let right_TopCorner = CGPoint(x:-buttonPoint, y:buttonPoint)
        let right_bottomCorner = CGPoint(x: -buttonPoint, y: -buttonPoint)
        let right_middle = CGPoint(x: buttonPoint, y: 0)
        let right_path = CGMutablePath()
        right_path.addLine(to: right_TopCorner)
        right_path.addLines(between: [right_TopCorner, right_bottomCorner, right_middle])
        rightButton.path = right_path
        self.addChild(rightButton)
        
        //Action Button
        actionButton = SKSpriteNode(imageNamed: "Direction.png")
        actionButton.name = "action"
        actionButton.zPosition = 1
        actionButton.setScale(1.5)
        actionButton.position = CGPoint(x:0,  y:(frame.size.height / -2) + 200)
        self.addChild(actionButton)
        
        //Enemy remain label
        enemyRemainLabel = SKLabelNode(text: " X Enemy: ")
        enemyRemainLabel.zPosition = 1
        enemyRemainLabel.position = CGPoint(x: -150, y:(frame.size.height / 2) - 100)
        self.addChild(enemyRemainLabel)
        
        //Chest remain label
        chestRemainLabel = SKLabelNode(text: " ▢ Chest: ")
        chestRemainLabel.zPosition = 1
        chestRemainLabel.position = CGPoint(x: 150, y:(frame.size.height / 2) - 100)
        self.addChild(chestRemainLabel)
    }
    
    func updateActionButtonRotation(_ value: CGFloat){
        actionButton.zRotation = value
    }
    
    func updateEnemyCount(_ val: Int){
        enemyRemainLabel.text = " X Enemy: \(val)"
    }
    
    func updateChestCount(_ val: Int){
        chestRemainLabel.text = " ▢ Chest:  \(val)"
    }
}
