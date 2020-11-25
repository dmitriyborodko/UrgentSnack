import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class VenueViewController: UIViewController {
    static func make(env: Env) -> VenueViewController {
        let controller = VenueViewController()
        controller.env = env
        return controller
    }
    
    struct Env {
        var detailsService: VenueDetailsService
    }

    private lazy var imageView: UIImageView = makeImageView()
    private lazy var titleLabel: UILabel = makeTitleLabel()
    private lazy var likesLabel: UILabel = makeLikesLabel()
    private lazy var ratingLabel: UILabel = makeRatingLabel()
    private lazy var descriptionLabel: UILabel = makeDescriptionLabel()

    private var env: Env?
    private let bag = DisposeBag()

    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white

        configureSubviews()

        env?.detailsService.activate().disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func configureSubviews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(likesLabel)
        view.addSubview(ratingLabel)
        view.addSubview(descriptionLabel)

        imageView.snp.makeConstraints { make in
            make.left.top.equalTo(view.safeAreaLayoutGuide).inset(Constants.viewsEdgeInsets)
            make.size.equalTo(Constants.imageViewSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Constants.viewsEdgeInsets.left)
            make.top.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.viewsEdgeInsets)
        }
        likesLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Constants.viewsEdgeInsets.left)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.viewsEdgeInsets.top)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.viewsEdgeInsets)
        }
        ratingLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Constants.viewsEdgeInsets.left)
            make.top.equalTo(likesLabel.snp.bottom).offset(Constants.viewsEdgeInsets.top)
            make.right.equalTo(view.safeAreaLayoutGuide).inset(Constants.viewsEdgeInsets)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.viewsEdgeInsets)
            make.top.equalTo(imageView.snp.bottom).offset(Constants.viewsEdgeInsets.top)
        }

        env?.detailsService.updateCast().bind(to: titleLabel.rx.text).disposed(by: bag)
        env?.detailsService.avatarCast().bind(to: imageView.rx.image).disposed(by: bag)
        env?.detailsService.likesCast().bind(to: likesLabel.rx.text).disposed(by: bag)
        env?.detailsService.ratingCast().bind(to: ratingLabel.rx.text).disposed(by: bag)
        env?.detailsService.descriptionCast().bind(to: descriptionLabel.rx.text).disposed(by: bag)
    }

    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.textColor = .darkText
        label.numberOfLines = 1
        return label
    }

    private func makeLikesLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = .darkText
        return label
    }

    private func makeRatingLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = .darkText
        return label
    }

    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11.0)
        label.textColor = .darkText
        label.numberOfLines = 0
        return label
    }
}

private enum Constants {
    static let imageViewSize: CGSize = .init(width: 200, height: 200)
    static let viewsEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
}
