//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Артем Стратиенко on 19/11/2019.
//  Copyright © 2019 Артем Стратиенко. All rights reserved.
//

import Foundation
import UIKit

class BottomSheetViewController : UIViewController {
    // Объявляем делегат для использования
    var delegate:ButtonDelegate?
    var startDraw = String()
    @IBOutlet weak var chekcButton: UIButton!
    @IBAction func onButtonTap(sender: UIButton) {
        // Вызываем делегат в тот момент, когда кнопка нажата
        delegate?.onButtonTap(sender: sender)
    }
    @IBOutlet var viewSheet: UIView!
    //@IBOutlet var velocityLabel : UILabel!
        let fullView: CGFloat = UIScreen.main.bounds.width/10
        var partialView: CGFloat {
            return UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4)*2
        }
        var partialDoubleView: CGFloat {
            return UIScreen.main.bounds.width - (UIScreen.main.bounds.width/4)
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
        view.addGestureRecognizer(gesture)
        startDraw = "Start"
        //print("init : \(self.nibName)")
        // Do any additional setup after loading the view.
    }
 // Action
    @IBAction func setPosition(_ sender: Any) {
        // @IBAction func changeShema(_ sender: Any)
       NotificationCenter.default.post(name: NSNotification.Name("SetLocation"), object: nil)
    }
    @IBAction func drawShape(_ sender: Any) {
        
        if startDraw == "Start" {
            NotificationCenter.default.post(name: NSNotification.Name("DrawShape"), object: "Start" as String)
            startDraw = "End"
        } else {
            NotificationCenter.default.post(name: NSNotification.Name("DrawShape"), object: "End" as String)
            startDraw = "Start"
        }
    }
    @IBAction func drawCircle(_ sender : Any) {
        if startDraw == "Start" {
                NotificationCenter.default.post(name: NSNotification.Name("DrawCircle"), object: "Start" as String)
                startDraw = "End"
            } else {
                NotificationCenter.default.post(name: NSNotification.Name("DrawCircle"), object: "End" as String)
                startDraw = "Start"
        }
    }
    @IBAction func showBottom(_ sender: Any) {
        // @IBAction func changeShema(_ sender: Any)
       self.view.frame = CGRect(x: self.partialView + 50 + 100, y: 100, width: self.view.frame.width, height: self.view.frame.height)
    }
    //
    // sent Notification AR
    
    @IBAction func ARSession(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("SetLocation"), object: nil)
    }
    //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   //     prepareBackgroundView()
      //   print("init : \(self.nibName)")
        // add bs
               UIView.animate(withDuration: 0.3, animations: { [weak self] in
                                let frame = self?.view.frame
                                let xComponent = self?.partialView
                          self?.view.frame = CGRect(x: xComponent! + frame!.width*1.8, y: 50, width: frame!.width, height: 450/*603.0*/)
                                })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
      //   print("init : \(self.nibName)")
          }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
    
    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
           let translation = recognizer.translation(in: self.view)
               let velocity = recognizer.velocity(in: self.view)
              // self.velocityLabel.text = "velocity : \(velocity)"
               let x = self.view.frame.minX
               // print(1)
               print("1")
               if (x + translation.x >= partialView) && (x + translation.x <= fullView) {
                self.view.frame = CGRect(x: x + translation.x, y: 0, width: view.frame.width, height: view.frame.height)
                   recognizer.setTranslation(CGPoint.zero, in: self.view)
               }
               print("2")
               if recognizer.state == .ended {
                   var duration =  velocity.x < 0 ? Double((x - fullView) / -velocity.x) : Double((partialView - x) / velocity.x )
                   
                   duration = duration > 1.3 ? 1 : duration
                   
                   UIView.animate(withDuration: duration, delay: 0.3, options: [.allowUserInteraction], animations: {
                    print("3")

                    if  velocity.x >= 0 && velocity.x > self.partialView {
                        self.view.frame = CGRect(x: self.partialView + 50 + 100, y: 50, width: self.view.frame.width, height: self.view.frame.height)
                    } else if velocity.x >= 0 && velocity.x > self.fullView + 200 {
                         self.view.frame = CGRect(x: self.partialDoubleView, y: 50, width: self.view.frame.width, height: self.view.frame.height)
                       } else {
                           self.view.frame = CGRect(x: self.fullView + 200, y: 50, width: self.view.frame.width, height: self.view.frame.height)
                       }
                       }, completion: nil/*{ [weak self] _ in
                           if ( velocity.y < 0 ) {
                               //self?.tableView.isScrollEnabled = true
                           }
                   }*/)
               }
     }
     func prepareBackgroundView(){
           // let colorSheet = #colorLiteral(red: 0.1882352941, green: 0.8836419092, blue: 0.8310667011, alpha: 0.8)
       // viewSheet.backgroundColor.se// = colorSheet.cgColor
            view.backgroundColor = .clear
            let blurEffect = UIBlurEffect.init(style: .dark)
            //let vibrancyEffect = UIVibrancyEffect.init()
            let bluredView =   UIVisualEffectView.init(effect: blurEffect)
            //bluredView.contentView.addSubview(visualEffect)
            //bluredView.translatesAutoresizingMaskIntoConstraints = false

           // visualEffect.frame = viewSheet.frame //UIScreen.main.bounds
           // bluredView.frame = viewSheet.frame //UIScreen.main.bounds
           // visualEffect.bounds = viewSheet.bounds
           // bluredView.bounds = viewSheet.bounds
            view.insertSubview(bluredView, at: 0)
     }
    public func reDraw() {
    UIView.animate(withDuration: 0.3, animations: { [weak self] in
    let frame = self?.view.frame
    let xComponent = self?.partialView
    self?.view.frame = CGRect(x: xComponent! - 100, y: 50, width: frame!.width - 100, height: frame!.height/* + 50*/)
    })
    }
}

extension BottomSheetViewController: UIGestureRecognizerDelegate {
/*
    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
        if (y == fullView && /*tableView.contentOffset.y == 0 &&*/ direction > 0) || (y == partialView) {
            /*tableView.isScrollEnabled = false*/
        } else {
            /*tableView.isScrollEnabled = true*/
        }
        
        return false
    }
    */
}
