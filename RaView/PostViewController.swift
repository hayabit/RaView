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
    // MARK: hashtags()
    //       文字列内のハッシュタグを正規表現によって抽出し, 配列に保存する.
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

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    
    // base image
    let baseView = UIImageView()
    // used Editing caption
    var textView = UITextView()
    // main image
    var selectImage = UIImageView()
    // select image URL
    var selectImageURL = NSURL()
    
    var timeStamp = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewX = self.view.frame.width
        
        // MARK: - set label
        let label_caption = UILabel()
        label_caption.text = "Caption"
        label_caption.frame = CGRect(x: 20, y: 100, width: 80, height: 30)
        self.view.addSubview(label_caption)
        
        // MARK: - set textView
        textView.frame = CGRect(x: 10, y: 140, width: viewX - 20, height: 300)
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.isEditable = true
        textView.placeholder = "キャプションを書く。ハッシュタグも入れてくれると嬉しいです。"
        textView.placeholderColor = UIColor.lightGray
        
        self.view.addSubview(textView)
        
        // MARK: - set postButton
        let postButton_image = UIImageView()
        postButton_image.frame = CGRect(x: 100, y: 100, width: 30, height: 30)
        postButton_image.image = UIImage.fontAwesomeIcon(name: .paperPlane,
                                                          style: .regular,
                                                          textColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
                                                          size: CGSize(width: 30, height: 30))
        self.view.addSubview(postButton_image)
        
        let postButton_button = UIButton(frame:CGRect(x: postButton_image.frame.origin.x,
                                                       y: postButton_image.frame.origin.y,
                                                       width: postButton_image.frame.width,
                                                       height: postButton_image.frame.height))
        postButton_button.setTitle(" ", for: .normal)
        postButton_button.addTarget(self, action: #selector(storeDataInDB), for: .touchUpInside)
        self.view.addSubview(postButton_button)
        
        // MARK: - set label
        let label_image = UILabel()
        label_image.text = "Select Image"
        label_image.frame = CGRect(x: 20, y: 460, width: 150, height: 30)
        self.view.addSubview(label_image)
        
        // MARK: - set baseView
        // firstView は height 400 - 500 くらいがベストやと思う
        baseView.frame = CGRect(x: 10, y: 500, width: viewX - 20, height: 300)
        baseView.layer.borderWidth = 1
        baseView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        let base_frame = baseView.frame
        
        // MARK: - set selectImage
        selectImage.frame = CGRect(x: 0, y: 0, width: base_frame.width, height: base_frame.height)
        selectImage.image = UIImage(named: "placeholder_image")
        
        self.view.addSubview(baseView)
        self.baseView.addSubview(selectImage)
        
        print("viewDidLoad")
        
        selectImageFromPhotoLibrary()
        
    }
    
    // MARK: - 入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
    
    // MARK: - Storage
    func saveSelectedImageToStorage(){
        // ストレージに保存する対象の画像を定義
        var targetSelectImageURL = NSURL()
        targetSelectImageURL = selectImageURL
        
        timeStamp = createTimestamp()
        
        uploadImage(targetSelectImageURL: targetSelectImageURL)

    }
    
    // MARK: - create timestamp
    func createTimestamp() -> String{
        let timeInterval = NSDate().timeIntervalSince1970
        let myTimeInterval = TimeInterval(timeInterval)
        let time = NSDate(timeIntervalSince1970: TimeInterval(myTimeInterval))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let timestamp = formatter.string(from: time as Date)
        return timestamp
    }
    
    // MARK: - image upload to storage
    func uploadImage(targetSelectImageURL: NSURL){
        
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        let localFile = URL(string: "\(targetSelectImageURL)")!
        
        let imageRef = storageRef.child("images/\(timeStamp).jpg")
        
        // Create the file metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        // Upload file and metadata to the object 'images/mountains.jpg'
        let uploadTask = imageRef.putFile(from: localFile, metadata: metadata)
        
        // Listen for state changes, errors, and completion of the upload.
        uploadTask.observe(.resume) { snapshot in
            // Upload resumed, also fires when the upload starts
        }
        
        uploadTask.observe(.pause) { snapshot in
            // Upload paused
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print("\(percentComplete)")
        }
        
        uploadTask.observe(.success) { snapshot in
            // Upload completed successfully
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }

    //  MARK: - Database
    @objc func storeDataInDB(){
        
        let db = Firestore.firestore()
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        
        saveSelectedImageToStorage()
        
        ref = db.collection("user").addDocument(data: [
            "userId": "sample",
            "submission": [
                "submisstionId": "sample_submission",
                "url": "images/\(timeStamp).jpg",
                "caption": textView.text,
                "hashtags": textView.text.hashtags(),
                "likes": 0,
            ],
            "liked_submissionId": [
                "submissionId": ""
            ],
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
    
    // MARK: - Image
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
        
        let url = info[.imageURL] as! NSURL
        
        selectImage.image = img
        selectImage.contentMode = .scaleAspectFit
        
        selectImageURL = url
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("DidCancel")
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

