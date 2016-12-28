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
        container.register(BusNodesForBusLinesInteractor.self) { _ in BusNodesForBusLinesAsyncInteractor(injector: self) }
        container.register(BusLinesScheduleInteractor.self) { _ in BusLineScheduleAsyncInteractor(injector: self) }
        container.register(BusLineTimeTableInteractor.self) { _ in BusLineTimeTableAsyncInteractor(injector: self) }

        container.register(BusGeoPOIInteractor.self) { _ in BusGeoPOIAsyncInteractor(injector: self) }
        container.register(BusGeoNodesAroundLocationInteractor.self) { _ in BusGeoNodesAroundLocationAsyncInteractor(injector: self) }
        container.register(BusGeoNodeArrivalsInteractor.self) { _ in BusGeoNodeArrivalsAsyncInteractor(injector: self) }
        
        //Helpers
        container.register(LocationHelper.self) { _ in LocationHelperBase() }
        
        //Data
        container.register(RequestClient.self) { _ in AlamofireRequestClient() }.inObjectScope(.container)
        container.register(BusRepository.self) { _ in BusRepositoryBase(injector: self) }
        container.register(BusGeoRepository.self) { _ in BusGeoRepositoryBase(injector: self) }
    }
    
    func instanceOf<T>(_ type: T.Type) -> T {
        guard let instance = container.resolve(type) else {
            fatalError("Can't retrieve instance of \(type)")
        }
        return instance
    }
}
