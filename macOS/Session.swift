import Combine

final class Session {
    let sidebar = PassthroughSubject<Void, Never>()
    let middlebar = PassthroughSubject<Void, Never>()
}
