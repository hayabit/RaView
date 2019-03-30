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
import Firebase
import FirebaseUI

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

class  HomeViewController: UIViewController, UINavigationControllerDelegate {
    
//    var heartButton = HeartButton()
    var caption_arr : [String] = []
    var imageURL_arr : [String] = []
    var likes_arr : [Int] = []
    
//    let group  = DispatchGroup()
//    let queue = DispatchQueue(label: "com.GCD.groupQueue")

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        self.title = "RaView"
        
        let viewX = self.view.frame.width
        let viewY = self.view.frame.height
        
        // MARK: - set Scroll View
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: viewX, height: viewY)
        scrollView.indicatorStyle = .white
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: viewX, height: viewY * 30.0)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        var baseView_y : CGFloat = 50
        var textView_y : CGFloat = 500
        var heartButton_y : CGFloat = 470
        let i : Int = 0 // imageView_tag
        let t : Int = 0 // textView_tag
        let h : Int = 0 // heartButton_tag
        
        
        // MARK: - set imageview
        //         Front, Back に変える予定(ないかも)
//        let baseView = UIImageView()
        //        baseView.frame = CGRect(x: 0, y: 50, width: viewX, height: 400)
        //        scrollView.addSubview(baseView)
        //
        //        let firstImage = UIImageView()
        //        firstImage.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
        //        let placeholderImage = UIImage(named: "placeholder_image")
        
        // Data get at Database
        db.collection("posts").getDocuments() { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            } else {
                for document in documentSnapshot!.documents {
                    let documentData = document.data()
                    print(document.data())
                    guard let caption = documentData["caption"] else {
                        return
                    }
                    guard let url = documentData["url"] else {
                        return
                    }
                    guard let likes = documentData["likes"] else {
                        return
                    }
                    let baseView = UIImageView()
                    baseView.frame = CGRect(x: 0, y: baseView_y, width: viewX, height: 400)
                    scrollView.addSubview(baseView)
                    
                    let Image = UIImageView()
                    Image.frame = CGRect(x: 0, y: 0, width: baseView.frame.width, height: baseView.frame.height)
                    let placeholderImage = UIImage(named: "placeholder_image")
                    let imageReference = storageRef.child(url as! String)
                    Image.sd_setImage(with: imageReference, placeholderImage: placeholderImage)
                    Image.contentMode = .scaleAspectFit
                    Image.tag = i + 1
                    baseView.addSubview(Image)
                    
                    let textView = UITextView()
                    textView.text = caption as? String
                    textView.isEditable = false
                    textView.frame = CGRect(x: 10, y: textView_y, width: viewX, height: 200)
                    textView.tag = t + 1
                    
                    let attributedText = self.attributeText(textView: textView)
                    
                    scrollView.addSubview(attributedText)
                    
                    var Likes = likes as! Int
                    
                    let heartButton = HeartButton()
                    
                    heartButton.frame = CGRect(x: viewX - 50, y: heartButton_y, width: 30, height: 30)
                    
                    heartButton.stateChanged = { sender, isOn in
                        if isOn {
                            // selected
                            Likes += 1
                            print("The number of likes is \(likes)")
                        } else {
                            // unselected
                            Likes -= 1
                            print("Like is canceled")
                        }
                    }
                    heartButton.tag = h + 1
                    scrollView.addSubview(heartButton)
                    
                    baseView_y += viewY
                    textView_y += viewY
                    heartButton_y += viewY
                }
            }
        }
        
        //add Scroll View
        self.view.addSubview(scrollView)
        
    }
    
    // MARK: - get document
    func getDocumentFromFirebase() -> [String : Any] {
        
        let db = Firestore.firestore()
        var data : [String : Any] = [:]
        var count = 0
//        var caption : String = ""
//        let postsRef = db.collection("posts")
//        let query = postsRef.order(by: "likes", descending: true).limit(to: 3)
        
        
        
        db.collection("posts").getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        data = document.data()
                        self.caption_arr += [data["caption"] as! String]
                        self.imageURL_arr += [data["url"] as! String]
                        print("\(self.imageURL_arr[count])")
                        self.likes_arr += [data["likes"] as! Int]
                        //                        print("\(caption)")
                        count += 1
                    }
                }
        }
        return data
    }
    
    // MARK: - define attributeText
    //         ハッシュタグに色付けをする. リンクをつけることも可能
    @objc func attributeText(textView: UITextView) -> UITextView {
        
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
        func ClearButton(imv: UIImageView) -> UIButton {

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
        if iv.image == UIImage(named: "placeholder_image") {
            iv.image = UIImage(named: "placeholder_image")
        }else {
            iv.image = UIImage(named: "placeholder_image")
        }
    }
    
}
