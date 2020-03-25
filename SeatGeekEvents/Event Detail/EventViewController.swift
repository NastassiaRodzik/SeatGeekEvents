//
//  EventViewController.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit
import ReactiveKit

final class EventViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var favouriteButton: UIButton!
    
    private let viewModel: EventViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: EventViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureInterface()
        let favoriteFlagDisposable = viewModel.isFavorite.observeNext { [unowned self] isFavourite in
            let favoriteEventButtonImage = UIImage(named: "heart_on")
            let unfavoriteEventButtonImage = UIImage(named: "heart_off")
            
            let favouriteButtonImage = isFavourite ? favoriteEventButtonImage : unfavoriteEventButtonImage
            self.favouriteButton.setImage(favouriteButtonImage, for: .normal)
        }
        let favoriteButtonActionDisposable = favouriteButton.reactive.controlEvents(.touchUpInside).observeNext { [unowned self] _ in
            self.viewModel.favouriteButtonTapped()
        }
        [favoriteFlagDisposable, favoriteButtonActionDisposable].forEach({ $0.dispose(in: disposeBag) })
    }

    private func configureInterface() {
        titleLabel.text = viewModel.eventViewModel.title
        dateLabel.text = viewModel.eventViewModel.time
        locationLabel.text = viewModel.eventViewModel.location
        let imageDisposable = viewModel.eventViewModel.image.observeNext { [weak self] image in
            self?.imageView.image = image
        }
        let closeButtonDisposable = closeButton.reactive.controlEvents(.touchUpInside).observeNext { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        [imageDisposable, closeButtonDisposable].forEach({ $0.dispose(in: disposeBag) })
        
    }
    

}
