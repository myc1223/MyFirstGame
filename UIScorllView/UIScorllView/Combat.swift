//
//  Combat.swift
//  UIScorllView
//
//  Created by 宮里佑太 on 2017/04/13.
//  Copyright © 2017年 miyazatoyuuta. All rights reserved.
//

import UIKit


class Combat {
    var lableCount:Int = 0
    let height = UIScreen.main.bounds.height
    let width = UIScreen.main.bounds.width
    let SView:UIScrollView
    
    init(SView:inout UIScrollView) {
        self.SView = SView
    }
    
    func combatLabel(titel:String) {
        let lable = UILabel()
        lable.backgroundColor = UIColor.black
        lable.textColor = UIColor.white
        lable.text = titel
        self.lableCount += 1
        lable.center = CGPoint(x: 0, y: CGFloat(20 * self.lableCount + 100))
        lable.sizeToFit()
        lable.frame.size.width = width
        print(lable.frame.size)
        self.SView.addSubview(lable)
    }
    
    func combatLabel(titel:String, affiliation:String) {
        let lable = UILabel()
        lable.backgroundColor = UIColor.black
        switch affiliation {
        case "ally":
            lable.textColor = UIColor.green
        case "enemy":
            lable.textColor = UIColor.red
        default:
            print("エラー")
        }
        lable.text = titel
        self.lableCount += 1
        lable.center = CGPoint(x: 0, y: CGFloat(20 * self.lableCount + 100))
        lable.sizeToFit()
        lable.frame.size.width = width
        print(lable.frame.size)
        self.SView.addSubview(lable)
    }
    
        var stage:Int = 0
        var allies = [[String:Any]]()
        var enemies = [[String:Any]]()
        var all = [[String:Any]]()
        var object = [[String:Any]]()
        
        func join(allies:[[String:Any]], enemies:[[String:Any]]) {
            self.allies = allies
            self.enemies = enemies
            self.all = allies + enemies
        }
        
        func summarized() {
            self.all = self.allies + self.enemies
        }
        
        func selectAlly() {
            self.object.removeAll()
            for i in 0..<self.all.count {
                let h = self.all[i]["affiliation"] as! String
                if h == "ally" {
                    self.object.append(self.all[i])
                }
            }
        }
        
        func selectEnemy() {
            self.object.removeAll()
            for i in 0..<self.all.count {
                let h = self.all[i]["affiliation"] as! String
                if h == "enemy" {
                    self.object.append(self.all[i])
                }
            }
        }
        
        func updateAll() {
            for i in 0..<object.count {
                let h = object[i]["number"] as! Int
                switch object[i]["affiliation"] as! String {
                case "ally":
                    self.allies[h] = object[i]
                case "enemy":
                    self.enemies[h] = object[i]
                default:
                    print("値がありません")
                }
            }
            self.summarized()
        }
        
        func behaviorOrder(fighters:[[String:Any]]) -> [String:Int] { // 行動順を調べる
            self.summarized()
            var sortBySpeed = [String:Any]()
            var h = [Int]()
            
            for i in 0..<self.all.count {
                sortBySpeed[String(i)] = self.all[i]["speed"] as! Int * Int(self.arc4random(lower: 70, upper: 100))
            }
            _ = Int(self.maxDicKey(dic: sortBySpeed as! [String : Int]))! //　最も速い
            
            for i in 0..<self.all.count {
                let hp = self.all[i]["hp"] as! Int
                if  hp <= 0 {
                    h.append(i)
                }
            }
            for i in h {
                sortBySpeed.removeValue(forKey: String(i))
            }
            return sortBySpeed as! [String:Int]
        }
        
        func behaviorProcess(behaviorOrder:[String:Int]) -> [String:Int] { // なんの行動をするか
            let topSpeed = Int(self.maxDicKey(dic: behaviorOrder))
            let char = self.all[topSpeed!]
            switch char["affiliation"] as! String {
            case "ally":
                self.selectAlly()
            case "enemy":
                self.selectEnemy()
            default:
                print("誰？")
            }
            
            let AKRate = self.all[topSpeed!]["AKRate"] as! Int
            let MAKRate = self.all[topSpeed!]["MAKRate"] as! Int
            var RMRate = self.all[topSpeed!]["RMRate"] as! Int
            let RMtargetOfHp0 = self.rejectHp0(object: object)
            let RMtargetOfNoHpMax = self.selectHpIsNotMax(object: RMtargetOfHp0)
            if RMtargetOfNoHpMax.count <= 0 {
                RMRate = 0
            }
            
            
            if Int(self.arc4random(lower: 0, upper: 100)) < AKRate { // 攻撃型行動
                if Int(self.arc4random(lower: 0, upper: 100)) < MAKRate {
                    print("mk")
                } else if Int(self.arc4random(lower: 0, upper: 100)) < RMRate {
                    print("rm")
                } else {
                    self.physicalAttack(topSpeedChara: char)
                }
            } else { // 防御型行動
                if Int(self.arc4random(lower: 0, upper: 101)) < RMRate {
                    print("rm")
                } else if Int(self.arc4random(lower: 0, upper: 101)) < MAKRate {
                    print("mk")
                } else {
                    print("df")
                }
                
            }
            var newBegaviorOrder = behaviorOrder
            newBegaviorOrder.removeValue(forKey: String(topSpeed!))
            return newBegaviorOrder
        }
        
