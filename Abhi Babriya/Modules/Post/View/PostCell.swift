//
//  PostCell.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postMediaHeight: NSLayoutConstraint!
    @IBOutlet weak var lblCommentCount: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var mediaPageControl: UIPageControl!
    @IBOutlet weak var lblMediaCount: UILabel!
    @IBOutlet weak var colMediaView: UICollectionView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPostDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgUserProfile: UIImageView!
    
    var arrPostMedia: [MediaModel] = []
    var post: PostModel!
    
    //MARK: - Closures
    var postLikeClosure: ((Bool, Int) -> ())?
    
    //MARK: - Cell Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        self.arrPostMedia.removeAll()
        self.postMediaHeight.constant = 0
    }
    
    //MARK: - Button Actions
    @IBAction func btnLikeAction(_ sender: Any) {
        if let isLike = post.selfLike, isLike {
            post.selfLike = false
            post.TotalLike = (post.TotalLike ?? 0) - 1
            btnLike.tintColor = .white
            btnLike.setImage(Images.UNLIKE, for: .normal)
        } else {
            post.selfLike = true
            post.TotalLike = (post.TotalLike ?? 0) + 1
            btnLike.tintColor = .systemRed
            btnLike.setImage(Images.LIKE, for: .normal)
        }
        self.lblLikeCount.text = String(post.TotalLike ?? 0)
        self.lblLikeCount.isHidden = post.TotalLike == 0
        self.postLikeClosure?(post.selfLike ?? false, post.TotalLike ?? 0)
    }
}

//MARK: - All Methods
extension PostCell {
    
    func setupCell() {
        self.colMediaView.register(UINib(nibName: CollectionViewCell.PostMediaCell, bundle: nil), forCellWithReuseIdentifier: CollectionViewCell.PostMediaCell)
        self.colMediaView.delegate = self
        self.colMediaView.dataSource = self
    }
    
    func configureCell(with postModel: PostModel) {
        
        self.post = postModel
        
        self.imgUserProfile.setImage(from: APIConstatns.PROFILE_BASE_URL + (postModel.userId?.profile ?? ""), placeholder: Images.userPlaceholder)
        self.lblUserName.text = postModel.userId?.name
        self.lblPostDate.text = formatDateString(postModel.createAt ?? "")
        self.lblDescription.text = postModel.description
        self.lblDescription.attributedText = applyForegroundColorToHashtags(in: postModel.description ?? "", withColor: .systemMint, font: self.lblDescription.font)
        self.lblDescription.superview?.isHidden = postModel.description?.isEmpty ?? true
        
        if let media = postModel.media {
            self.arrPostMedia = media
        }
        DispatchQueue.main.async {
            self.colMediaView.reloadData()
        }
        
        self.mediaPageControl.numberOfPages = self.arrPostMedia.count
        self.mediaPageControl.isHidden = self.arrPostMedia.count <= 1
        self.lblMediaCount.text = "  \(self.mediaPageControl.currentPage + 1)/\(self.arrPostMedia.count)  "
        self.lblMediaCount.isHidden = self.arrPostMedia.count <= 1
        
        self.adjustMediaHeight(aspectRatio: arrPostMedia.first?.aspectRatio)
        
        self.lblLikeCount.text = String(postModel.TotalLike ?? 0)
        self.lblLikeCount.isHidden = postModel.TotalLike == 0 || postModel.hideLikeCount ?? false
        
        self.lblCommentCount.text = String(postModel.comments ?? 0)
        self.lblCommentCount.isHidden = postModel.comments == 0 || postModel.turnOffComment ?? false
        
        if let isLike = postModel.selfLike, isLike {
            btnLike.tintColor = .systemRed
            btnLike.setImage(Images.LIKE, for: .normal)
        } else {
            btnLike.tintColor = .white
            btnLike.setImage(Images.UNLIKE, for: .normal)
        }
    }
    
    func adjustMediaHeight(aspectRatio: Double?) {
        guard let aspectRatio = aspectRatio, aspectRatio > 0 else {
            self.postMediaHeight.constant = 400
            return
        }
        
        let screenWidth = UIScreen.main.bounds.width
        let mediaWidth = screenWidth
        let mediaHeight = mediaWidth * aspectRatio
        self.postMediaHeight.constant = mediaHeight
    }
}

//MARK: - CollectionView Delegate Methods
extension PostCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPostMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.PostMediaCell, for: indexPath) as! PostMediaCell
        cell.imgPost.setImage(from: APIConstatns.POST_IMAGE_BASE_URL + (self.arrPostMedia[indexPath.row].url ?? ""))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
}

// MARK: - ScrollView Delegate Method
extension PostCell {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        self.mediaPageControl.currentPage = pageIndex
        self.lblMediaCount.text = "  \(self.mediaPageControl.currentPage + 1)/\(self.arrPostMedia.count)  "
    }
}
