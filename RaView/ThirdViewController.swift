//
//  ThirdViewController.swift
//  RaView
//
//  Created by 南山駿人 on 2019/03/01.
//  Copyright © 2019 midbit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class ThirdViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var imageView = UIImageView()
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewX = self.view.frame.width
        let viewY = self.view.frame.height
        
        let imageButton_image = UIImageView()
        imageButton_image.frame = CGRect(x: viewX/2, y: viewY/2, width: 40, height: 40)
        imageButton_image.image = UIImage.fontAwesomeIcon(name: .image,
                                                          style: .regular,
                                                          textColor: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
                                                          size: CGSize(width: 40, height: 40))
//        self.view.addSubview(imageButton_image)
        
        let imageButton_button = UIButton(frame:CGRect(x: imageButton_image.frame.origin.x,
                                                       y: imageButton_image.frame.origin.y,
                                                       width: imageButton_image.frame.width,
                                                       height: imageButton_image.frame.height))
        imageButton_button.setTitle(" ", for: .normal)
        imageButton_button.addTarget(self, action: #selector(selectImageFromPhotoLibrary), for: .touchUpInside)
//        self.view.addSubview(imageButton_button)
        
        imageView.frame = CGRect(x: viewX/2, y: viewY/2, width: viewX/2, height: 300)
        self.view.addSubview(imageView)
        
        selectImageFromPhotoLibrary()
        
    }
    
    func previewImageFromVideo(url:URL) -> UIImage? {
        
        print("previewImage")
        
        let asset = AVAsset(url:url)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    @objc func selectImageFromPhotoLibrary() {
        
        print("selectImage")
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.mediaTypes = ["public.image", "public.movie"]
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("imagePicker")
        
        videoURL = info[.mediaURL] as? URL
        
        print(videoURL as Any)
        
        imageView.image = previewImageFromVideo(url: videoURL!)!
        
        imageView.contentMode = .scaleAspectFit
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        print("DidCancel")
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @objc func videoTapped() {
        
        print("button tapped")
        
        if let videoURL = videoURL{
            
            let player = AVPlayer(url: videoURL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }
        
        
    }
    
}
