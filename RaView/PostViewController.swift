//
//  SubThirdViewController.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/24.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase
import UITextView_Placeholder

extension String
{
    func hashtags() -> [String]
    {
        if let regex = try? NSRegularExpression(pattern: "#[a-z0-9\\p{Han}\\p{Hiragana}\\p{Katakana}ー]+", options: .caseInsensitive)
        {
            let string = self as NSString
            
            return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
                string.substring(with: $0.range).replacingOccurrences(of: "#", with: "").lowercased()
            }
        }
        
        return []
    }
}

class SubThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    // base image
    let baseView = UIImageView()
    // used Editing caption
    var textView = UITextView()
    // main image
    var selectImage = UIImageView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewX = self.view.frame.width
        
        let label_caption = UILabel()
        label_caption.text = "Caption"
        label_caption.frame = CGRect(x: 20, y: 100, width: 80, height: 30)
        self.view.addSubview(label_caption)
        
        textView.frame = CGRect(x: 10, y: 140, width: viewX - 20, height: 300)
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.isEditable = true
        textView.placeholder = "キャプションを書く。ハッシュタグも入れてくれると嬉しいです。"
        textView.placeholderColor = UIColor.lightGray
        
        self.view.addSubview(textView)
        
        let imageButton_image = UIImageView()
        imageButton_image.frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        imageButton_image.image = UIImage.fontAwesomeIcon(name: .paperPlane,
                                                          style: .regular,
                                                          textColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
                                                          size: CGSize(width: 30, height: 30))
        self.view.addSubview(imageButton_image)
        
        let imageButton_button = UIButton(frame:CGRect(x: imageButton_image.frame.origin.x,
                                                       y: imageButton_image.frame.origin.y,
                                                       width: imageButton_image.frame.width,
                                                       height: imageButton_image.frame.height))
        imageButton_button.setTitle(" ", for: .normal)
        imageButton_button.addTarget(self, action: #selector(postDB), for: .touchUpInside)
        self.view.addSubview(imageButton_button)
        
        let label_image = UILabel()
        label_image.text = "Select Image"
        label_image.frame = CGRect(x: 20, y: 460, width: 150, height: 30)
        self.view.addSubview(label_image)
        // firstView は height 400 - 500 くらいがベストやと思う
        baseView.frame = CGRect(x: 10, y: 500, width: viewX - 20, height: 300)
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let base_frame = baseView.frame
        
        selectImage.frame = CGRect(x: 0, y: 0, width: base_frame.width, height: base_frame.height)
        
        self.view.addSubview(baseView)
        self.baseView.addSubview(selectImage)
        
        print("viewDidLoad")
        
        selectImageFromPhotoLibrary()
        
    }
    
    // 入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }

    // Database
    @objc func postDB(){
        
        let db = Firestore.firestore()
        // これをボタンによって発火する関数としたい.
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        
        ref = db.collection("users").addDocument(data: [
            "user": "sample",
            "submissions": [
                "url": "https://sample.com/sample.mov",
                "caption": textView.text,
                "hashtags": textView.text.hashtags(),
                "likes": 0,
            ]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        textView.text = "posting complete"
    }
    
    // image
    @objc func selectImageFromPhotoLibrary() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image"]
        
        print("selectImageFromPhotoLobrary")
        
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("imagePickerController")
        
        let img = info[.originalImage] as! UIImage
        print(img as Any)
        
        selectImage.image = img
        selectImage.contentMode = .scaleAspectFit
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("DidCancel")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