        func rejectHp0(object:[[String:Any]]) -> [[String:Any]]{
            var target = [[String:Any]]()
            for i in object {
                let hp = i["hp"] as! Int
                guard hp > 0 else {
                    continue
                }
                target.append(i)
            }
            return target
        }
        
        func selectHp0(object:[[String:Any]]) -> [[String:Any]]{
            var target = [[String:Any]]()
            for i in object {
                let hp = i["hp"] as! Int
                guard hp <= 0 else {
                    continue
                }
                target.append(i)
            }
            return target
        }
        
        func selectHpIsNotMax(object:[[String:Any]]) -> [[String:Any]]{
            var target = [[String:Any]]()
            for i in object {
                let hp = i["hp"] as! Int
                let maxHp = i["maxHp"] as! Int
                guard hp < maxHp else {
                    continue
                }
                target.append(i)
            }
            return target
        }
        
        func sortFormation(survivor:[[String:Any]]) -> [[String:Any]] {
            
            func sortTairetu(s1: [String:Any],s2: [String:Any]) -> Bool {
                let a = s1["formation"] as! Int
                let b = s2["formation"] as! Int
                return a < b
            }
            
            return survivor.sorted(by: sortTairetu)
            
        }
        
        func chackHitRate(survivorOfFormation:[[String:Any]]) -> [[String:Any]] {
            var SOF = survivorOfFormation
            var hitRate:Double = 100.0
            for i in 0..<SOF.count {
                hitRate = hitRate / 2
                if i == SOF.count - 1 {
                    hitRate += hitRate
                }
                SOF[i]["hitRate"] = hitRate
            }
            return SOF
        }
        
        func target(chackedHitRate:[[String:Any]]) -> [String:Any] {
            let randomValue = Double(arc4random_uniform(101))
            var x:Double = 0.0
            var target = [String:Any]()
            for i in chackedHitRate {
                let value = i["hitRate"] as! Double
                x = x + value
                if randomValue <= x {
                    target = i
                    break
                }
            }
            return target
        }
        
        func physicalAttack(topSpeedChara:[String:Any]) {
            var attacker = topSpeedChara
            let attackerHp = attacker["hp"] as! Int
            if attackerHp <= 0 {
                return
            }
            let attackerAttacks = attacker["attackCount"] as! Int
            switch attacker["affiliation"] as! String {
            case "ally":
                self.selectEnemy()
            case "enemy":
                self.selectAlly()
            default:
                print("誰？")
            }
            print("\(attacker["name"]!)の\(attacker["attackCount"]!)回攻撃")
            self.combatLabel(titel: "\(attacker["name"]!)の\(attacker["attackCount"]!)回攻撃", affiliation:attacker["affiliation"] as! String)
            for _ in 0..<attackerAttacks {
                let survivor = self.rejectHp0(object: object)
                if survivor.count == 0 {
                    break
                }
                
                let survivorOfFormation = self.sortFormation(survivor: survivor)
                let chackHitRate = self.chackHitRate(survivorOfFormation: survivorOfFormation)
                var target = self.target(chackedHitRate: chackHitRate)
                let attack = attacker["attack"] as! Int * Int(self.arc4random(lower: 70, upper: 100)) / 100
                let defense = target["defense"] as! Int * Int(self.arc4random(lower: 70, upper: 100)) / 100
                var damage = attack - defense
                if damage <= 0 {
                    damage = 1
                }
                let hp = target["hp"] as! Int
                var resultHp = hp - damage
                if resultHp < 0 {
                    resultHp = 0
                }
                
                target["hp"] = resultHp
                
                target["totalHit"] = target["totalHit"] as! Int + 1
                target["totalDamage"] = target["totalDamage"] as! Int + damage
                
                for i in self.object {
                    let tar = target["number"] as! Int
                    let obj = i["number"] as! Int
                    if tar == obj {
                        self.object[tar] = target
                    }
                }
            }
            
            for h in 0..<self.object.count {
                var i = self.object[h]
                let hit = i["totalHit"] as! Int
                let hp = i["hp"] as! Int
                if hit > 0 {
                    print("\(i["name"]!)に \(i["totalDamage"]!)のダメージ[\(i["totalHit"]!)Hit]")
                    self.combatLabel(titel: "\(i["name"]!)に \(i["totalDamage"]!)のダメージ[\(i["totalHit"]!)Hit]")
                    if hp <= 0 {
                        print("\(i["name"]!)は倒れた")
                        self.combatLabel(titel: "\(i["name"]!)は倒れた")
                    }
                }
                self.object[h]["totalHit"] = 0
                self.object[h]["totalDamage"] = 0
            }
            self.combatLabel(titel: " ")
            self.updateAll()
        }
        
        func magicAttack() {
            
        }
        
        func recoveryMagic() {
            
        }
        
        func defense() {
            
        }
        
        func maxDicKey(dic:[String:Int]) -> String {
            let max = dic.values.max()
            var maxKey:String = ""
            
            for (key,value) in dic {
                if value == max{ // maxは一つ
                    if maxKey == ""{ // maxが二つ以上ならfaulsになる
                        maxKey = key
                    } else {
                        
                    }
                }
            }
            return maxKey
        }
        
        func arc4random(lower: UInt32, upper: UInt32) -> UInt32 {
            guard upper >= lower else {
                return 0
            }
            return arc4random_uniform(upper - lower) + lower
        }
        
        
    }
    
