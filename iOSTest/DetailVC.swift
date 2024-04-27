//
//  DetailVC.swift
//  iOS Test
//
//  Created by Darshan Sonigara on 27/4/2024.
//

import UIKit

class DetailVC: UIViewController {
    
    var selectedPost: Post?
    var callbackMethod: ((String) -> Void)?
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblBody: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = "Title: \(selectedPost?.title ?? "")"
        self.lblBody.text = "Body: \(selectedPost?.body ?? "")"
        
        if let selectedPost = selectedPost {
            DispatchQueue.global(qos: .background).async {
                let result = self.perform(for: selectedPost)
                DispatchQueue.main.async {
                    self.callbackMethod?(result)
                }
            }
        }
    }
    func perform(for post: Post) -> String {
        Thread.sleep(forTimeInterval: 1.0)
        return "Result of Heavy computation for post \(post.id)"
    }
}
