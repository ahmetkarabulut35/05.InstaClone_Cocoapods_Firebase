//
//  FeedCell.swift
//  InstaClone
//
//  Created by ACK Catalina on 13.06.2021.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var postImageview: UIImageView!
    @IBOutlet weak var commentTextField: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountTextField: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButton_Clikcked(_ sender: Any) {
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeCountTextField.text!) {
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
        }
        
    }
}
