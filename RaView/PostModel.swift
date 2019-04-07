//
//  PostModel.swift
//  RaView
//
//  Created by 南山駿人 on 2019/04/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import Foundation
import UIKit

class Post : NSObject {
    var caption : UILabel
    var imageURL : String
    var likes : Int
    
    init(caption: UILabel, imageURL: String, likes: Int) {
        self.caption = caption
        self.imageURL = imageURL
        self.likes = likes
    }
}
