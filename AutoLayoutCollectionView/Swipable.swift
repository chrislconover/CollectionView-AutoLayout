//
//  Swipable.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 2/5/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

protocol SwipeSubscription {}
class DisposableSwipe:  SwipeSubscription {
    init(_ disposeBag: DisposeBag) { self.disposeBag = disposeBag }
    let disposeBag: DisposeBag
}

protocol Swipeable {}

extension UIView: Swipeable {

    func registerLeftSwipeView(_ configure: @escaping () -> UIView) -> SwipeSubscription {
        let disposeBag = DisposeBag()
        let pan = self.rx.panGesture()
        var left: UIView!
        pan.when(.began)
        .subscribe(onNext: { pan in
            left = configure()
            left.translatesAutoresizingMaskIntoConstraints = false

        })
        pan.when(.recognized)
            .subscribe(onNext: { pan in },
                       onError: { error in },
                       onCompleted: {},
                       onDisposed: {})
            .disposed(by: disposeBag)
        return DisposableSwipe(disposeBag)
    }

//    func registerRightSwipeView(_ configure: @escaping () -> UIView) -> SwipeSubscription {
//        return SwipeSubscriptionImp()
//    }
}
