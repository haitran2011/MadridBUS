import UIKit
import Swinject

class SwinjectInjectorProvider: InjectorProvider, Injector {
    private let container: Container
    
    static var injector: Injector {
        let injectorModule = SwinjectInjectorProvider()
        injectorModule.configure()
        return injectorModule
    }
    
    init() {
        self.container = Container()
    }
    
    func configure() {
        //UI
        container.register(UIApplication.self) { _ in UIApplication.shared }.inObjectScope(.container)
        container.register(ApplicationManagerAdapter.self) { _ in ApplicationManager(injector: self) }.inObjectScope(.container)
        container.register(Wireframe.self) { _ in WireframeBase() }
        container.register(ErrorPresenter.self) { _ in ErrorPresenterBase(injector: self) }

        container.register(WelcomePresenter.self) { _ in WelcomePresenterBase(injector: self) }

        //Business
        container.register(BusGroupsInteractor.self) { _ in BusGroupsAsyncInteractor(injector: self) }
        container.register(BusCalendarInteractor.self) { _ in BusCalendarAsyncInteractor(injector: self) }
        container.register(BusLinesBasicInfoInteractor.self) { _ in BusLinesBasicInfoAsyncInteractor(injector: self) }
        container.register(BusNodesBasicInfoInteractor.self) { _ in BusNodesBasicInfoAsyncInteractor(injector: self) }

        //Helpers
        
        //Data
        container.register(RequestClient.self) { _ in AlamofireRequestClient() }.inObjectScope(.container)
        container.register(BusRepository.self) { _ in BusRepositoryBase(injector: self) }
    }
    
    func instanceOf<T>(_ type: T.Type) -> T {
        guard let instance = container.resolve(type) else {
            fatalError("Can't retrieve instance of \(type)")
        }
        return instance
    }
}
