//
//  FeedViewController.swift
//  InstaClone
//
//  Created by ACK Catalina on 12.06.2021.
//

import UIKit
import Firebase

struct Post {
    var documentId : String
    var postedBy : String
    var comment : String
    var likes : Int
    var postDate : String
    var imageUrl : String
}

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFireStore()
        
    }
    
    func getDataFromFireStore() {
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts")
            .order(by: "postDate", descending: true)
            .addSnapshotListener { (querySnapshot, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }
            else {
                if querySnapshot != nil && querySnapshot?.isEmpty != true {
                    self.posts.removeAll()
                    
                    for document in querySnapshot!.documents {
                        let documentId = document.documentID
                        if let postedBy = document.get("postedBy") as? String,
                           let imageUrl = document.get("imageUrl") as? String,
                           let likes = document.get("likes") as? Int {
                            let postDate = (document.get("postDate") as? String) ?? ""
                            let post = Post(documentId: documentId, postedBy: postedBy, comment: document.get("postDescription") as? String ?? "", likes: likes, postDate: postDate, imageUrl: imageUrl)
                            self.posts.append(post)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.documentIdLabel.text = posts[indexPath.row].documentId
        cell.emailTextField.text = posts[indexPath.row].postedBy
        cell.likeCountTextField.text = String(posts[indexPath.row].likes)
        //cell.likeCountTextField.text = "Likes : \(posts[indexPath.row].likes)"
        //cell.likeLabel.text = String(posts[indexPath.row].likes)
        cell.commentTextField.text = posts[indexPath.row].comment
        cell.postImageview.sd_setImage(with: URL(string: posts[indexPath.row].imageUrl))
        
        return cell
    }
    
    
}
