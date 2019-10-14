//
//  ObjectPool.swift
//  TextBasedGame
//
//  Created by longnt on 10/8/19.
//  Copyright © 2019 longnt. All rights reserved.
//

import Foundation

class PoolObjectContainer<T>{
    private var data: T?
    init(_ data: T?) {
        self.data = data
    }
    
    func getData() -> T?{
        return self.data
    }
}

class ObjectPool<T> where T: Hashable{
    var spawnedObjects: Dictionary<T, PoolObjectContainer<T>>
    var pooledObjects: Queue<PoolObjectContainer<T>>
    var constructor: ()-> T?
    
    init(_ constructor: @escaping ()-> T?, _ initialSize: Int = 0) {
        spawnedObjects = [:]
        pooledObjects = Queue<PoolObjectContainer>()
        self.constructor = constructor
        if(initialSize != 0){
            createPool(initialSize)
        }
    }
    
    private func createPool(_ initialSize: Int){
        for _ in 0..<initialSize{
            createContainer(self.constructor());
        }
    }
    
    private func createContainer(_ data: T?){
        if(data != nil){
            let container = PoolObjectContainer(data)
            pooledObjects.enqueue(container)
        }
    }
    
    func spawn() -> T?{
        var container: PoolObjectContainer<T>? = nil
        container = pooledObjects.dequeue()
        if(container == nil){
            container = PoolObjectContainer(self.constructor())
        }
        let data = container!.getData()
        if(data != nil){
            spawnedObjects[data!] = container
        }
         return data
    }
    
    func recycle(_ data: T){
        if(spawnedObjects[data] != nil){
            let conatainer = spawnedObjects[data]
            pooledObjects.enqueue(conatainer!)
            spawnedObjects[data] = nil
        }
    }
    
    func recycleAll(){
        for (_,v) in spawnedObjects{
            recycle(v.getData()!)
        }
    }
    
    func countSpawned() -> Int{
        return spawnedObjects.count
    }
    
    func countPooled() -> Int{
        return pooledObjects.count()
    }
}

struct Queue<T>{
    var list: [T]
    
    init() {
        list = []
    }
    
    mutating func enqueue(_ e: T){
        list.append(e)
    }
    
    mutating func dequeue() -> T?{
        if(!list.isEmpty){
            return list.removeFirst()
        }
        return nil
    }
    
    func peek() -> T?{
        if(!list.isEmpty){
            return list[0]
        }
        return nil
    }
    
    func isEmpty() -> Bool{
        return list.isEmpty
    }
    
    func count() -> Int{
        return list.count
    }
}


