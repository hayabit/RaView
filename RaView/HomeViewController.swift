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
import SwiftyAttributedString

// MARK: - Custom ClearButton
class MyClearButton: UIButton {
    
    var value = UIImageView()
    
}

extension NSAttributedString {
    
    func replace(pattern: String) -> NSMutableAttributedString {
        let mutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        let range = mutableString.range(of: pattern)
//            mutableAttributedString.replaceCharacters(in: range, with: replacement)
        mutableAttributedString.addAttributes([.foregroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)], range: range)
        return mutableAttributedString
    }
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
        let textView = UITextView()
        textView.text = "aaaaaaaaaaaaa #aaa #bbbb #ccc"
        textView.isEditable = false
        textView.frame = CGRect(x: 50, y: 500, width: viewX, height: 200)
        
        let attributedText = attributeText(textView: textView)
        
        scrollView.addSubview(attributedText)
        
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
    
    // MARK: - define attributeText
    //         ハッシュタグに色付けをする. リンクをつけることも可能
    func attributeText(textView: UITextView) -> UITextView {
        
        let pattern = "#[a-z0-9\\p{Han}\\p{Hiragana}\\p{Katakana}ー]+"
        let attributedString : String = textView.text
        
        var ans : [String] = []
        if attributedString.pregMatch(pattern: pattern, matches: &ans) {
            print("match")
        } else {
            print("not match")
        }
        
        textView.attributedText = attributedString
            .attr
            .font(.systemFont(ofSize: 20))
            .apply()
        
        for data in ans {
            textView.attributedText = textView.attributedText.replace(pattern: data)
        }
        return textView
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
