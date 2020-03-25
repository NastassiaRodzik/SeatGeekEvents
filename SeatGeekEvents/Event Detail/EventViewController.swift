//
//  EventViewController.swift
//  SeatGeekEvents
//
//  Created by Анастасия Ковалева on 3/24/20.
//  Copyright © 2020 Anastasia Rodzik. All rights reserved.
//

import UIKit

final class EventViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    
    let viewModel: EventViewModel
    
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
    }

    private func configureInterface() {
        titleLabel.text = viewModel.eventViewModel.title
        dateLabel.text = viewModel.eventViewModel.time
        locationLabel.text = viewModel.eventViewModel.location
        let _ = viewModel.eventViewModel.image.observeNext { [weak self] image in
            self?.imageView.image = image
        }
        let _ = closeButton.reactive.controlEvents(.touchUpInside).observeNext { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    

}
