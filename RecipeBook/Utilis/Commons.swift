//
//  Commons.swift
//  RecipeBook
//
//  Created by Hector Climaco on 16/04/23.
//

import UIKit
import CoreLocation

public class Commons {
    private static let titlePermision:String = "Permitir ubicación"
    private static let bodyPermision:String = "La utilizaremos para brindarte una mejor experiencia en la app."
    private static let goToConfiguration: String = "Ir a Configuración"
    private static let locationManager =  CLLocationManager()
    
    public static func validateLocationPermissions(view viewcontroller: UIViewController) -> Bool {
        switch CLLocationManager.authorizationStatus() {
        
        case .denied,.restricted:
            
            let alert = UIAlertController(title: titlePermision, message: bodyPermision, preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: goToConfiguration, style: .default) {  (Action) in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                     
                        #if DEBUG
                            print("Settings opened: \(success)") // Prints true
                        #endif
                    })
                }
            }
            
            let actionNo = UIAlertAction(title: "Cancelar", style: .default, handler: { (success) in
            #if DEBUG
                print("AlertAction: NO")
            #endif
            })
            
            alert.addAction(actionNo)
            alert.addAction(actionYes)
            viewcontroller.present(alert, animated: true, completion: nil)
            return false
            //break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
            //break
        case .authorizedAlways, .authorizedWhenInUse:
            return true
            //break
        default:
            print("Error Desconocido")
            return false
            
        }
    }
}
