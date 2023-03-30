//
//  MarkerDetailViewController.swift
//  AroundFootball
//
//  Created by 강창현 on 2022/04/12.
//

import UIKit

class MarkerDetailViewController: UIViewController {
    
    private let dimmedView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
            return view
    }()
    
    private let markerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        // 좌측 상단과 좌측 하단의 cornerRadius를 10으로 설정한다.
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    enum MarkerViewState {
            case expanded
            case normal
        }
    // Bottom Sheet과 safe Area Top 사이의 최소값을 지정하기 위한 프로퍼티
    // 기본값은 30으로 지정
    var markerViewPanMinTopConstant: CGFloat = 30.0

    // 드래그 하기 전에 Bottom Sheet의 top Constraint value를 저장하기 위한 프로퍼티
    private lazy var markerViewPanStartingTopConstant: CGFloat = markerViewPanMinTopConstant
    
    private var markerViewTopConstraint: NSLayoutConstraint!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
            dimmedView.addGestureRecognizer(dimmedTap)
            dimmedView.isUserInteractionEnabled = true
        
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        // 기본적으로 iOS는 터치가 드래그하였을 때 딜레이가 발생함
        // 우리는 드래그 제스쳐가 바로 발생하길 원하기 때문에 딜레이가 없도록 아래와 같이 설정
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }
    
    private func hideMarkerViewAndGoBack() {
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        markerViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideMarkerViewAndGoBack()
    }
    
    func nearest(to number: CGFloat, inValues values: [CGFloat]) -> CGFloat {
        guard let nearestVal = values.min(by: { abs(number - $0) < abs(number - $1) })
        else { return number }
        return nearestVal
    }

    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        switch panGestureRecognizer.state {
        case .began:
            markerViewPanStartingTopConstant = markerViewTopConstraint.constant
            
        case .changed:
            if markerViewPanStartingTopConstant + translation.y > markerViewPanMinTopConstant {
                markerViewTopConstraint.constant = markerViewPanStartingTopConstant + translation.y
            }
            
            dimmedView.alpha = dimAlphaWithMarkerViewTopConstraint(value: markerViewTopConstraint.constant)
            
        case .ended:
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            
            if velocity.y > 1500 {
                hideMarkerViewAndGoBack()
                return
            }
            // 1
            let defaultPadding = safeAreaHeight+bottomPadding - defaultHeight
            
            // 2
            let nearestValue = nearest(to: markerViewTopConstraint.constant, inValues: [markerViewPanMinTopConstant, defaultPadding, safeAreaHeight + bottomPadding])
            
            // 3
            if nearestValue == markerViewPanMinTopConstant {
                showMarkerView(atState: .expanded)
            } else if nearestValue == defaultPadding {
                // Bottom Sheet을 .normal 상태로 보여주기
                showMarkerView(atState: .normal)
            } else {
                // Bottom Sheet을 숨기고 현재 View Controller를 dismiss시키기
                hideMarkerViewAndGoBack()
            }
        default:
            break
        }
    }
    
    private func dimAlphaWithMarkerViewTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha: CGFloat = 0.7
        
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
            // bottom sheet의 top constraint 값이 fullDimPosition과 같으면
            // dimmer view의 alpha 값이 0.7이 되도록 합니다
        let fullDimPosition = (safeAreaHeight + bottomPadding - defaultHeight) / 2

            // bottom sheet의 top constraint 값이 noDimPosition과 같으면
            // dimmer view의 alpha 값이 0.0이 되도록 합니다
        let noDimPosition = safeAreaHeight + bottomPadding

            // Bottom Sheet의 top constraint 값이 fullDimPosition보다 작으면
            // 배경색이 가장 진해진 상태로 지정해줍니다.
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
            // Bottom Sheet의 top constraint 값이 noDimPosition보다 크면
            // 배경색이 투명한 상태로 지정해줍니다.
        if value > noDimPosition {
            return 0.0
        }
        
            // 그 외의 경우 top constraint 값에 따라 0.0과 0.7 사이의 alpha 값이 Return되도록 합니다
        return fullDimAlpha * (1 - ((value - fullDimPosition) / (noDimPosition - fullDimPosition)))
    }
    
    var defaultHeight: CGFloat = 300
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMarkerView()
    }
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    
    private let contentViewController: UITableViewController

    // ✅ 이니셜라이저 구현
    init(contentViewController: UITableViewController) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        view.addSubview(dimmedView)
        view.addSubview(markerView)
        view.addSubview(dragIndicatorView)
    
        addChild(contentViewController)
            markerView.addSubview(contentViewController.view)
            contentViewController.didMove(toParent: self)
            markerView.clipsToBounds = true
        
        dimmedView.alpha = 0.0
        setupLayout()
    }
        
    private func setupLayout() {
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        markerView.translatesAutoresizingMaskIntoConstraints = false
//        let topConstant: CGFloat = 300
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        markerViewTopConstraint = markerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            markerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            markerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            markerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            markerViewTopConstraint,
        ])
        
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 60),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: dragIndicatorView.layer.cornerRadius * 2),
            dragIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dragIndicatorView.bottomAnchor.constraint(equalTo: markerView.topAnchor, constant: -10)
        ])
        
        contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentViewController.view.topAnchor.constraint(equalTo: markerView.topAnchor),
            contentViewController.view.leadingAnchor.constraint(equalTo: markerView.leadingAnchor),
            contentViewController.view.trailingAnchor.constraint(equalTo: markerView.trailingAnchor),
            contentViewController.view.bottomAnchor.constraint(equalTo: markerView.bottomAnchor)
            ])
    }
    
    private func showMarkerView(atState: MarkerViewState = .normal) {
        if atState == .normal {
            let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding: CGFloat = view.safeAreaInsets.bottom
            markerViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - defaultHeight
        } else {
            markerViewTopConstraint.constant = markerViewPanMinTopConstant
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = self.dimAlphaWithMarkerViewTopConstraint(value: self.markerViewTopConstraint.constant)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
