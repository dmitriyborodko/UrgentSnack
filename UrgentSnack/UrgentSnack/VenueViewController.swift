import UIKit
import SnapKit

final class VenueViewController: UIViewController {

    static func make(env: Env) -> VenueViewController {
        let this = VenueViewController()
        this.env = env
        return this
    }
    
    struct Env {
        var detailsService: VenueDetailsService
    }
    // MARK: - Instance Properties

    private let imageView: UIImageView = .init()
    private let titleLabel: UILabel = .init()
    private var env: Env?
//    private let

    // MARK: - Initializers

    // MARK: - Instance Methods

    override func loadView() {
        self.view = UIView()

        configureImageView()
        configureTitleLabel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    private func configureImageView() {
        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(Constants.contentEdgeInsets)
            make.size.equalTo(Constants.imageViewSize)
        }
    }

    private func configureTitleLabel() {
        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(Constants.titleLabelLeftOffset)
            make.right.top.equalToSuperview().inset(Constants.contentEdgeInsets)
        }
    }
}

private enum Constants {

    // MARK: - Instance Properties

    static let imageViewSize: CGSize = .init(width: 50, height: 50)
    static let contentEdgeInsets: UIEdgeInsets = .init(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    static let imageViewLeftTopInset: CGFloat = 8.0
    static let titleLabelLeftOffset: CGFloat = 8.0
}
