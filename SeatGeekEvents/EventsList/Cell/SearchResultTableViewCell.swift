//
//  SearchResultTableViewCell.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 24.03.2020.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import ReactiveKit

final class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var eventImageView: UIImageView!
    @IBOutlet private weak var eventTitleLabel: UILabel!
    @IBOutlet private weak var eventLocationLabel: UILabel!
    @IBOutlet private weak var eventTimeLabel: UILabel!
    @IBOutlet private weak var favouriteImageView: UIImageView!
    
    static let rowHeight: CGFloat = 90.0
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    private let disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        eventImageView.image = nil
        favouriteImageView.isHidden = true
        [eventTitleLabel, eventLocationLabel, eventTimeLabel].forEach({
            $0?.text = nil
        })
    }
    
    func configure(with eventViewModel: EventViewModelProtocol) {
        eventTitleLabel.text = eventViewModel.title
        eventLocationLabel.text = eventViewModel.location
        eventTimeLabel.text = eventViewModel.time
        let favoriteFlagDisposable = eventViewModel.isFavorite.observeNext { [weak self] isFavorite in
            self?.favouriteImageView.isHidden = !isFavorite
        }
        let defaultImage = UIImage(named: "placeholder")
        eventImageView.image = defaultImage
        let imageDisposable = eventViewModel.image.observeNext { [weak self] image in
            guard image != nil else { return }
            self?.eventImageView.image = image
        }
        [favoriteFlagDisposable, imageDisposable].forEach({ $0.dispose(in: disposeBag) })
    }
    
}
