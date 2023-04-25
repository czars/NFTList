//
//  UIScrollView+Extension.swift
//  NFTList
//
//  Created by Paul.Chou on 2023/4/20.
//

import Foundation
import RxSwift
import RxCocoa


// MARK: Load More Indicator in ScrollView
public class LoadingView: UIView {

    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .clear
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func update(loadingStatus: Bool) {
        if loadingStatus {
            isHidden = false
            activityIndicator.startAnimating()
            return
        }
        activityIndicator.stopAnimating()
    }
}

extension Reactive where Base: LoadingView {

    public var isLoading: Binder<Bool> {
        return Binder(self.base) { loadingView, isLoading in
            loadingView.update(loadingStatus: isLoading)
        }
    }
}

private var loadMoreView_AssociatedKey = "loadMoreViewKey"
private let kLoadMoreViewHeight: CGFloat = 50

extension UIScrollView {
    private var _loadMoreView: LoadingView? {
        set {
            objc_setAssociatedObject(self, &loadMoreView_AssociatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &loadMoreView_AssociatedKey) as? LoadingView
        }
    }

    private var loadMoreView: LoadingView {
        var view = _loadMoreView
        if view == nil {
            view = LoadingView()
            view?.isHidden = true
            _loadMoreView = view!
            setupLoadMoreView()
        }
        return view!
    }

    private func setupLoadMoreView() {
        addSubview(loadMoreView)
        loadMoreView.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: kLoadMoreViewHeight)
    }

    func updateMoreViewWith(isLoadMore: Bool) {
        let y = contentOffset.y + contentInset.top
        if y <= 0 {
            return
        }
        
        loadMoreView.frame.origin.y = contentSize.height
        let insetBottom = isLoadMore ? kLoadMoreViewHeight : 0
        loadMoreView.update(loadingStatus: isLoadMore)
        
        if isLoadMore {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insetBottom, right: 0)
            return
        }
        
        let visibleHeight = frame.height - contentInset.top - contentInset.bottom
        let threshold = contentSize.height - visibleHeight
        
        if y > threshold {
            let point = CGPoint(x: 0, y: threshold + safeAreaInsets.bottom)
            UIView.animate(withDuration: 0.25, animations: {
                self.contentOffset = point
                self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insetBottom, right: 0)
            })
        } else {
            self.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insetBottom, right: 0)
        }
    }
}

extension Reactive where Base: UIScrollView {
    public var isLoadingMore: Binder<Bool> {
        return Binder(self.base) { scrollView, isLoading in
            scrollView.updateMoreViewWith(isLoadMore: isLoading)
        }
    }
}


// MARK: Reached Bottom
extension Reactive where Base: UIScrollView {
    func reachedBottom(withOffset offset: CGFloat = 0.0) -> Observable<Bool> {
        let observable = contentOffset
            .map { [weak base] contentOffset -> Bool in
                guard let scrollView = base else { return false }
                let visibleHeight = scrollView.frame.height
                    - scrollView.contentInset.top
                    - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = scrollView.contentSize.height - visibleHeight
                return y + offset > threshold
        }

        return observable.distinctUntilChanged()
    }
}
