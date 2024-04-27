//
//  ViewController.swift
//  iOS Test
//
//  Created by Darshan Sonigara on 27/4/2024.
//

import UIKit

struct Post: Codable {
    let id: Int
    let title: String
    let body: String
}

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var posts: [Post] = []
    var currentPage = 1
    let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        tableView.register(UINib(nibName: "MyTableCell", bundle: nil), forCellReuseIdentifier: "MyTableCell")
        getData()
    }
    
    func getData() {
        activityIndicator.startAnimating()
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts?_page=\(currentPage)&_limit=\(pageSize)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let posts = try decoder.decode([Post].self, from: data)
                self.posts.append(contentsOf: posts)
                self.currentPage += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    //MARK: Pagination
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            getData()
        }
    }
    
    //MARK: Tableview Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath) as! MyTableCell
        let post = posts[indexPath.row]
        cell.lblID.text = "\(post.id)"
        cell.lblTitle.text = post.title
        DispatchQueue.global(qos: .background).async {
            let sTime = Date()
            let eTime = Date()
            let timeDiff = eTime.timeIntervalSince(sTime)
            print("Heavy computation: \(timeDiff) seconds")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPost = posts[indexPath.row]
        showDetail(for: selectedPost)
    }
    
    func showDetail(for post: Post) {
        if let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC {
            objDetail.selectedPost = post
            objDetail.callbackMethod = { [weak self] result in
                print("Received from Heavy computation: \(result)")
                let alertController = UIAlertController(title: "Callback", message: result, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            navigationController?.pushViewController(objDetail, animated: true)
        }
    }
}

