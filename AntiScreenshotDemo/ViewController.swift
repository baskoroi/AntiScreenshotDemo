//
//  ViewController.swift
//  AntiScreenshotDemo
//
//  Created by Baskoro Indrayana on 02/10/21.
//

import UIKit
import Photos

class ViewController: UIViewController {

    private let secondsToAlert: Double = 0.75
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onScreenshotTriggered),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
    }
    
    @objc
    private func onScreenshotTriggered() {
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToAlert,
                                      execute: deleteRecentScreenshot)
    }
    
    private func deleteRecentScreenshot() {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(
            format: "(mediaSubtypes & %d) != 0",
            PHAssetMediaSubtype.photoScreenshot.rawValue
        )
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        fetchOptions.fetchLimit = 1
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let asset = fetchResult.firstObject {
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.deleteAssets([asset as Any] as NSArray)
            }
        }
    }
}
