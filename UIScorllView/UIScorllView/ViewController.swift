//
//  ViewController.swift
//  UIScorllView
//
//  Created by 宮里佑太 on 2017/03/22.
//  Copyright © 2017年 miyazatoyuuta. All rights reserved.
//

import UIKit
import SpriteKit


class ViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView = UIScrollView()

    
    let char = makeCharactor()
    var alliesMember = [[String:Any]]()
    let enemy = makeCharactor()
    var enemyMember = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        char.make(affiliation: "ally", name: "宮里佑太", level: 1, maxHp: 10, attack: 5, attackCount: 1, magicAttack: 2, recoveryMagic: 50, defense: 5, speed: 3, AKRate: 100, MAKRate: 0, RMRate: 0)
        char.charaDate[0]["formation"] = 2
        
        char.make(affiliation: "ally",name: "セイバー", level: 1, maxHp: 15000, attack: 200, attackCount: 8, magicAttack: 30, recoveryMagic: 100, defense: 44, speed: 10, AKRate: 100, MAKRate: 0, RMRate: 0)
        char.charaDate[1]["formation"] = 0
        
        char.make(affiliation: "ally",name: "アーチャー", level: 1, maxHp: 3500, attack: 100, attackCount: 20, magicAttack: 35, recoveryMagic: 50, defense: 25, speed: 100, AKRate: 100, MAKRate: 0, RMRate: 0)
        char.charaDate[2]["formation"] = 1
        
        for i in 1...10 {
            char.make(affiliation: "ally", name: "兵士\(i)", level: 1, maxHp: 200, attack: 20, attackCount: 1, magicAttack: 0, recoveryMagic: 0, defense: 8, speed: 8, AKRate: 100, MAKRate: 0, RMRate: 0)
            let h = i + 2
            char.charaDate[h]["formation"] = h
        }
        
        alliesMember.append(char.charaDate[0])
        alliesMember.append(char.charaDate[1])
        alliesMember.append(char.charaDate[2])
        
        for i in 3...12 {
            alliesMember.append(char.charaDate[i])
        }
        
        enemy.make(affiliation: "enemy",name: "ニャルラトホテプ", level: 1, maxHp: 20000, attack: 60, attackCount: 100, magicAttack: 100, recoveryMagic: 80, defense: 10, speed: 230, AKRate: 100, MAKRate: 0, RMRate: 0)
        enemy.charaDate[0]["formation"] = 1
        
        enemyMember.append(enemy.charaDate[0])

        
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "stone")?.draw(in: self.view.bounds)
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        scrollView.backgroundColor = UIColor(patternImage: image)
        
        let height = UIScreen.main.bounds.height
        let width = UIScreen.main.bounds.width
        
        scrollView.frame.size = CGSize(width: width, height: height - height / 10)
        scrollView.center = self.view.center
        
        scrollView.contentSize = CGSize(width: width, height: height)
        
        scrollView.indicatorStyle = .white
        
        scrollView.delegate = self
        
        let button = UIButton()
        button.setTitle("戦う", for: .normal)
        button.frame.size = CGSize(width: width, height: height / 10)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(CM), for: .touchUpInside)
        button.center = CGPoint(x: width / 2, y: CGFloat(50))
        scrollView.addSubview(button)
        
        
        self.view.addSubview(scrollView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CM() {
        
        let start = Date()
        var a = 0
        for _ in 0..<10000{
            a += 1
        }
        
        let combat = Combat(SView: &scrollView)
        combat.join(allies: alliesMember, enemies: enemyMember)
        var behaviorOrder1 = combat.behaviorOrder(fighters: combat.all)
        for i in 1...20 {
            scrollView.contentSize.height = CGFloat(20 * combat.lableCount) + combat.height / 2
            
            combat.selectAlly()
            let hp = combat.rejectHp0(object: combat.object)
            if hp.count == 0 {
                combat.combatLabel(titel: "全滅した")
                break
            }
            combat.selectEnemy()
            let hp2 = combat.rejectHp0(object: combat.object)
            if hp2.count == 0 {
                combat.combatLabel(titel: "勝利した")
                break
            }
            behaviorOrder1 = combat.behaviorOrder(fighters: combat.all)
            combat.combatLabel(titel: "")
            combat.combatLabel(titel: "\(i)ターン目")
            combat.selectAlly()
            var A = combat.sortFormation(survivor: combat.object)
            A = combat.chackHitRate(survivorOfFormation: A)
            for i in A {
                let name = i["name"] as! String
                let maxHp = i["maxHp"] as! Int
                let hp = i["hp"] as! Int
                var deth:String = ""
                if hp == 0 {
                    deth = "(死亡)"
                }
                combat.combatLabel(titel: "(\(hp)/\(maxHp))\(name)\(deth)")
            }
            combat.combatLabel(titel: "vs")
            for i in combat.enemies {
                let name = i["name"] as! String
                let maxHp = i["maxHp"] as! Int
                let hp = i["hp"] as! Int
                combat.combatLabel(titel: "(\(hp)/\(maxHp))\(name)")
            }
            combat.combatLabel(titel: " ")
            while behaviorOrder1.count > 0 {
                behaviorOrder1 = combat.behaviorProcess(behaviorOrder: behaviorOrder1)
            }
        }
        self.view.addSubview(scrollView)
        
        let time = Date().timeIntervalSince(start)
        print("progress：\(time)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("didScroll")
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("")
    }


}

