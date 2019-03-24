//
//  ViewController.swift
//  RaView
//
//  maked by 南山駿人 on 2019/02/21.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MyClearButton: UIButton {
    
    var value = UIImageView()
    
}

class  FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewX = self.view.frame.width
        let viewY = self.view.frame.height
        
        //set Scroll View
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: viewX, height: viewY)
        scrollView.indicatorStyle = .white
        scrollView.center = self.view.center
        scrollView.contentSize = CGSize(width: viewX, height: viewY * 3)
        scrollView.isScrollEnabled = true
        scrollView.backgroundColor = #colorLiteral(red: 0, green: 1, blue: 0.8448454738, alpha: 1)
        
        //set UITabBarItem
        
        
        //set imageview
        let kanan = UIImageView()
        kanan.frame = CGRect(x: ((scrollView.contentSize.width-300)/2), y: 200, width: 300, height: 377)
        kanan.image = UIImage(named: "kanan")
        scrollView.addSubview(kanan)
        
        let mari = UIImageView()
        mari.frame = CGRect(x: ((scrollView.contentSize.width-300)/2), y: 700, width: 300, height: 377)
        mari.image = UIImage(named: "mari")
        scrollView.addSubview(mari)
        
        let image = UIImageView()
        image.frame = CGRect(x: ((scrollView.contentSize.width-300)/2), y: 1500, width: 100, height: 120)
        image.image = UIImage.fontAwesomeIcon(name: .github, style: .brands, textColor: .black, size: CGSize(width: 100, height: 120))
        scrollView.addSubview(image)
        
        //set clearbutton
        let clearButton_kanan = ClearButton(imv: kanan)
        scrollView.addSubview(clearButton_kanan)
        
        let clearButton_mari = ClearButton(imv: mari)
        scrollView.addSubview(clearButton_mari)
        
        //add Scroll View
        self.view.addSubview(scrollView)
        
    }

    @objc func ClearButton(imv: UIImageView) -> UIButton {

        let clearButton = MyClearButton(frame: CGRect(x: imv.frame.origin.x, y: imv.frame.origin.y, width: imv.frame.width, height: imv.frame.height))
        clearButton.setTitle("", for: .normal)
        clearButton.value = imv
        clearButton.addTarget(self, action: #selector(rotateCard), for: .touchUpInside)
        return clearButton
    }

    @objc func rotateCard(_ sender: MyClearButton) {
        //二重タップ防止
        self.view.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.5, animations: {
            //first transform
            sender.value.transform = CGAffineTransform(scaleX: 0.01, y: 1.0)
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 0.5, animations: {
                self.changeImage(iv: sender.value)
                //second transform
                sender.value.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion:{ (finished: Bool) in
                //二重タップ防止　解除
                self.view.isUserInteractionEnabled = true
            })
        })
    }

    func changeImage(iv: UIImageView) {
        if iv.image == UIImage(named: "kanan") {
            iv.image = UIImage(named: "mari")
        }else {
            iv.image = UIImage(named: "kanan")
        }
    }
    
}
