//
//  SecondViewContrller.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/01.
//  Copyright © 2019 midbit. All rights reserved.

import UIKit
import Firebase
import UITextView_Placeholder
import SnapKit
import FontAwesome_swift

class Post : NSObject {
    
    var caption : String
    var url : String
    var likes : Int
    
    init(caption: String, url: String, likes: Int){
        self.caption = caption
        self.url = url
        self.likes = likes
    }
}

class SearchViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    // used Editing caption
    var textView = UITextView()
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    
    private func initView() {
        
        let searchButton = UIButton()
        
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(80)
            make.leading.equalTo(view).offset(20)
            make.trailing.equalTo(view).inset(20)
            make.height.equalTo(80)
        }
        view.addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.center.equalTo(view)
            make.size.equalTo(50)
        }
        textView.layer.borderWidth = 1
        textView.font = UIFont.systemFont(ofSize: 14.0)
        textView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.isEditable = true
        textView.placeholder = "検索"
        textView.placeholderColor = UIColor.lightGray
        
        searchButton.setImage(UIImage.fontAwesomeIcon(name: .search,
                                                      style: .solid,
                                                      textColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
                                                      size: CGSize(width: 50, height: 50)), for: .normal)
        searchButton.setTitle(" ", for: .normal)
        searchButton.addTarget(self, action: #selector(searchDB), for: .touchUpInside)
    }
    
    // FIXME: - Search
    // OR検索になってしまっている. -> AND検索 もしくは ファジー検索にすることが望ましい.
    private func searchTagID(tags: [String]) {
        
        var tag_documentIDs = [String]()
        
        let db = Firestore.firestore()
        
        for tag in tags {
            db.collection("tags").whereField("tag_name", isEqualTo: tag).getDocuments() { (documentSnapshot, error) in
                if let error = error {
                    print("Error fetching document: \(error)")
                    return
                } else {
                    for document in documentSnapshot!.documents {
                        let tag_documentID = document.documentID
                        print(tag_documentID)
                        tag_documentIDs.append(tag_documentID)
                    }
                    self.searchPostID(tag_documentIDs: tag_documentIDs)
                    tag_documentIDs = []
                }
            }
        }
    }
    
    private func searchPostID(tag_documentIDs: [String]) {
        var post_documentIDs = [String]()
        let db = Firestore.firestore()
        db.collection("posts").getDocuments() { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching document: \(error)")
                return
            } else {
                for document in documentSnapshot!.documents {
                    let post_documentID = document.documentID
                    print(post_documentID)
                    post_documentIDs.append(post_documentID)
                }
                self.searchPosts(tag_documentIDs: tag_documentIDs, post_documentIDs: post_documentIDs)
            }
        }
    }
    
    private func searchPosts(tag_documentIDs: [String], post_documentIDs: [String]) {
        
        let db = Firestore.firestore()
        
        for tag_documentID in tag_documentIDs {
            for post_documentID in post_documentIDs {
                let postRef = db.collection("posts").document(post_documentID)
                postRef.collection("tags").whereField(tag_documentID , isEqualTo: true)
                    .getDocuments(){ (documentSnapshot, error) in
                        if let error = error {
                            print("Error fetching document: \(error)")
                            return
                        } else {
                            for document in documentSnapshot!.documents {
                                let documentData = document.data()
                                print(documentData)
                                postRef.getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        let documentData = document.data()
                                        let documentID = document.documentID
                                        print("matched documentID : \(documentID)")
                                        
                                        guard let caption = documentData?["caption"] else {
                                            return
                                        }
                                        guard let url = documentData?["url"] else {
                                            return
                                        }
                                        guard let likes = documentData?["likes"] else {
                                            return
                                        }
                                        
                                        let post = Post(caption: caption as! String,
                                                        url: url as! String,
                                                        likes: likes as! Int)
                                        
                                        self.posts.append(post)
                                        
                                        print("caption: \(caption)")
                                        print("url: \(url)")
                                        print("likes: \(likes)")
                                        print("post: \(post)")
                                    } else {
                                        print("Document does not exist")
                                    }
                                    print("posts: \(self.posts[0].caption)")
                                }
                            }
                        }
                }
            }
        }
    }
    
    @objc private func searchDB(){
        
        let searchStr = textView.text
        let tags = searchStr!.components(separatedBy: .whitespaces)
        
        searchTagID(tags: tags)
    }
    
    //    入力画面ないしkeyboardの外を押したら、キーボードを閉じる処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (self.textView.isFirstResponder) {
            self.textView.resignFirstResponder()
        }
    }
}
