//
//  ViewController.swift
//  Reciplease
//
//  Created by pierrick viret on 21/09/2023.
//

import Combine
import UIKit

class ViewController: UIViewController {

    var cancellables = Set<AnyCancellable>()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .anthraciteGray
    }

    // note: original idea by http://holko.pl/2017/06/26/checking-uiviewcontroller-deallocation,
    // and some adjustments by Vincent.

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

#if DEBUG
        checkDeallocation()
#endif
    }

#if DEBUG
    private func checkDeallocation(afterDelay delay: TimeInterval = 2.0) {
        // We don’t check `isBeingDismissed` simply on this view controller because it’s common
        // to wrap a view controller in another view controller (e.g. in UINavigationController)
        // and present the wrapping view controller instead.
        if isMovingFromParent || rootParentViewController.isBeingDismissed {
            let type = Swift.type(of: self)
            let disappearanceSource: String = isMovingFromParent ? "removed from its parent" : "dismissed"
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                assert(self == nil, "\(type) not deallocated after being \(disappearanceSource)")
            }
        }
    }

    private var rootParentViewController: UIViewController {
        var root: UIViewController = self

        while let parent = root.parent {
            root = parent
        }

        return root
    }
#endif

    // MARK: - Init navigationBar
    func initNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .anthraciteGray
        appearance.titleTextAttributes = [.font: UIFont(name: "Chalkduster", size: 25)!,
                                          .foregroundColor: UIColor.white]

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance

        navigationController?.navigationBar.topItem?.title = "Reciplease"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }
}
