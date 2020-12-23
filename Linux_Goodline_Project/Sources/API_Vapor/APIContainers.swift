import Linux_Goodline_Project
import Vapor

class Containers {
    var managerController: ManagerController {
        ManagerController(manager: AppContainer.Manager.ManagerPtl())
    }
}

extension Application {
    var container: Containers {
        .init()
    }
}