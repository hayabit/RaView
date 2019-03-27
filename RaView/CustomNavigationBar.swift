//
//  CustomNavigationBar.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    // MARK: - Navigation

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup(){
        self.barTintColor = #colorLiteral(red: 0.9171380401, green: 0.9172917604, blue: 0.9171177745, alpha: 1)    //バーの色
        self.tintColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)    //バー上のアイテムの色
        //タイトルテキストの色
        self.titleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)]
    }
    
}
