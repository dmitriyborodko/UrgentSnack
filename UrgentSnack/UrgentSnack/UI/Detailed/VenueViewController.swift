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

    // MARK: - Instance Properties

    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private var env: Env?
    private let bag = DisposeBag()

    // MARK: - Initializers

    // MARK: - Instance Methods

    override func loadView() {
        self.view = UIView()
        view.backgroundColor = .white

        view.addSubview(imageView)
        view.addSubview(titleLabel)

        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(Constants.contentEdgeInsets)
            make.size.equalTo(Constants.imageViewSize)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Constants.titleLabelLeftOffset)
            make.right.top.equalToSuperview().inset(Constants.contentEdgeInsets)
        }

        env?.detailsService.updateCast().bind(to: titleLabel.rx.text).disposed(by: bag)
        env?.detailsService.avatarCast().bind(to: imageView.rx.image).disposed(by: bag)
        env?.detailsService.activate().disposed(by: bag)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

private enum Constants {

    // MARK: - Instance Properties

    static let imageViewSize: CGSize = .init(width: 50, height: 50)
    static let contentEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    static let imageViewLeftTopInset: CGFloat = 8.0
    static let titleLabelLeftOffset: CGFloat = 8.0
}
