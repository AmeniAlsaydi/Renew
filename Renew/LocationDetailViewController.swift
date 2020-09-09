//
//  LocationDetailViewController.swift
//  Renew
//
//  Created by Amy Alsaydi on 9/7/20.
//  Copyright © 2020 Amy Alsaydi. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class LocationDetailViewController: UIViewController {
    
    @IBOutlet weak var boarderView: UIView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let location: RecycleLocation
    private var latitude: CLLocationDegrees?
    private var longitude: CLLocationDegrees?
    private var acceptedItems = [AcceptedItem]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    init?(coder: NSCoder, location: RecycleLocation) {
        self.location = location
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        boarderView.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        configureMapView()
        loadMapAnnotations()
        configureCollectionView()
        getAcceptedItem()
    }
    
    private func getAcceptedItem() {
        
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "AccetpedItemCell", bundle: nil), forCellWithReuseIdentifier: "accetpedItemCell") // register cell
    }
    
    private func configureMapView() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
    }
    
    private func loadMapAnnotations()  {
        
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        getCoordinateFrom(address: getAddress()) { [weak self] (coordinate, error) in
            guard let coordinate = coordinate, error == nil else { return }
            
            self?.latitude = coordinate.latitude
            self?.longitude = coordinate.longitude
            
            let placeCoordinate = CLLocationCoordinate2DMake(Double(coordinate.latitude), Double(coordinate.longitude))
            annotation.coordinate = placeCoordinate
            self?.mapView.addAnnotation(annotation)
            DispatchQueue.main.async {
                //                     self?.removeIndicator()
                self?.mapView.showAnnotations([annotation], animated: true)
            }
        }
    }
    
    private func dialNumber(number : String) {
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            print("error dialing number ")
        }
    }
    
    private func getAddress() -> String {
        guard let zipcode = location.zipcode else {
            return ""
        }
        let address = location.address ?? ""
        let city = location.city ?? ""
        let state = location.state ?? ""
        
        let fullAddress = "\(address) \(city) \(state) \(zipcode)"
        return fullAddress
    }
    
    private func updateUI() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = location.name
        hoursLabel.text = location.hours
        phoneNumberButton.setTitle(location.phoneNumber, for: .normal)
        addressLabel.text = getAddress()
    }
    
    @IBAction func phoneNumberPressed(_ sender: UIButton) {
        // call number
        let set = CharacterSet(charactersIn: "+*#0123456789")
        let phoneNum = location.phoneNumber.components(separatedBy: set.inverted).joined()
        dialNumber(number: phoneNum)
    }
    
    @IBAction func websitePressed(_ sender: UIButton) {
        // go to website
        
        guard let url = URL(string: location.website ?? "") else {
            showAlert(title: "Error", message: "Website not found")
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    @IBAction func drivingButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeDriving)
    }
    
    @IBAction func walkingButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeWalking)
    }
    
    @IBAction func transitButtonPressed(_ sender: UIButton) {
        guard let latitude = latitude, let longitude = longitude else {
            return
        }
        
        let placeCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        openMapsAppWithDirections(to: placeCoordinate, destinationName: location.name, mode: MKLaunchOptionsDirectionsModeTransit)
    }
}

extension LocationDetailViewController: MKMapViewDelegate {
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let identifier = "annotationView"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.markerTintColor = #colorLiteral(red: 0.08992762119, green: 0.6527115107, blue: 0.6699190736, alpha: 1)
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func openMapsAppWithDirections(to coordinate: CLLocationCoordinate2D, destinationName name: String, mode: String) {
        let options = [MKLaunchOptionsDirectionsModeKey: mode]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name // Provide the name of the destination in the To: field
        mapItem.openInMaps(launchOptions: options)
    }
}

extension LocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 // accetpedItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "accetpedItemCell", for: indexPath) as? AccetpedItemCell else {
            fatalError("could not dequeue to accetpedItemCell")
        }
        // let item = accetpedItems[indexPath.row]
        // cell.configureCell(item)
        
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxsize: CGSize = view.frame.size
        let itemWidth: CGFloat = maxsize.width * 0.95
        let itemHeight: CGFloat = maxsize.height * 0.1
        // TODO: make this self sizing
        return CGSize(width: itemWidth, height: itemHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}
