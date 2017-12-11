//
//  ViewController.swift
//  RunBall
//
//  Created by João Carlos Fernandes Neto on 17-12-10.
//  Copyright © 2017 João Carlos Fernandes Neto. All rights reserved.
//
//----------------------------------
import UIKit
//----------------------------------
class ViewController: UIViewController {
    //----------------------------------
    var arr_of_circles = [UIView]()
    var arr_of_cos = [Double]()
    var arr_of_sin = [Double]()
    //----------------------------------
    var aTimer: Timer!
    var distance = Int(UIScreen.main.bounds.height)
    //----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        createCircles(numberOfCircles: 20)
        addToCosAndSinArrays()
        createAndPlaceCicles()
        launchAnimation()
    }
    //----------------------------------
    func createCircles(numberOfCircles: Int) {
        for _ in 1...numberOfCircles {
            let aCircles = UIView()
            aCircles.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
            aCircles.backgroundColor = UIColor(red: 231/255, green: 77/255, blue: 92/255, alpha: 0.9)
            self.view.addSubview(aCircles)
            arr_of_circles.append(aCircles)
        }
    }
    //----------------------------------
    func addToCosAndSinArrays() {
        for _ in 0...arr_of_circles.count {
            let ramdomAngle = Double(arc4random_uniform(360))
            arr_of_cos.append(__cospi(ramdomAngle/180))
            arr_of_sin.append(__sinpi(ramdomAngle/180))
        }
    }
    //----------------------------------
    func createAndPlaceCicles() {
        for aCircles in arr_of_circles {
            aCircles.layer.cornerRadius = 12.5
            aCircles.center.x = UIScreen.main.bounds.width / 2
            aCircles.center.y = CGFloat(0)
        }
    }
    //----------------------------------
    func launchAnimation() {
        aTimer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(animate), userInfo: nil, repeats: true)
    }
    //----------------------------------
    @objc func animate() {
        if distance <= 0 {
            aTimer.invalidate()
            aTimer = nil
            arr_of_sin = []
            arr_of_cos = []
            distance = Int(UIScreen.main.bounds.height)
            for aCircles in arr_of_circles {
                aCircles.layer.cornerRadius = 12.5
                aCircles.center.x = UIScreen.main.bounds.width / 2
                aCircles.center.y = CGFloat(0)
            }
            addToCosAndSinArrays()
            launchAnimation()
        }
        distance -= 1
        for i in 0..<arr_of_circles.count {
            arr_of_circles[i].center.x += CGFloat(arr_of_cos[i])
            arr_of_circles[i].center.y += CGFloat(arr_of_sin[i])
        }
        
    }
}
