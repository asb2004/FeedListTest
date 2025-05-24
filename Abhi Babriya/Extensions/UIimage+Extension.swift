//
//  UIimage+Extension.swift
//  Abhi Babriya
//
//  Created by Abhi Babriya on 24/05/25.
//

import Kingfisher

extension UIImageView {

    func setImage(
        from urlString: String?,
        placeholder: UIImage? = nil,
        isLoader: Bool = false,
        completion: ((Swift.Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {

        self.kf.indicatorType = isLoader ? .activity : .none

        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            completion?(.failure(.requestError(reason: .emptyRequest)))
            return
        }

        let resizingProcessor = DownsamplingImageProcessor(size: self.bounds.size)

        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [.processor(resizingProcessor), .scaleFactor(UIScreen.main.scale)],
            progressBlock: nil
        ) { result in
            self.kf.indicatorType = .none
            completion?(result)
        }
    }
}
