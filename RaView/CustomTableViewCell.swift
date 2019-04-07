//
//  CustomCellTableViewCell.swift
//  RaView
//
//  Created by 南山駿人 on 2019/04/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import HeartButton
import SnapKit

class CustomTableViewCell: UITableViewCell {
    
    var caption = UILabel()
//    @IBOutlet weak var caption: UITextView!
    var myImageView = UIImageView()
//    @IBOutlet weak var myImageView: UIImageView!
    var likes = Int()
    var heartButton = HeartButton()
//    @IBOutlet weak var heartButton: HeartButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(post: Post){
        
        print("func setCell")
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        self.contentView.autoresizingMask = .flexibleHeight

        contentView.addSubview(myImageView)
        
        myImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(374)
        }
        
        let placeholderImage = UIImage(named: "placeholder_image")
        print(placeholderImage!)
        let imageReference = storageRef.child(post.imageURL)
        print(imageReference)
        myImageView.sd_setImage(with: imageReference, placeholderImage: placeholderImage)
        myImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(heartButton)
        heartButton.snp.makeConstraints { make in
            make.top.equalTo(myImageView.snp.bottom).offset(10)
            make.trailing.equalTo(contentView).inset(10)
            make.width.height.equalTo(30)
        }
        
        self.caption = post.caption
        print(self.caption.intrinsicContentSize)
        contentView.addSubview(caption)
        caption.snp.makeConstraints { make in
            make.top.equalTo(heartButton.snp.bottom).offset(10)
            make.leading.equalTo(contentView).offset(20)
            make.trailing.equalTo(contentView).inset(20)
            make.height.greaterThanOrEqualTo(24)
            make.bottom.greaterThanOrEqualTo(contentView.snp.bottom).priority(450)
        }
        self.caption.numberOfLines = 0
        self.caption.sizeToFit()
        self.caption.lineBreakMode = .byWordWrapping
        print(caption)
//        self.caption.isScrollEnabled = false    //Using UITextView
//        self.caption.isEditable = false
//        self.caption.isSelectable = false
//        print(self.caption.intrinsicContentSize)
//        print(caption.frame.size.height)
//        contentView.frame.size.height = contentView.frame.size.height + caption.contentSize.height
        
//        print(contentView.frame.size.height)
        
        self.likes = post.likes
        self.heartButton.stateChanged = { sender, isOn in
            if isOn {
                // selected
                self.likes += 1
                print("The number of likes is \(String(describing: self.likes))")
            } else {
                // unselected
                self.likes -= 1
                print("Like is canceled")
            }
        }
        
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        contentView.bounds.size = targetSize
        contentView.layoutIfNeeded()
        return super.systemLayoutSizeFitting(targetSize,
                                             withHorizontalFittingPriority: horizontalFittingPriority,
                                             verticalFittingPriority: verticalFittingPriority)
        
    }
    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder: ) has not been implemented")
//    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//    }
////
//    override func layoutSubviews() {
//        super.layoutSubviews()
//////
//////        imageBaseView.snp.makeConstraints { make in
//////            make.top.equalTo(contentView.snp.top).offset(20)
//////            make.width.equalTo(contentView)
//////            make.height.equalTo(350)
//////        }
//////
//////        myImageView.snp.makeConstraints{ make in
//////            make.edges.equalTo(imageBaseView)
//////        }
//////
//////        heartButton.snp.makeConstraints { make in
//////            make.top.equalTo(imageBaseView.snp.bottom).offset(20)
//////            make.right.equalTo(imageBaseView.snp.right).offset(-20)
//////            make.width.height.equalTo(30)
//////        }
//////
//////        caption.snp.makeConstraints { make in
//////            make.top.equalTo(heartButton.snp.bottom).offset(10)
//////            make.left.equalTo(imageBaseView).offset(20)
//////            make.right.equalTo(imageBaseView).inset(20)
//////            make.height.greaterThanOrEqualTo(250)
//////            make.bottom.equalTo(imageBaseView.snp.bottom).offset(-10)
//////        }
//    }
//
//
}
