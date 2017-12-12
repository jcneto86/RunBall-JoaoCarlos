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
    @IBOutlet weak var manBallImage: UIImageView!
    @IBOutlet weak var manBallView: UIView!
    @IBOutlet weak var viewFond: UIView!
    @IBOutlet weak var bestScoreTimeLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var scoreTimeLabel: UILabel!
    //----------------------------------
    var balls_move = [UIView]()
    var cos = [Double]()
    var sin = [Double]()
    //----------------------------------
    var aTimer: Timer!
    var scoreTime = 0
    var bestScoreTime: Int!
    var distance = Int(UIScreen.main.bounds.height)
    //----------------------------------
    let userDataSave = UserDefaultsManager()
    //----------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        placemanBallView()
        contactDetector()
        launchScoreTime()
        topView.layer.zPosition = 1000
        createCircles(numberOfCircles: 15)
        addToCosAndSinArrays()
        createAndPlaceCicles()
        launchAnimation()
    }
    //----------------------------------
    func createCircles(numberOfCircles: Int) {
        while balls_move.count != numberOfCircles {
            let aCircles = UIView()
            let randomX = Double(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 30)))
            let randomY = Double(arc4random_uniform(UInt32(UIScreen.main.bounds.height - 30)))
            aCircles.frame = CGRect(x: randomX, y: randomY, width: 30, height: 30)
            aCircles.backgroundColor = .black
            aCircles.layer.cornerRadius = 15
            viewFond.addSubview(aCircles)
            var overlaps = false
            for circles in balls_move {
                if aCircles.frame.intersects(circles.frame) {
                    overlaps = true
                    aCircles.removeFromSuperview()
                    break
                }
            }
            if !overlaps {
                balls_move.append(aCircles)
            }
        }
    }
    //----------------------------------
    func addToCosAndSinArrays() {
        cos = [Double]()
        sin = [Double]()
        for _ in 0...balls_move.count {
            let ramdomAngle = Double(arc4random_uniform(360))
            cos.append(__cospi(ramdomAngle/180))
            sin.append(__sinpi(ramdomAngle/180))
        }
    }
    //----------------------------------
    func createAndPlaceCicles() {
        for aCircles in balls_move {
            aCircles.layer.cornerRadius = 15
            aCircles.center.x = UIScreen.main.bounds.width / 2
            aCircles.center.y = UIScreen.main.bounds.height - 500
        }
    }
    //----------------------------------
    func launchAnimation() {
        aTimer = Timer.scheduledTimer(timeInterval: 0.005,
                                      target: self,
                                      selector: #selector(animate),
                                      userInfo: nil,
                                      repeats: true)
    }
    //----------------------------------
    @objc func animate() {
        for i in 0..<balls_move.count {
            if balls_move[i].center.x < 9 {
                var degrees = Double(arc4random_uniform(90))
                if degrees < 45 {
                    degrees = degrees * -1
                }
                cos[i] = __cospi(degrees/180)
                sin[i] = __sinpi(degrees/180)
            }
            if balls_move[i].center.x > (UIScreen.main.bounds.width - 9) {
                var degrees = Double(arc4random_uniform(225 - 135 + 1) + 135)
                degrees = degrees * -1
                cos[i] = __cospi(degrees/180)
                sin[i] = __sinpi(degrees/180)
            }
            if balls_move[i].center.y < 9 {
                let degrees = Double(arc4random_uniform(135 - 45 + 1) + 45)
                cos[i] = __cospi(degrees/180)
                sin[i] = __sinpi(degrees/180)
            }
            if balls_move[i].center.y > (UIScreen.main.bounds.height - 9) {
                var degrees = Double(arc4random_uniform(135 - 45 + 1) + 45)
                degrees = degrees * -1
                cos[i] = __cospi(degrees/180)
                sin[i] = __sinpi(degrees/180)
            }
            balls_move[i].center.x += CGFloat(cos[i])
            balls_move[i].center.y += CGFloat(sin[i])
        }
        
    }
    func launchScoreTime() {
        aTimer = Timer.scheduledTimer(timeInterval: 1,
                                      target: self,
                                      selector: #selector(scoreTimeCount),
                                      userInfo: nil,
                                      repeats: true)
    }
    @objc func scoreTimeCount() {
        scoreTime = scoreTime + 1
        scoreTimeLabel.text = "Temps: \(scoreTime)s"
    }
    //=====
    func placemanBallView() {
        manBallView.center.x = UIScreen.main.bounds.width / 2
        manBallView.center.y = UIScreen.main.bounds.height * 0.9
    }
    //=====
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let touch: UITouch = touches.first!
        if touch.view == manBallView {
            manBallView.center.x = touch.location(in: self.view).x
            manBallView.center.y = touch.location(in: self.view).y
        }
    }
    
    func contactDetector() {
        for collider in balls_move {
            var aCircles = UIView()
            aCircles = collider
            if aCircles.frame.intersects(manBallView.frame) {
                print("Ai!!!")
            }
        }
    }
    @IBAction func StopTest(_ sender: UIButton) {

        if aTimer == nil {
            manBallImage.image = #imageLiteral(resourceName: "image_ball.png")
            placemanBallView()
            contactDetector()
            launchScoreTime()
            topView.layer.zPosition = 1000
            createCircles(numberOfCircles: 15)
            addToCosAndSinArrays()
            createAndPlaceCicles()
            launchAnimation()
        } else {
            manBallImage.image = #imageLiteral(resourceName: "image_ball_mort.png")
            aTimer.invalidate()
            aTimer = nil
        }
    }
    
}
