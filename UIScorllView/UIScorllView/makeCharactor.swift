//
//  makeCharactor.swift
//  UIScorllView
//
//  Created by 宮里佑太 on 2017/04/13.
//  Copyright © 2017年 miyazatoyuuta. All rights reserved.
//

import UIKit

class makeCharactor {
    
    var affiliation:String = ""
    var number:Int = 0
    var name:String = ""
    var level:Int = 0
    var maxHp:Int = 0
    var hp:Int = 0
    var attack:Int = 0
    var attackCount:Int = 0
    var magicAttack:Int = 0
    var recoveryMagic:Int = 0
    var defense:Int = 0
    var speed:Int = 0
    var AKRate:Int = 0
    var MAKRate:Int = 0
    var RMRate:Int = 0
    var formation:Int = 0
    var hitRate:Double = 0.0
    var charaDate = [[String:Any]]()
    
    init() { // キャラのデータの箱を100個用意
        for _ in 1...100 {
            charaDate.append([:])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func make(affiliation:String, name:String, level:Int, maxHp:Int, attack:Int, attackCount:Int, magicAttack:Int,recoveryMagic:Int, defense:Int, speed:Int, AKRate:Int, MAKRate:Int, RMRate:Int) {
        var emptyArray = [Int]()
        for i in 0..<charaDate.count { // 空の箱を取得
            if charaDate[i].isEmpty {
                emptyArray.append(i)
            }
        }
        self.affiliation = affiliation
        self.number = emptyArray.min()! // 空の箱から最も低いindexを取得
        self.name = name
        self.level = level
        self.maxHp = maxHp
        self.hp = maxHp
        self.attack = attack
        self.attackCount = attackCount
        self.magicAttack = magicAttack
        self.recoveryMagic = recoveryMagic
        self.defense = defense
        self.speed = speed
        self.AKRate = AKRate
        self.MAKRate = MAKRate
        self.RMRate = RMRate
        
        charaDate[number]["affiliation"] = affiliation
        charaDate[number]["number"] = number
        charaDate[number]["name"] = name
        charaDate[number]["level"] = level
        charaDate[number]["maxHp"] = maxHp
        charaDate[number]["hp"] = maxHp
        charaDate[number]["attack"] = attack
        charaDate[number]["attackCount"] = attackCount
        charaDate[number]["magicAttak"] = magicAttack
        charaDate[number]["recoveryMagic"] = recoveryMagic
        charaDate[number]["defense"] = defense
        charaDate[number]["speed"] = speed
        charaDate[number]["AKRate"] = AKRate
        charaDate[number]["MAKRate"] = MAKRate
        charaDate[number]["RMRate"] = RMRate
        charaDate[number]["formation"] = 0
        charaDate[number]["hitRate"] = 0.0
        charaDate[number]["totalHit"] = 0
        charaDate[number]["totalDamage"] = 0
        charaDate[number]["totalRecover"] = 0
    }
    
}
