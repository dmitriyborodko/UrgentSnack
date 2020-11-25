import Foundation
import RxSwift

struct Linker {
    let apiService: APIService
    let customer: SerialDispatchQueueScheduler
    let errorNode = PublishSubject<Error>()

    init() throws {
        let urlSession = URLSession.shared
        self.apiService = try .init(
            env: .init(
                context: .init(
                    clientId: .init(name: "client_id", value: "QUPZTW4W2ZDT3JTVFAXWFVDCTIYYKQPMNNIRRPLMV2V5ZM2U"),
                    baseURL: URL(string: "https://api.foursquare.com/v2")
                        .restoreNil { throw "baseUrl invalid".mayDay },
                    clientSecret: .init(
                        name: "client_secret",
                        value: "OWPSD1WADXVX5L1BPMGYRE3P025SIKCFV1XJOTGV22GDB5V5"
                    ),
                    version: .init(name: "v", value: "20201125")
                ),
                fetch: urlSession.rx.data(request:),
                worker: .init(qos: .default)
            )
        )
        self.customer = MainScheduler.instance
    }

    var mapEnv: MapViewController.Env {
        return .init(
            mapService: .init(
                env: .init(
                    loadVenues: apiService.load(request:),
                    serializer: .init(qos: .userInitiated),
                    customer: customer,
                    sendError: errorNode.onNext
                )
            )
        )
    }

    func venueDetailsEnv(id: String) -> VenueViewController.Env {
        return .init(
            detailsService: .init(
                env: .init(
                    loadVenueDetails: apiService.load(request:),
                    loadBestPhoto: apiService.load(request:),
                    customer: customer,
                    id: id,
                    sendError: errorNode.onNext
                )
            )
        )
    }
}
