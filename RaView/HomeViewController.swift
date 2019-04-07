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
import SnapKit

// MARK: - Custom ClearButton
class MyClearButton: UIButton {
    
    var value = UIImageView()
    
}

extension NSAttributedString {
    
    func replace(pattern: String) -> NSMutableAttributedString {
        let mutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        let mutableString = mutableAttributedString.mutableString
        let range = mutableString.range(of: pattern)
        mutableAttributedString.addAttributes([.foregroundColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)], range: range)
        return mutableAttributedString
    }
}

class  HomeViewController: UIViewController, UINavigationControllerDelegate {
    
//    var heartButton = HeartButton()
    var caption : String!
    var imageURL : String!
    var likes : Int!
    var posts = [Post]()
//    @IBOutlet var tableView: UITableView!
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "RaView"
        fetchPosts()
    }
    
    private func fetchPosts() {
        
        let db = Firestore.firestore()
        
        // MARK: - set imageview
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
                    
                    let captionLabel = UILabel()
                    captionLabel.text = caption as? String
                    
                    let attributedText = self.attributeText(label: captionLabel)
                    
                    let post = Post(caption: attributedText, imageURL: url as! String, likes: likes as! Int)
                    self.posts.append(post)
                }
                self.initTableView()
            }
        }
    }
    
    private func initTableView() {
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CustomTableViewCell.self))
        tableView.estimatedRowHeight = 24
        tableView.autoresizingMask = .flexibleHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    // MARK: - define attributeText
    //         ハッシュタグに色付けをする. リンクをつけることも可能
    @objc func attributeText(label: UILabel) -> UILabel {
        
        let pattern = "#[a-zA-Z0-9\\p{Han}\\p{Hiragana}\\p{Katakana}ー]+"
        let attributedString : String = label.text!
        
        var ans : [String] = []
        if attributedString.pregMatch(pattern: pattern, matches: &ans) {
            print("match")
        } else {
            print("not match")
        }
        
        label.attributedText = attributedString
            .attr
            .font(.systemFont(ofSize: 20))
            .apply()
        
        for data in ans {
            label.attributedText = label.attributedText!.replace(pattern: data)
        }
        return label
    }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tableView cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CustomTableViewCell.self), for: indexPath) as! CustomTableViewCell
        
        print(cell)
        
        print(cell.bounds)
        print(cell.contentView.bounds)
        cell.setCell(post: posts[indexPath.row])
        print(cell.bounds)
        print(cell.contentView.bounds)
        cell.selectionStyle = .none
        
        //        cell.setNeedsLayout()
        //        cell.layoutIfNeeded()
        //
        //        cell.isOpaque = false
        //        cell.contentView.isOpaque = false
        //
        //        cell.clearsContextBeforeDrawing = false
        //        cell.contentView.clearsContextBeforeDrawing = false
        //
        //        cell.clipsToBounds = false
        //                cell.contentView.clipsToBounds = false
        tableView.beginUpdates()
        tableView.endUpdates()
        //        cell.contentView.addSubview(<#T##view: UIView##UIView#>)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("section: \(indexPath.section) index: \(indexPath.row)")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        return
    }
}
