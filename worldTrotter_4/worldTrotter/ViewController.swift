//
//  ViewController.swift
//  worldTrotter
//
//  Created by Ann Ubaka on 9/20/25.
//

import UIKit

final class ConversionViewController: UIViewController {

    // Choose which challenge to demonstrate.
    // .bronze  -> centered + vertical spacing chain (8pt)  (matches the chapter’s practice) :contentReference[oaicite:2]{index=2}
    // .silver  -> bronze + gradient background (CAGradientLayer)                           :contentReference[oaicite:3]{index=3}
    // .gold    -> evenly spaced top-to-bottom using spacer views with equal heights         :contentReference[oaicite:4]{index=4}
    private enum Mode { case bronze, silver, gold }
    private let mode: Mode = .gold

    // UI
    private let topBigLabel    = UILabel()
    private let topSmallLabel  = UILabel()
    private let midSmallLabel  = UILabel()
    private let botBigLabel    = UILabel()
    private let botSmallLabel  = UILabel()

    // Gradient (Silver/Gold)
    private let gradientLayer = CAGradientLayer()

    // Spacers (Gold)
    private var spacers: [UIView] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF4/255.0, blue: 0xF1/255.0, alpha: 1.0) // F5F4F1 :contentReference[oaicite:5]{index=5}
        configureLabels()
        switch mode {
        case .bronze:
            layoutBronze()
        case .silver:
            addGradient()
            layoutBronze()
        case .gold:
            addGradient()
            layoutGold()
        }
    }

    // Layers don’t use Auto Layout → keep gradient in sync with view bounds. :contentReference[oaicite:6]{index=6}
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    // MARK: - UI Setup

    private func configureLabels() {
        // Text per Chapter 3’s example UI
        topBigLabel.text   = "212"
        topSmallLabel.text = "degrees Fahrenheit"
        midSmallLabel.text = "is really"
        botBigLabel.text   = "100"
        botSmallLabel.text = "degrees Celsius"

        let burntOrange = UIColor(red: 0xE1/255.0, green: 0x58/255.0, blue: 0x29/255.0, alpha: 1.0) // E15829 :contentReference[oaicite:7]{index=7}

        // Fonts and colors like the book’s walkthrough (two big, three small). :contentReference[oaicite:8]{index=8}
        topBigLabel.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        botBigLabel.font = UIFont.systemFont(ofSize: 70, weight: .regular)

        topSmallLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        midSmallLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        botSmallLabel.font = UIFont.systemFont(ofSize: 36, weight: .regular)

        // Orange for the top two + bottom one (matching the book’s style cue). :contentReference[oaicite:9]{index=9}
        [topBigLabel, topSmallLabel, botSmallLabel, botBigLabel].forEach { $0.textColor = burntOrange }

        // Basic label config
        [topBigLabel, topSmallLabel, midSmallLabel, botBigLabel, botSmallLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
            view.addSubview($0)
        }
    }

    // MARK: - Bronze (centered + 8pt vertical chain)
    // Matches: center horizontally, pin each label’s top to its nearest neighbor by 8, keep intrinsic size. :contentReference[oaicite:10]{index=10} :contentReference[oaicite:11]{index=11}
    private func layoutBronze() {
        let labels = [topBigLabel, topSmallLabel, midSmallLabel, botBigLabel, botSmallLabel]
        // Horizontal centers
        labels.forEach {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        // Vertical chain with 8pt spacing from safe area down. :contentReference[oaicite:12]{index=12}
        let g = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            topBigLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 8),
            topSmallLabel.topAnchor.constraint(equalTo: topBigLabel.bottomAnchor, constant: 8),
            midSmallLabel.topAnchor.constraint(equalTo: topSmallLabel.bottomAnchor, constant: 8),
            botBigLabel.topAnchor.constraint(equalTo: midSmallLabel.bottomAnchor, constant: 8),
            botSmallLabel.topAnchor.constraint(equalTo: botBigLabel.bottomAnchor, constant: 8)
        ])
    }

    // MARK: - Silver (Gradient)
    // Use CAGradientLayer behind the labels; keep frame = view.bounds in viewWillLayoutSubviews. :contentReference[oaicite:13]{index=13}
    private func addGradient() {
        let top = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1).cgColor   // ~F5F4F1
        let mid = UIColor(red: 0.99, green: 0.79, blue: 0.70, alpha: 1).cgColor   // soft peach
        let bot = UIColor(red: 0.88, green: 0.34, blue: 0.16, alpha: 1).cgColor   // ~E15829 vibe
        gradientLayer.colors = [top, mid, bot]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint   = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    // MARK: - Gold (Even spacing top-to-bottom with equal-height spacers)
    // Six spacers for five labels: top + between each + bottom, all equal height. :contentReference[oaicite:14]{index=14}
    private func layoutGold() {
        let labels = [topBigLabel, topSmallLabel, midSmallLabel, botBigLabel, botSmallLabel]
        // Horizontal centers per chapter guidance. :contentReference[oaicite:15]{index=15}
        labels.forEach {
            NSLayoutConstraint.activate([$0.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        }

        // Build spacers
        let g = view.safeAreaLayoutGuide
        let spacerCount = labels.count + 1 // top, between, bottom
        spacers = (0..<spacerCount).map { _ in
            let v = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.isAccessibilityElement = false
            v.backgroundColor = .clear // hidden/invisible spacers
            view.addSubview(v)
            return v
        }

        // Pin leading/trailing for spacers
        spacers.forEach { spacer in
            NSLayoutConstraint.activate([
                spacer.leadingAnchor.constraint(equalTo: g.leadingAnchor),
                spacer.trailingAnchor.constraint(equalTo: g.trailingAnchor)
            ])
        }

        // Vertical chain:
        // spacer0.top = safe.top
        // label1.top = spacer0.bottom
        // spacer1.top = label1.bottom
        // ...
        // spacerN.bottom = safe.bottom
        NSLayoutConstraint.activate([
            spacers.first!.topAnchor.constraint(equalTo: g.topAnchor),
            spacers.last!.bottomAnchor.constraint(equalTo: g.bottomAnchor)
        ])

        for i in 0..<labels.count {
            let aboveSpacer = spacers[i]
            let belowSpacer = spacers[i+1]
            NSLayoutConstraint.activate([
                labels[i].topAnchor.constraint(equalTo: aboveSpacer.bottomAnchor),
                belowSpacer.topAnchor.constraint(equalTo: labels[i].bottomAnchor)
            ])
        }

        // Equal heights for all spacers → even distribution. :contentReference[oaicite:16]{index=16}
        for i in 1..<spacers.count {
            spacers[i].heightAnchor.constraint(equalTo: spacers[0].heightAnchor).isActive = true
        }
    }
}
