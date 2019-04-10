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
    
    // MARK: - set Scroll View
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        drawPosts()
        
        
        self.title = "RaView"
        
    }
    
    private func drawPosts() {
        
        let viewX = view.frame.width
        let viewY = view.frame.height
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        scrollView.frame = CGRect(x: 0, y: 0, width: viewX, height: viewY)
        scrollView.indicatorStyle = .white
        scrollView.center = self.view.center
        // FIXME: - 取得した post の個数に応じて大きさを変える
        scrollView.contentSize = CGSize(width: viewX, height: viewY * 30.0)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(scrollView)
        
        var baseView_y : CGFloat = 50
        var textView_y : CGFloat = 500
        var heartButton_y : CGFloat = 470
        let i : Int = 0 // imageView_tag
        let t : Int = 0 // textView_tag
        let h : Int = 0 // heartButton_tag
        
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
                    self.scrollView.addSubview(baseView)
                    
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
                    
                    self.scrollView.addSubview(attributedText)
                    
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
                    self.scrollView.addSubview(heartButton)
                    
                    baseView_y += viewY
                    textView_y += viewY
                    heartButton_y += viewY
                    
                    
//                    documentSnapshot!.documents.count
                }
            }
        }
    }
    
    
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
    
}
