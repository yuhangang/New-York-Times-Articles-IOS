import Foundation
import Combine

enum State<DataType> {
    case loading
    case loadingFailed(Error)
    case retryingLoad
    case loaded(DataType)
    case manualReloading(DataType)
    case manualReloadingFailed(DataType, Error)
}

enum Event<DataType> {
    case retryInitialLoad
    case manualReload
    case proceedFromManualReloadingFailed
    case loadSuccess(DataType)
    case loadFailure(Error)
}

class StatefulViewModel<DataType>: NSObject {
    //----------------------------------------  
    // MARK: - Methods
    //----------------------------------------

    func load() -> AnyPublisher<DataType, Error> {
        fatalError("\(#function) must be overridden by subclasses")
    }

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init() {
        super.init()
        proceedToLoad()
    }

    //----------------------------------------
    // MARK: - Loading data
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
    // MARK: - Actions
    //----------------------------------------

    func retryInitialLoad() {
        transition(with: .retryInitialLoad)
    }

    func reloadManually() {
        transition(with: .manualReload)
    }

    //----------------------------------------
    // MARK: - State
    //----------------------------------------

    private let stateSubject = CurrentValueSubject<State<DataType>, Never>(.loading)
    var statePublisher: AnyPublisher<State<DataType>, Never> {
        stateSubject.eraseToAnyPublisher()
    }
    
    //----------------------------------------
    // MARK: - Transition
    //----------------------------------------

    private func transition(with event: Event<DataType>) {
        switch (stateSubject.value, event) {
        case (.loading, .loadSuccess(let data)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with data: \(data)")
            stateSubject.send(.loaded(data))

        case (.loading, .loadFailure(let error)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.loadingFailed(error))
            
        case (.loaded, .retryInitialLoad):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()

        case (.loadingFailed, .retryInitialLoad):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()

        case (.retryingLoad, .loadSuccess(let data)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with data: \(data)")
            stateSubject.send(.loaded(data))

        case (.retryingLoad, .loadFailure(let error)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.loadingFailed(error))

        case (.loaded(let data), .manualReload):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.manualReloading(data))
            proceedToLoad()
            
        case (.loadingFailed, .manualReload):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loading)
            proceedToLoad()

        case (.manualReloading, .loadSuccess(let data)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with data: \(data)")
            stateSubject.send(.loaded(data))

        case (.manualReloading(let data), .loadFailure(let error)):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.manualReloadingFailed(data, error))

            // Transition away from manualReloadingFailed immediately.
            DispatchQueue.main.async { [weak self] in
                self?.transition(with: .proceedFromManualReloadingFailed)
            }

        case (.manualReloadingFailed(let data, _), .proceedFromManualReloadingFailed):
            trace("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loaded(data))

        default:
            trace("StatefulViewModel - invalid event for state: \(stateSubject.value), \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()
        }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var cancellableSet: Set<AnyCancellable> = Set()
}
