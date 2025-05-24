//
//  ViewController.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import UIKit
import SkeletonView

class ViewController: UIViewController {

    @IBOutlet weak var vwSkelton: UIView!
    @IBOutlet weak var tblPostView: UITableView!
    
    var arrPost = [PostModel]()
    
    //Pagination
    var isLoading: Bool = false
    var page: Int = 1
    var isNextPageAvl = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
}

//MARK: - All Methods
extension ViewController {
    func setupUI() {
        self.tblPostView.register(UINib(nibName: TableViewCell.PostCell, bundle: nil), forCellReuseIdentifier: TableViewCell.PostCell)
        self.tblPostView.delegate = self
        self.tblPostView.dataSource = self
        
        self.vwSkelton.isHidden = false
        self.vwSkelton.showAnimatedSkeleton(usingColor: .darkGray)
        
        self.getPostListAPI()
    }
}

//MARK: - Tableview Delegate Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.PostCell, for: indexPath) as! PostCell
        cell.configureCell(with: self.arrPost[indexPath.row])
        
        cell.postLikeClosure = { [weak self] (status, count) in
            guard let self = self else { return }
            
            self.arrPost[indexPath.row].TotalLike = count
            self.arrPost[indexPath.row].selfLike = status
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == arrPost.count - 1 && isNextPageAvl {
            if !isLoading {
                page += 1
                self.getPostListAPI()
                let loader = UIActivityIndicatorView()
                loader.startAnimating()
                loader.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tblPostView.tableFooterView = loader
            }
        } else {
            self.tblPostView.tableFooterView = nil
        }
    }
}

//MARK: - API Methods
extension ViewController {
    
    func getPostListAPI() {
        guard !isLoading else { return }
        isLoading = true
        
        APIManager.shared.request(urlString: APIConstatns.GET_POST + "?page=\(page)", method: .post, headers: headers, responseType: PostResponse.self) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            DispatchQueue.main.async {
                self.vwSkelton.stopSkeletonAnimation()
                self.vwSkelton.isHidden = true
            }
            
            switch result {
            case .success(let response):
                isNextPageAvl = !response.data.compactMap { $0.post }.isEmpty
                
                let filteredPosts = response.data.compactMap { $0.post }.compactMap { post -> PostModel? in
                    guard let media = post.media else { return nil }
                    let imageMedia = media.filter { $0.type == "Image" }
                    
                    if !imageMedia.isEmpty {
                        var updatedPost = post
                        updatedPost.media = imageMedia
                        return updatedPost
                    } else {
                        return nil
                    }
                }
                
                self.arrPost.append(contentsOf: filteredPosts)
                DispatchQueue.main.async {
                    self.tblPostView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
