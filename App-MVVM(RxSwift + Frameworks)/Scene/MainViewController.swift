//
//  MainViewController.swift
//  App-MVVM-RxSwift-Frameworks-.git
//
//  Created by Александр Муклинов on 14.06.2024.
//

import UIKit
import SnapKit
import SafariServices
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    
    typealias News = ContentModel.News
    
    var tableView = UITableView()
    let maskLayer: CAShapeLayer = CAShapeLayer()
    var viewModel: MainViewModel!
    private let disposeBag = DisposeBag()

    var isNoDisplayedDisplayOfInformationView  = false
    
    init(mainViewModel: MainViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = mainViewModel
        binding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        setupMaskLayer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.show(mask: maskLayer, view: view)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setupMaskLayer() {
        maskLayer.path = UIBezierPath(rect: view.bounds).cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.opacity = 1.0
        maskLayer.fillColor = UIColor.white.cgColor
        view.layer.mask = maskLayer
    }
    
    private func binding() {
        
        tableView.dataSource = nil
        tableView.delegate = nil
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.content
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)) { index, model, cell in
                cell.configure(with: model)
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(News.self)
            .asDriver()
            .drive(onNext: { [weak self] news in
                if let url = news.urlToSourсe {
                    let presentationNewsController = SFSafariViewController(url: url)
                    presentationNewsController.dismissButtonStyle = .close
                    presentationNewsController.modalPresentationStyle = .popover
                    presentationNewsController.modalTransitionStyle = .coverVertical
                    self?.present(presentationNewsController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                strongSelf.tableView.deselectRow(at: indexPath, animated: true)

            })
            .disposed(by: disposeBag)
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] _, indexPath in
                guard let strongSelf = self else { return }
                if indexPath.row + 2 >= strongSelf.viewModel.content.value.count {
                    strongSelf.viewModel.downloadContent()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.maskDeinit
            .subscribe(onNext: { [weak self] in
                self?.maskLayer.removeFromSuperlayer()
            })
            .disposed(by: disposeBag)
        
        viewModel.showNoConnectToInternet
            .subscribe(onNext: { [weak self] error in
                if case let NetworkErrors.noConnectToNetwork(stringForLabel, stringForButton) = error {
                    DispatchQueue.main.async {
                        
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showAboutPageLimit
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {

                }
            })
            .disposed(by: disposeBag)
        
        viewModel.showDownloadsOfNewsNotFinish
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {

                }
            })
            .disposed(by: disposeBag)
    }

    private func setupBefore(displayOfInformationView: UIView) {
        
    }
    
    private func setupAfter(displayOfInformationView: UIView) {
        
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500.0
    }
}
