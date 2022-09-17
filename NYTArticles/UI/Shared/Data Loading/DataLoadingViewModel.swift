import Foundation
import Combine

enum DataLoadingViewModelState<DataType> {
    case loading
    case loadingFailed(Error)
    case retryingLoad
    case loaded(DataType)
    case manualReloading(DataType)
    case manualReloadingFailed(DataType, Error)
}

enum DataLoadingViewModelEvent<DataType> {
    case retryInitialLoad
    case manualReload
    case proceedFromManualReloadingFailed
    case loadSuccess(DataType)
    case loadFailure(Error)
}

class DataLoadingViewModel<DataType>: NSObject {
    //----------------------------------------  
    // MARK:- Methods
    //----------------------------------------

    func load() -> AnyPublisher<DataType, Error> {
        fatalError("\(#function) must be overridden by subclasses")
    }

    //----------------------------------------
    // MARK:- Initialization
    //----------------------------------------

    override init() {
        super.init()
        proceedToLoad()
    }

    //----------------------------------------
    // MARK:- Loading data
    //----------------------------------------

    private func proceedToLoad() {
        load().sink { completion in
            switch completion {
            case .finished:
                break

            case .failure(let error):
                self.transition(with: .loadFailure(error))
            }
        } receiveValue: { data in
            self.transition(with: .loadSuccess(data))
        }.store(in: &cancellableSet)
    }

    //----------------------------------------
    // MARK:- Actions
    //----------------------------------------

    func retryInitialLoad() {
        transition(with: .retryInitialLoad)
    }

    func reloadManually() {
        transition(with: .manualReload)
    }

    //----------------------------------------
    // MARK:- State
    //----------------------------------------

    private(set) var state: DataLoadingViewModelState<DataType> = .loading {
        didSet {
            stateChangeBlock?(state)
        }
    }

    var stateChangeBlock: ((DataLoadingViewModelState<DataType>) -> Void)?

    //----------------------------------------
    // MARK:- Transition
    //----------------------------------------

    private func transition(with event: DataLoadingViewModelEvent<DataType>) {
        switch (state, event) {
        case (.loading, .loadSuccess(let data)):
            state = .loaded(data)

        case (.loading, .loadFailure(let error)):
            state = .loadingFailed(error)
            
        case (.loaded, .retryInitialLoad):
            state = .retryingLoad
            proceedToLoad()

        case (.loadingFailed, .retryInitialLoad):
            state = .retryingLoad
            proceedToLoad()

        case (.retryingLoad, .loadSuccess(let data)):
            state = .loaded(data)

        case (.retryingLoad, .loadFailure(let error)):
            state = .loadingFailed(error)

        case (.loaded(let data), .manualReload):
            state = .manualReloading(data)
            proceedToLoad()
            
        case (.loadingFailed, .manualReload):
            state = .loading
            proceedToLoad()

        case (.manualReloading, .loadSuccess(let data)):
            state = .loaded(data)

        case (.manualReloading(let data), .loadFailure(let error)):
            state = .manualReloadingFailed(data, error)

            // Transition away from manualReloadingFailed immediately.
            DispatchQueue.main.async { [weak self] in
                self?.transition(with: .proceedFromManualReloadingFailed)
            }

        case (.manualReloadingFailed(let data, _), .proceedFromManualReloadingFailed):
            state = .loaded(data)

        default:
            print("invalid event for state")
            state = .retryingLoad
            proceedToLoad()
        }
    }

    //----------------------------------------
    // MARK:- Internals
    //----------------------------------------

    private var cancellableSet: Set<AnyCancellable> = Set()
}
