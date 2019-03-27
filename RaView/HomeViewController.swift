//
//  ViewController.swift
//  RaView
//
//  maked by 南山駿人 on 2019/02/21.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import FontAwesome_swift
import HeartButton

// MARK: - Custom ClearButton
class MyClearButton: UIButton {
    
    var value = UIImageView()
    
}

class  HomeViewController: UIViewController {
    
    var heartButton = HeartButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "RaView"
        
        let viewX = self.view.frame.width
        let viewY = self.view.frame.height
        
        // MARK: - set Scroll View
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: viewX, height: viewY)
        scrollView.indicatorStyle = .white
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: viewX, height: viewY * 2.0)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        // MARK: - set imageview
        //         Front, Back に変える予定(ないかも)
        let baseView = UIImageView()
        baseView.frame = CGRect(x: 0, y: 50, width: viewX, height: 400)
        scrollView.addSubview(baseView)
        
        let kanan = UIImageView()
        kanan.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
        kanan.image = UIImage(named: "kanan")
        kanan.contentMode = .scaleAspectFit
        baseView.addSubview(kanan)
        
        // MARK: set caption
        let text = UITextView()
        text.text = "aaaaaaaaaaaaa #aaa"
        text.isEditable = false
//        にするとできるっぽい. Firstで使えるね.
        text.dataDetectorTypes = .link
        text.linkTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]
        text.frame = CGRect(x: 50, y: 500, width: viewX, height: 200)
        text.font = UIFont.systemFont(ofSize: 17.0)
        scrollView.addSubview(text)
        
        let baseView2 = UIImageView()
        baseView2.frame = CGRect(x: 0, y: viewY + 50, width: viewX, height: 400)
        scrollView.addSubview(baseView2)
        
        let mari = UIImageView()
        mari.frame = CGRect(x: 0, y: 0, width: baseView2.frame.width, height: baseView2.frame.height)
        mari.image = UIImage(named: "mari")
        mari.contentMode = .scaleAspectFit
        baseView2.addSubview(mari)
        
//        //set clearbutton
//        let clearButton_kanan = ClearButton(imv: kanan)
//        scrollView.addSubview(clearButton_kanan)
//
//        let clearButton_mari = ClearButton(imv: mari)
//        scrollView.addSubview(clearButton_mari)
        
        // set HeartButton
        heartButton.frame = CGRect(x: viewX - 50, y: 470, width: 30, height: 30)
        
        var likes = 0
        
        self.heartButton.stateChanged = { sender, isOn in
            if isOn {
                // selected
                likes += 1
                print("The number of likes is \(likes)")
            } else {
                // unselected
                likes -= 1
                print("Like is canceled")
            }
        }
        scrollView.addSubview(heartButton)
        
        //add Scroll View
        self.view.addSubview(scrollView)
        
    }

    // MARK: - define ClearButton
    //         カードを裏返すボタンを作成する
    @objc func ClearButton(imv: UIImageView) -> UIButton {

        let clearButton = MyClearButton(frame: CGRect(x: imv.frame.origin.x, y: imv.frame.origin.y, width: imv.frame.width, height: imv.frame.height))
        clearButton.setTitle("", for: .normal)
        clearButton.value = imv
        clearButton.addTarget(self, action: #selector(rotateCard), for: .touchUpInside)
        return clearButton
    }

    // MARK: - define rotateCard
    //         ClearButton の主な機能の部分
    @objc func rotateCard(_ sender: MyClearButton) {
        //二重タップ防止
        self.view.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.5, animations: {
            //first transform
            sender.value.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.changeImage(iv: sender.value)
                //second transform
                sender.value.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion:{ (finished: Bool) in
                //二重タップ防止　解除
                self.view.isUserInteractionEnabled = true
            })
        })
    }

    // MARK: - define changeImage
    //         表の画像と裏の画像を入れ替える
    func changeImage(iv: UIImageView) {
        if iv.image == UIImage(named: "kanan") {
            iv.image = UIImage(named: "mari")
        }else {
            iv.image = UIImage(named: "kanan")
        }
    }
    
}
