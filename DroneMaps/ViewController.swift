//
//  ViewController.swift
//  DroneMaps
//
//  Created by Артем Стратиенко on 22.03.2020.
//  Copyright © 2020 Артем Стратиенко. All rights reserved.

import UIKit
import NMAKit
import CoreTelephony
import CoreML
import AVFoundation
import YandexMapKit



///

/// MARK Prorocol section
protocol ButtonDelegate : class {
    func onButtonTap(sender: UIButton)
}
//
protocol quaklyInit{
    func MapInit ()
}
protocol InitMap {
    var copyrightLogoPosition : UInt {get set}
    var orientation : UInt {get set}
    var mapScheme : String {get set}
}
/// MARK Struct section
struct LastPosition {
    var  latitude : Double
    var longitude : Double
}
//*** user's struct
struct Location {
    var  latitude : Double
    var longitude : Double
}
struct objpost {
    var latitude = Double()
    var longitude = Double()
    var cellor = String()
}
struct closedArea {
    var frame_area = [NMAGeoCoordinates]()
}
//
struct circlePoint {
    var frame_area = [NMAGeoCoordinates]()
}
struct poly_struct {
    var id : Int
    var poly : [NMAMapPolyline]
}
struct stops {
    var id : Int
    var coordinates : NMAGeoCoordinates
}
struct routes {
    var id : Int
    var coordinates : [NMAGeoCoordinates]
    init() {
        self.id = 0
        self.coordinates = []
    }
    init (id : Int,coordinates : [NMAGeoCoordinates]) {
        self.id = id
        self.coordinates = coordinates
    }
}
struct drone_ {
    var id : Int
    var stop : stops
    var route : routes
    var coordinate : NMAGeoCoordinates
}
/// MARK Variable section
var layerRoute1 = [NMAMapPolyline]()
var layerRoute2 = [NMAMapPolyline]()
var layerRoute3 = [NMAMapPolyline]()
var layerRoute4 = [NMAMapPolyline]()
//
var arrayVert = [area]()
//z
var areas = [User]()
var arrayLocation = [Location]()
var poly = Location(latitude: 0, longitude: 0)
var last = LastPosition(latitude: 0, longitude: 0)
//
var arrayBus = [drone_]()
var arrayPolys = [poly_struct]()
let routeBus = [NMAGeoCoordinates(latitude: 55.78975234252623, longitude: 38.437278270721436),
                NMAGeoCoordinates(latitude: 55.79057571375545, longitude: 38.43688666820526),
                NMAGeoCoordinates(latitude: 55.79059984158761, longitude: 38.43688130378723),
                NMAGeoCoordinates(latitude: 55.79061793745191, longitude: 38.4369134902954),
                NMAGeoCoordinates(latitude: 55.79063301733242, longitude: 38.43697249889374),
                NMAGeoCoordinates(latitude: 55.79065714512908, longitude: 38.43708515167236),
                NMAGeoCoordinates(latitude: 55.79071746455533, longitude: 38.43745529651642),
                NMAGeoCoordinates(latitude: 55.7908230233265, longitude: 38.43817412853241),
                NMAGeoCoordinates(latitude: 55.79125731926113, longitude: 38.44126403331756)]
let routeBus_2 = [NMAGeoCoordinates(latitude: 55.7975234252623, longitude: 38.47278270721436),
NMAGeoCoordinates(latitude: 55.5071746455533, longitude: 38.23745529651642),
NMAGeoCoordinates(latitude: 55.4908230233265, longitude: 38.12817412853241),
NMAGeoCoordinates(latitude: 55.39125731926113, longitude: 38.24126403331756)]
var testStops = stops(id: 1, coordinates: NMAGeoCoordinates(latitude: 55.76238, longitude: 37.61084))
//var testRoutes = routes(id: 1, coordinates: routeBus)
//var testtrm = routes(id: 1, coordinates: routeBus_2)
// let/var
var nonSPL = [NMAGeoCoordinates]()
var panDrawLine = "Inactivate"
var detected = ""//"Delete"
var str = [NMAGeoCoordinates]()
var array_area = closedArea()
//
var dropCircle = circlePoint()
private var geoBox1 : NMAGeoBoundingBox?
private var geoPolyline : NMAMapPolyline?
var id_user = 1
var offsetPoint : NMAGeoCoordinates?// = nil
var arrayARObject = [NMAGeoCoordinates]()//?//[offsetPoint]?
var arrayARObjectYAM = [NMAGeoCoordinates]()//?//[offsetPoint]?
var arrayBusMove = [NMAMapMarker]()
var newArrayAR = [NMAGeoCoordinates]()
/* "LineString","coordinates":[[37.54329800605774,55.89138380688599],[37.5432550907135,55.89074306140778],[37.54386126995086,55.8907550942842],[37.544381618499756,55.89076411893906],[37.5444620847702,55.89076712715686],[37.544424533843994,55.891498117173775]] */
// class vc
var arrayObj = [String:Any]()
var arrayDict = [[String:Double]]()

/// MARK class ViewController Section
class ViewController: UIViewController,ButtonDelegate, CLLocationManagerDelegate {
    /// MARK Section navigate
    lazy var navigationManager = NMANavigationManager.sharedInstance()

    /// MARK Variable section
    var tempArray = [NMAGeoCoordinates]()
    var obRoute : [NMAGeoCoordinates]?
    let bottomSheets = BottomSheetViewController()
    //
    var _drone_route_1 = routes()
    var _drone_route_2 = routes()
    var _drone_route_3 = routes()
    // MapProperties
    var idArea = 0
    var end_area = ""
    var shape = ""
    var boxik : NMAGeoBoundingBox?

    var polyX = [Double]()
    var polyY = [Double]()
    //
    let zoomLevel : Float = 15
    var index_touch = Int()
    var index_placed = Int()
    // def values
    private var geoBox1 : NMAGeoBoundingBox?
    private var geoPolyline : NMAMapPolyline?
    private var mapCircle : NMAMapCircle?
    var timeNewRoute = Timer()
    //     var obj = track_info()
    var piplInePoint = [arrayObj]
    public var coordSystemHeli = [NMAGeoCoordinates]()
    public var computeRoute = [NMAGeoCoordinates]()
    var myCordinate = NMAGeoCoordinates()
    //
    var coreRouter: NMACoreRouter!
    //
    var routeNav : NMARoute?
    private var geoBoundingBox : NMAGeoBoundingBox?
    var mapRouteNav : NMAMapRoute?
    var mapRouts = [NMAMapRoute]()
    var progress: Progress? = nil
    //
    var route = [NMAGeoCoordinates]()
    //
    let onPan = UIImage(named: "pin_s.png")
    let downPan = UIImage(named: "pin_e.png")
    let LeftUp = UIImage(named: "1.png")
    let RightUp = UIImage(named: "2.png")
    let RightDown = UIImage(named: "3.png")
    let LeftDown = UIImage(named: "4.png")
    let drone_ui = UIImage(named: "drone_svg_tf.png")
    let waypoint_ui = UIImage(named: "way-x_2.png")
    var objSelect = objectSelectedUsers()
    var arrayObjSelect = [Any]()
    var obj = objpost()
    var locObj = [String:Any]()
    var timeGeoPosition = Timer()
    var timeGeoPositionChild = Timer()
    var timerTeleBus = Timer()
    let areCheking =
    /*1*/       [NMAGeoCoordinates(latitude: 55.76238, longitude: 37.61084, altitude: 10),
    /*2*/        NMAGeoCoordinates(latitude: 55.75794, longitude: 37.60277, altitude: 10),
    /*3*/        NMAGeoCoordinates(latitude: 55.75040, longitude: 37.60054, altitude: 10),
    /*4*/        NMAGeoCoordinates(latitude: 55.74499, longitude: 37.60723, altitude: 10),
    /*5*/        NMAGeoCoordinates(latitude: 55.74480, longitude: 37.61581, altitude: 10),
    /*6*/        NMAGeoCoordinates(latitude: 55.75137, longitude: 37.61238, altitude: 10),
    /*7*/        NMAGeoCoordinates(latitude: 55.75774, longitude: 37.61908, altitude: 10),
    /*8*/        NMAGeoCoordinates(latitude: 55.75504, longitude: 37.62302, altitude: 10),
    /*9*/        NMAGeoCoordinates(latitude: 55.74837, longitude: 37.63212, altitude: 10),
    /*10*/       NMAGeoCoordinates(latitude: 55.75697, longitude: 37.63521, altitude: 10),
    /*11*/       NMAGeoCoordinates(latitude: 55.76325, longitude: 37.61599, altitude: 10),
    /*12*/       NMAGeoCoordinates(latitude: 55.76238, longitude: 37.61084, altitude: 10)]
    var testRoute = [ NMAGeoCoordinates(latitude: 55.89138380688599, longitude: 37.54329800605774),
                      NMAGeoCoordinates(latitude: 55.89074306140778, longitude: 37.5432550907135),
                      NMAGeoCoordinates(latitude: 55.8907550942842, longitude: 37.54386126995086),
                      NMAGeoCoordinates(latitude: 55.89076411893906, longitude: 37.544381618499756),
                      NMAGeoCoordinates(latitude: 55.89076712715686, longitude: 37.5444620847702),
                      NMAGeoCoordinates(latitude: 55.891498117173775, longitude: 37.544424533843994)]
    // Corelocation
    let locationManager = CLLocationManager()
    //
    var tempPositin : CLLocationCoordinate2D!
    //  private var mapCircle : NMAMapCircle?
      //
      // UIColor(displayP3Red: 0.6, green: 0.8, blue: 1, alpha: 0.6)
      //
    /// MARK IBOutlet  section
    // TableView Properties
    @IBOutlet var polyCount : UILabel!
    @IBOutlet var polyDetec : UILabel!
    @IBOutlet var status: UITextField!
    @IBOutlet weak var mapHere: NMAMapView!
    @IBOutlet var alertCard: CardView!
    @IBOutlet weak var pandrawIcon: UIButton!
    @IBOutlet var drawPolyV: CardView!
    @IBOutlet var drawCircleV: CardView!
    @IBOutlet var drawRouteV: CardView!
    @IBOutlet var drawMyLocation : CardView!
    @IBOutlet var Label_button: UIButton!
    @IBOutlet var drawPoly: UIButton!
    @IBOutlet var drawCircle: UIButton!
    @IBOutlet var drawRoute: UIButton!
    @IBOutlet var LocationMyHere: UIButton!
    @IBOutlet var DrawZone: CardView!
    @IBOutlet var typeDrawZone: CardView!
    /// MARK method section
    func onButtonTap(sender: UIButton) {
        setLocate()
    }
    /// MARK  viewDidlLoad section
    override func viewDidLoad() {
        super.viewDidLoad()
        addBottomSheetView()
        // section Notification
        /// #1
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setLocate),
                                               name: NSNotification.Name("SetLocation"),
                                               object: nil)
        /// #2
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shapeDraw),
                                               name: NSNotification.Name("DrawShape"),
                                               object: nil)
        /// #3
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(shapeDraw),
                                               name: NSNotification.Name("DrawCircle"),
                                               object: nil)
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Route AR"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.alertCard.backgroundColor = #colorLiteral(red: 0.8823654819, green: 0.8115270822, blue: 0.578507819, alpha: 0.5)
        self.index_touch = 0
        self.index_placed = 1
       // self.loadArea()
        DispatchQueue.global(qos: .userInitiated).async {
            self.loadArea()
        }
        self.mapHere.MapInit()
        bottomSheets.delegate = self
        self.mapHere.gestureDelegate = self
        //self.mapHere.mapScheme = NMAMapSchemeHybridDay
        coreRouter = NMACoreRouter()
        // tpos
        NMAPositioningManager.sharedInstance().dataSource = NMAHEREPositionSource()
        NotificationCenter.default.addObserver(self,
                                                selector: #selector(ViewController.didUpdatePosition),
                                                name: NSNotification.Name.NMAPositioningManagerDidUpdatePosition,
                                                object: NMAPositioningManager.sharedInstance())
        let  myPosition = NMAPositioningManager.sharedInstance().currentPosition
       // self.trackingTimer()
       // self.trackingTimerChild()
        self.zoneObject(id: 1, geo: NMAGeoCoordinates(latitude: 55.79510365474969, longitude: 37.55457465864718), type: "home")
        self.zoneObject(id: 2, geo: NMAGeoCoordinates(latitude: 55.80510365474969, longitude: 37.52457465864718), type: "school")
        self.zoneObject(id: 3, geo: NMAGeoCoordinates(latitude: 55.76510365474969, longitude: 37.50457465864718), type: "home")
        self.zoneObject(id: 4, geo: NMAGeoCoordinates(latitude: 55.83510365474969, longitude: 37.49457465864718), type: "school")
        self.zoneObject(id: 5, geo: NMAGeoCoordinates(latitude: 55.82510365474969, longitude: 37.45457465864718), type: "home")
        self.zoneObject(id: 6, geo: NMAGeoCoordinates(latitude: 55.85510365474969, longitude: 37.37457465864718), type: "school")
        self.zoneObject(id: 7, geo: NMAGeoCoordinates(latitude: 55.806611, longitude: 37.652319), type: "school")
        
        let newArray = [NMAGeoCoordinates(latitude: 55.75223581897627, longitude: 38.03672790527344),
                        NMAGeoCoordinates(latitude: 55.74953074789918, longitude: 37.967376708984375),
                        NMAGeoCoordinates(latitude: 55.72556335763928, longitude: 38.20976257324219),
                        NMAGeoCoordinates(latitude: 55.75146296066621, longitude: 37.89459228515625),
                        NMAGeoCoordinates(latitude: 55.7398682484427, longitude: 38.16032409667969),
                        NMAGeoCoordinates(latitude: 55.75880449639896, longitude: 38.069000244140625)]
        
        let drone_route_1 = NMAGeoCoordinates(latitude: 55.7487578359952, longitude: 37.72499084472656)
        let drone_route_2 = NMAGeoCoordinates(latitude: 55.74634238759795, longitude: 37.606201171875)
        let drone_route_3 = NMAGeoCoordinates(latitude: 55.75223581897627, longitude: 37.6226806640625)
        let route_drone_route_1 = [NMAGeoCoordinates(latitude: 55.70274201066954, longitude: 37.606201171875),
                                   NMAGeoCoordinates(latitude: 55.69732481849101, longitude: 37.61787414550781),
                                   NMAGeoCoordinates(latitude: 55.68881057085534, longitude: 37.61787414550781),
                                   NMAGeoCoordinates(latitude: 55.67642290029142, longitude: 37.61787414550781),
                                   NMAGeoCoordinates(latitude: 55.665580469670985, longitude: 37.621307373046875),
                                   NMAGeoCoordinates(latitude: 55.66015812760702, longitude: 37.635040283203125),
                                   NMAGeoCoordinates(latitude: 55.65705930913831, longitude: 37.643280029296875),
                                   NMAGeoCoordinates(latitude: 55.650086070637734, longitude: 37.65632629394531),
                                   NMAGeoCoordinates(latitude: 55.63846124636454, longitude: 37.65495300292969),
                                   NMAGeoCoordinates(latitude: 55.62760829717496, longitude: 37.66456604003906),
                                   NMAGeoCoordinates(latitude: 55.62799595426723, longitude: 37.657012939453125),
                                   NMAGeoCoordinates(latitude: 55.62373151534754, longitude: 37.65769958496094),
                                   NMAGeoCoordinates(latitude: 55.617915623580316, longitude: 37.659759521484375),
                                   NMAGeoCoordinates(latitude: 55.610547588603886, longitude: 37.6666259765625),
                                   NMAGeoCoordinates(latitude: 55.60123861794095, longitude: 37.67280578613281),
                                   NMAGeoCoordinates(latitude: 55.591151406351784, longitude: 37.676239013671875),
                                   NMAGeoCoordinates(latitude: 55.63846124636454, longitude: 37.65495300292969),
                                   NMAGeoCoordinates(latitude: 55.62760829717496, longitude: 37.66456604003906),
                                   NMAGeoCoordinates(latitude: 55.62799595426723, longitude: 37.657012939453125),
                                   NMAGeoCoordinates(latitude: 55.62373151534754, longitude: 37.65769958496094),
                                   NMAGeoCoordinates(latitude: 55.617915623580316, longitude: 37.659759521484375),
                                   NMAGeoCoordinates(latitude: 55.610547588603886, longitude: 37.6666259765625),
                                   NMAGeoCoordinates(latitude: 55.60123861794095, longitude: 37.67280578613281),
                                   NMAGeoCoordinates(latitude: 55.591151406351784, longitude: 37.676239013671875)]

        let route_drone_route_2 = [NMAGeoCoordinates(latitude: 55.70274201066954, longitude: 37.606201171875),
                                   NMAGeoCoordinates(latitude: 55.74634238759795, longitude: 37.61272430419922),
                                   NMAGeoCoordinates(latitude: 55.74697041856728, longitude: 37.6146125793457),
                                   NMAGeoCoordinates(latitude: 55.74755013048941, longitude: 37.61693000793457),
                                   NMAGeoCoordinates(latitude: 55.74803321717797, longitude: 37.61924743652343)]
        let route_drone_route_3 = [NMAGeoCoordinates(latitude: 55.70274201066954, longitude: 37.606201171875),
                                   NMAGeoCoordinates(latitude: 55.75230827365778, longitude: 37.70413398742676),
                                   NMAGeoCoordinates(latitude: 55.75199430239924, longitude: 37.70516395568848),
                                   NMAGeoCoordinates(latitude: 55.75160787276572, longitude: 37.70602226257324),
                                   NMAGeoCoordinates(latitude: 55.75112483034055, longitude: 37.706923484802246)]
        _drone_route_1 = routes(id: 1, coordinates: route_drone_route_1)
        _drone_route_2 = routes(id: 2, coordinates: route_drone_route_2)
        _drone_route_3 = routes(id: 3, coordinates: route_drone_route_3)
        arrayBusMove.append(self.drone(drone_route_1,_drone_route_2))
        arrayBusMove.append(self.drone(drone_route_2,_drone_route_2))
        arrayBusMove.append(self.drone(drone_route_3,_drone_route_1))
        self.routeBusDraw()
//        self.timerTelematics()
//        self.initCoreLocation()
         /*for arr in newArray {
            self.drone(arr, testRoutes)
         }*/
         /*for point in testRoute {
                  arrayARObject.append(point)
        }*/
        navigationManager.delegate = self
        navigationManager.isSpeedWarningEnabled = true
}
    
/// MARK IBAction Section
    @IBAction func panDraw(_ sender: Any) {
        if panDrawLine == "Inactivate" {
            pandrawIcon.setImage(downPan, for: .selected)
            panDrawLine = "Activate"
        } else {
            pandrawIcon.setImage(onPan, for: .disabled)
            panDrawLine = "Inactivate"
        }
    }
    @IBAction func first_user(_ sender: Any) {
        id_user = 1
    }
    @IBAction func two_user(_ sender: Any) {
        id_user = 2
    }
    @IBAction func StartKikcLoc(_ sender: Any) {
        let button = sender as! UIButton
        if button == LocationMyHere {
            if button.currentTitle == "OFF" {
                button.setTitle("ON", for: .normal)
                let track = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
                drawMyLocation.backgroundColor = track
                self.trackingTimer()
            } else {
                button.setTitle("OFF", for: .normal)
                let stop = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
                drawMyLocation.backgroundColor = stop
                self.stopTracking()
                var fillArea = [NMAGeoCoordinates]()
                //
                for objectField in piplInePoint {
                    fillArea.append(NMAGeoCoordinates(latitude: objectField["latitude"] as! Double,
                                                      longitude: objectField["longitude"] as! Double))
                }
                let color_F = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                let color_L = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                self.drawPolygonInMap(fillArea,color_F,color_L)
            }
        }
        
    }
     @IBAction func StartPoly(_ sender: Any)
        {
            let colorPoly = #colorLiteral(red: 0.7450980392, green: 0.3098039216, blue: 0.3215686275, alpha: 0.65)
            let button = sender as! UIButton
            if button == drawPoly {
                if button.currentTitle == "Draw Poly" {
                       end_area = "start"
                       shape = "poly"
                       button.setTitle("Draw Finish", for: .normal)
                       } else if button.currentTitle == "Draw Finish"{
                       button.setTitle("Draw Poly", for: .normal)
                       end_area = "end"
                       shape = "poly"
                          //
                           //arrayObjSelect.append(objSelect)
                           //arrayObjSelect as! [objectSelectedUsers]
                           objSelect.frame = array_area.frame_area
                           let last =  array_area.frame_area[0]
                           array_area.frame_area.append(last)
                           //arrayObjSelect.append(array_area.frame_area)
                           objSelect.id = arrayObjSelect.count + 1
                           objSelect.header = "no way this zone"
                          // objSelect.frame = array_area.frame_area//arrayObjSelect as! [NMAGeoCoordinates]
                           arrayObjSelect.append(objSelect)
                           arrayObjSelect as! [objectSelectedUsers]
                           polyCount.text! = "Poly in map : \(arrayObjSelect.count)"
                           print(arrayObjSelect)
                    self.createPolyline(CTR: array_area.frame_area, colorPoly, 3, isShow: true)
                    //
                  
                    //
                        let color_F = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                        let color_L = #colorLiteral(red: 0.1529411765, green: 0, blue: 1, alpha: 1)
                        self.drawPolygonInMap(array_area.frame_area,color_F,color_L)
                        print(array_area.frame_area)
                        array_area.frame_area.removeAll()
                       }
            } else if button == drawCircle {
                if button.currentTitle == "Draw Circle" {
                end_area = "start"
                shape = "circle"
                button.setTitle("Draw Finish", for: .normal)
                } else if button.currentTitle == "Draw Finish"{
                button.setTitle("Draw Circle", for: .normal)
                end_area = "end"
                shape = "circle"
            }
        }
    }
        @IBAction func DrawPanel(_ sender: Any) {
            self.stopTracking()
            if  self.drawPolyV.isHidden == true
                {
                self.drawPolyV.isHidden = true
                self.drawCircleV.isHidden = true
                self.drawRouteV.isHidden = true
                } else {
                self.drawPolyV.isHidden = false
                self.drawCircleV.isHidden = false
                self.drawRouteV.isHidden = false
            }
            
        }
        @IBAction func postPoly(_ sender: Any) {
          //  post(url: "https://servchild.vapor.cloud/api/location/polygon", parametrs: locObj)
      //      print("f")
        }
        @IBAction func setMyPos(_ sender: Any) {
            let latTracking = (NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.latitude)!
            let lonTracking = NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.longitude
            self.mapHere.set(geoCenter: NMAGeoCoordinates(latitude: latTracking, longitude: lonTracking!), zoomLevel: 15, orientation: 35, tilt: 0, animation: .none)//(geoCenter: NMAGeoCoordinates(latitude: latTracking, longitude: lonTracking!), animation: .none)
            self.findIntersectionOfCircle()
        }
        @IBAction func getLocation(_ sender: Any) {
            self.getLive()
        }
        @IBAction func startMoveBus(_ sender: Any) {
           self.timerTelematics()
            /*arrayBus.removeAll()
            // add new pos drone
            for ts in arrayBusMove {
                self.moveBusic(ts)
            }
            arrayBusMove.removeAll()
            self.routeBusDraw() */
        }
        @IBAction func getPoint(_ sender: Any) {
            let image = "https://image.maps.api.here.com/mia/1.6/mapview?app_id=0ZZSBa9QPnfBc8zgJC1p&app_code=R7UJ1isf9yaZLiV058KZoQ&lat=55.86&lon=38.402277&vt=0&z=15"
         //   getImage(url: image)
        }
        @IBAction func selectTypeDraw(_ sender: Any)
        {
            self.DrawZone.isHidden = true
            self.typeDrawZone.isHidden = false
        }
    
        @IBAction func drawOffsetPoint(_ sender: Any) {
            let pointXColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            let pointYColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            if arrayColisionPoint.isEmpty != true {
                self.createCircle(geoCoord: testXPoint!, color: pointXColor, rad: Int(1.5))
                          for point in arrayColisionPoint {
                              self.createCircle(geoCoord: point, color: pointYColor, rad: Int(1.5))
                          }
            }
          
            
            let GPSColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            let ARColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
              if arrayGPS.isEmpty != true &&  arrayAR.isEmpty != true {
                self.createPolyline(CTR: toNMAArray(array: arrayGPS), GPSColor, 2, isShow: true)
                self.createPolyline(CTR: toNMAArray(array: arrayAR), ARColor, 2, isShow: true)
                }
              
            if arrayNewRoute.isEmpty != true {
                let colorRYan = #colorLiteral(red: 0.7233391637, green: 0.1817918539, blue: 0.1189745283, alpha: 1)
                let arrayYA = YAMtoNMA(array: arrayNewRoute)
                let objectRoute = self.addDash(route: arrayYA, color: colorRYan)
                arrayARObjectYAM = arrayYA
                layerRoute3 = objectRoute.0
                layerRoute4 = objectRoute.1
                self.mapHere.add(mapObjects: layerRoute3)
                self.mapHere.add(mapObjects: layerRoute4)
            }
            
        }
    func YAMtoNMA(array : [YMKPoint]) -> [NMAGeoCoordinates] {
        var newArray = [NMAGeoCoordinates]()
        for ar in array {
            newArray.append(NMAGeoCoordinates(latitude: ar.latitude, longitude: ar.longitude))
        }
        return newArray
    }
    @IBAction func YMKView(_ sender: Any) {
        let storyboardName = "YMKView"
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let initialViewController = storyboard.instantiateInitialViewController()
            self.navigationController!.pushViewController(initialViewController!, animated: true)
        }
    /// [Coordinate ] to [NMAGeoCoordinates]
    func toNMAArray(array : [Coordinate]) -> [NMAGeoCoordinates] {
        var arrayNMA = [NMAGeoCoordinates]()
        for pg in array {
            arrayNMA.append(NMAGeoCoordinates(latitude: pg.lat, longitude: pg.lon))
        }
        return arrayNMA
    }
    /// MARK Methods Section
    // methods corelocation 1
    func initCoreLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    // MARK
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else {
            return
        }
        print(coordinates)
        if tempPositin != nil {
        if (coordinates.longitude != tempPositin.longitude) && ( coordinates.latitude != tempPositin.latitude) {
        let posColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let posColorPoint = #colorLiteral(red: 0.05877232786, green: 0.8862745166, blue: 0.8009906314, alpha: 0.5)
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude:  coordinates.latitude as! Double,
                                                      longitude: coordinates.longitude as! Double),
                                                      color: posColor,
                                                      rad: Int(0.5))
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude:  coordinates.latitude as! Double,
                                                      longitude: coordinates.longitude as! Double),
                                                      color: posColorPoint,
                                                      rad: Int(1.0))
            }
        }
        tempPositin = coordinates
    }
    // MARK
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        progress?.cancel()
    }
    /// MARK section @objc
    @objc func didUpdatePosition() {
       guard let position = NMAPositioningManager.sharedInstance().currentPosition,
           let coordinates = position.coordinates else {
               return
       }
   }
    @objc  func TrackingMyPosition() {
    var cerror: String = "empty"
    if NMAPositioningManager.sharedInstance().currentPosition?.coordinates != nil {
    //         let networkInfo = CTTelephonyNetworkInfo()
            //
           /*     if #available(iOS 11.0, *) {
                    let back_info = networkInfo.serviceSubscriberCellularProviders
                    //print(back_info)
                }
                else {
                    let back_info = networkInfo.subscriberCellularProvider
                    //print(back_info)
                }
            //
            let radio_info = networkInfo.serviceCurrentRadioAccessTechnology
            let level_info = radio_info?.values
            for name_carrier in level_info! {
            cerror = name_carrier
            }
                    if cerror == "CTRadioAccessTechnologyLTE" {
        //                print("CTRadioAccessTechnologyLTE")
                    } else if cerror == "CTRadioAccessTechnologyWCDMA" {
        //                print("CTRadioAccessTechnologyWCDMA")
                    } else if cerror == "CTRadioAccessTechnologyEdge" {
        //                print("CTRadioAccessTechnologyEdge")
                    } */
        obj.cellor = cerror
        let latTracking = NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.latitude
        let lonTracking = NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.longitude
        obj.latitude = latTracking!
        obj.longitude = lonTracking!
        //
    if last.latitude != 0 && last.longitude != 0 {
        let diff = distanceGeo(pointA: NMAGeoCoordinates(latitude: obj.latitude,
                                                         longitude: obj.longitude),
                                                         pointB: NMAGeoCoordinates(latitude: last.latitude,
                                                                                   longitude: last.longitude))
        if diff > 2000 || diff < 2000 {
              //  mapHere.set(geoCenter: NMAGeoCoordinates(latitude: obj.latitude, longitude: obj.longitude), animation: .linear )
            }
        }
        //
        last.latitude = obj.latitude
        last.longitude = obj.longitude
        arrayObj["latitude"] = obj.latitude as Double
        arrayObj["longitude"] = obj.longitude as Double
        arrayObj["cellor"] = obj.cellor
        piplInePoint.append(arrayObj)
        print(piplInePoint)
        let posColor = #colorLiteral(red: 0.8190373321, green: 0.5761176084, blue: 0.7793378884, alpha: 0.5)
        let posColorPoint = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude:  arrayObj["latitude"] as! Double,
                                                      longitude: arrayObj["longitude"] as! Double),
                          color: posColor,
                          rad: Int(1.5))
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude:  arrayObj["latitude"] as! Double,
                                                      longitude: arrayObj["longitude"] as! Double),
                          color: posColorPoint,
                          rad: Int(0.5))
        //post(url: "https://droneservice.herokuapp.com/location/", parametrs: ["lon":arrayObj["longitude"] as! Double,"lat":arrayObj["latitude"] as! Double])
        patch(url: "https://droneservice.herokuapp.com/tracking/1" /*"http://127.0.0.1:8080/tracking/1"*/,
            parametrs: ["lon":arrayObj["longitude"] as! Double,"lat":arrayObj["latitude"] as! Double])
        //post(url: "https://servchild.vapor.cloud/api/location/live", parametrs: arrayObj)

       var statusL = ckeckPoint(checkPoint: NMAGeoCoordinates(latitude: arrayObj["latitude"] as! Double,
                                                              longitude: arrayObj["longitude"] as! Double))
        print("\(statusL) - ptmp")
        if statusL!.status == true {
            self.alertCard.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            if (self.alertCard.isHidden == true) {
                self.alertCard.isHidden = false
            } else {
                self.alertCard.isHidden = true
            }
        } else {
             self.alertCard.backgroundColor = #colorLiteral(red: 0.8823654819, green: 0.8115270822, blue: 0.578507819, alpha: 0.5)
        }
        polyDetec.text! = "\(statusL!.id_obj) - \(statusL!.status)"
        //  print(arrayObj)
    }
}
    @objc  func TrackingChildPosition() {
        getLive()
    }
    @objc func telematiksBus() {
       //self.timerTelematics()
              arrayBus.removeAll()
              // add new pos drone
              for i in 0...arrayBusMove.count - 1  {
                  self.moveBusic(arrayBusMove[i], i)
              }
              self.routeBusDraw()
    }
     @objc func shapeDraw(_ sender: Any)
            {
                let colorPoly = #colorLiteral(red: 0.7450980392, green: 0.3098039216, blue: 0.3215686275, alpha: 0.65)
                let button = sender as! NSNotification
               
                if button.name.rawValue == "DrawShape" {
    /*if button.currentTitle == "Draw Poly" {
                           end_area = "start"
                           shape = "poly"
                           button.setTitle("Draw Finish", for: .normal)
                           } else if button.currentTitle == "Draw Finish"{
                           button.setTitle("Draw Poly", for: .normal)
                           */
                    if  button.object as! String == "Start" {
                            end_area = "start"
                           shape = "poly"
                    } else {
                    
                              end_area = "end"
                              shape = "poly"
                              //
                      //  if array_area.frame_area.count > 0 {
                               //arrayObjSelect.append(objSelect)
                               //arrayObjSelect as! [objectSelectedUsers]
                               objSelect.frame = array_area.frame_area
                               let last =  array_area.frame_area[0]
                               array_area.frame_area.append(last)
                               //arrayObjSelect.append(array_area.frame_area)
                               objSelect.id = arrayObjSelect.count + 1
                               objSelect.header = "no way this zone"
                              // objSelect.frame = array_area.frame_area//arrayObjSelect as! [NMAGeoCoordinates]
                               arrayObjSelect.append(objSelect)
                               arrayObjSelect as! [objectSelectedUsers]
                               polyCount.text! = "Poly in map : \(arrayObjSelect.count)"
                               print(arrayObjSelect)
                        self.createPolyline(CTR: array_area.frame_area, colorPoly, 3, isShow: true)
                        //arrayVert
                        var onew = array_area.frame_area
                        print(onew)
                        for ar in onew {
                            let toDict = ["lat": ar.latitude,
                                          "lot": ar.longitude]
                            arrayDict.append(toDict)
                        }
                        let newRow = ["altitude": 400, "id": 2, "positionID": 1, "username": "Green", "locate": arrayVert] as [String : Any]
                       
                        var data = [["lat":43.4,"lot":34.3],["lat":43.4,"lot":34.3],["lat":43.4,"lot":34.3]]
                        post(url: "https://droneservice.herokuapp.com/users/" /*"http://127.0.0.1:8080/users"*/, parametrs: ["altitude": 100,/*"id": 7,*/ "positionID": 1, "username": "Green", "locate": arrayDict])
                        //
                      
                        let color_F = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
                        let color_L = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                            self.drawPolygonInMap(array_area.frame_area,color_F,color_L)
                            print(array_area.frame_area)
                            arrayDict.removeAll()
                            array_area.frame_area.removeAll()
                     //   }
                    }
                } else if button.name.rawValue == "DrawCircle" {
                        if button.object as! String == "Start" {
                        end_area = "start"
                        shape = "circle"
                        } else {
                        end_area = "end"
                        shape = "circle"
                    }
                }
        }
    /// MARK Timer() Section
    func timerTelematics() {
    timerTeleBus.invalidate()
    timerTeleBus = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: Selector("telematiksBus"), userInfo: nil, repeats: true)
    }
    func moveBusic(_ input_drone : NMAMapMarker, _ idx : Int) {
        self.clear_drone(input_drone)
        let lat = input_drone.coordinates.latitude
        let lon = input_drone.coordinates.longitude
        arrayBusMove[idx] = self.drone(NMAGeoCoordinates(latitude: lat + 0.00025, longitude: lon + 0.00015), _drone_route_2)
    }
    //}
             /*else if button == drawCircle {
                if button.currentTitle == "Draw Circle" {
                end_area = "start"
                shape = "circle"
                button.setTitle("Draw Finish", for: .normal)
                } else if button.currentTitle == "Draw Finish"{
                button.setTitle("Draw Circle", for: .normal)
                end_area = "end"
                shape = "circle"
            }
    } */
}

extension NMAMapView : quaklyInit {
    // MARK 1
    func MapInit() {
        self.copyrightLogoPosition = NMALayoutPosition.bottomLeft
        self.orientation = 35
        self.mapScheme = NMAMapSchemeNormalNightTransit//NMAMapSchemeNormalDay
        self.positionIndicator.isVisible = true
        let geoCoodCenter = NMAGeoCoordinates(
        latitude: 55.812619,
        longitude: 37.572213)
        self.set(geoCenter: geoCoodCenter, animation: .none)
    }
}
extension ViewController {
     
    public func createCircle(geoCoord : NMAGeoCoordinates, color : UIColor,rad : Int) {
        //create NMAMapCircle located at geo coordiate and with radium in meters
        mapCircle = NMAMapCircle(geoCoord, radius: Double(rad))
        //set fill color to be gray
        mapCircle?.fillColor = color
        //set border line width.
        mapCircle?.lineWidth = 12;
        //set border line color to be red.
        mapCircle?.lineColor = color
        //add Map Circel to map view
        
        _ = mapCircle.map{ mapHere.add(mapObject: $0)
        
        }
    }
    func trackingTimer() {
        piplInePoint.removeAll()
        timeGeoPosition.invalidate()
        timeGeoPosition = Timer.scheduledTimer(timeInterval: 2, target: self, selector: Selector("TrackingMyPosition"), userInfo: nil, repeats: true)
    }
    func stopTracking() {
        print("pipe\(piplInePoint)")
        timeGeoPosition.invalidate()
    }
    func trackingTimerChild() {
    timeGeoPositionChild.invalidate()
        timeGeoPositionChild = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: "TrackingChildPosition", userInfo: nil, repeats: true)
    }
}
extension ViewController {
    // draw segment Line
    public func createPolyline(CTR : [NMAGeoCoordinates],_ color : UIColor , _ width : Int, isShow : Bool) -> NMAMapPolyline {
        // cleanup()
        //create a NMAGeoBoundingBox with center gec coordinates, width and hegiht in degrees.
        geoBox1 = NMAGeoBoundingBox(coordinates: CTR)
        geoPolyline = geoBox1.map{ _ in NMAMapPolyline(vertices: CTR) }
        //set border line width in pixels
        geoPolyline?.lineWidth = UInt(width);
        //set border line color to be red
        geoPolyline?.lineColor = color//UIColor(displayP3Red: 0.6, green: 0.8, blue: 1, alpha: 0.6)
        //add NMAMapPolyline to map view
        if isShow == true {
            _ = geoPolyline.map { mapHere?.add(mapObject: $0) }
        }
        return geoPolyline!
    }
    // draw polygon
    public func drawPolygonInMap(_ points : [NMAGeoCoordinates],_ fillClr : UIColor,_ fillLnr : UIColor) {
        let polygonDraw = drawPolygonWithPoints(centrBox: points, fillClr: fillClr, fillLnr: fillLnr)
        polygonDraw.map{mapHere.add(mapObject: $0)}
    }
    // draw label object
    public func drawLabel(_ GeoCoord : NMAGeoCoordinates,_ Text : String) {
        var leb = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 60))
                   leb.text = Text
                   leb.textColor = UIColor.brown
                   let label = NMAMapOverlay(leb, GeoCoord)
                   self.mapHere.add(mapOverlay: label)
        
    }
    // draw route with segment
    enum typeLine : String {
        case normal = "Normal"
        case dash = "Dash"
    }
    
    
    func LineRoute(_ points : [NMAGeoCoordinates],_ color : UIColor, _ type : String) -> [NMAMapPolyline] {
        var arrayLine = points
        if type == "Normal" {
            var array = [NMAMapPolyline]()
            let mainLine = self.createPolyline(CTR:arrayLine, color, 10, isShow: false)
            let subLine = self.createPolyline(CTR:arrayLine, UIColor.black, 4, isShow: false)
            array.append(mainLine)
            array.append(subLine)
            return array
        } else {
            //
            let middleColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            let size = arrayLine.count
            var i = 0
            for i in 0...size - 2 {
                           let fCoordLat = arrayLine[size - 2 - i].latitude
                           let eCoordLat = arrayLine[size - 1 - i].latitude
                           let fCoordLot = arrayLine[size - 2 - i].longitude
                           let eCoordLot = arrayLine[size - 1 - i].longitude
                           let deltaLat = (eCoordLat - fCoordLat)/2
                           let deltaLot = (eCoordLot - fCoordLot)/2
            let j = 1
            let medlPos = NMAGeoCoordinates(latitude: deltaLat*Double(j)+fCoordLat, longitude: deltaLot*Double(j)+fCoordLot, altitude: 10)
                arrayLine[size - 1] = medlPos
                self.createCircle(geoCoord: medlPos, color: middleColor, rad: Int(2.5))
            }
            var array = [NMAMapPolyline]()
            let mainLine = self.createPolyline(CTR:points, color, 20, isShow: true)
            let subLine = self.createPolyline(CTR:arrayLine, UIColor.black, 4, isShow: true)
            array.append(mainLine)
            array.append(subLine)
            return array
        }
        //return array
    }
}


extension ViewController {
    func getLive() {
     //   if NMAPositioningManager.sharedInstance().currentPosition?.coordinates != //nil {
     get(url: "https://droneservice.herokuapp.com/location/")
    //    }
    }
    func updateMapAR() {
        if currentPosMap != nil {
            let usrlImage = "https://image.maps.ls.hereapi.com/mia/1.6/mapview?apiKey=JdbJa6yZk5MljMzUe9bUO8X8FpHsF02J7UdmHY6hoKs&i&c=\(currentPosMap!.latitude),\(currentPosMap!.longitude)&h=200&w=300&r=50"
                
                self.getImage(url: usrlImage)
        }
    }
     @objc func setLocate() {
        
        guard let latTracking =             NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.latitude,
              let lonTracking = NMAPositioningManager.sharedInstance().currentPosition?.coordinates?.longitude else { return }
        
        
        self.mapHere.set(geoCenter: NMAGeoCoordinates(latitude: latTracking       , longitude: lonTracking), zoomLevel: 15, orientation: 35, tilt: 0, animation: .none)
           let googleImage = "https://homenew.su/pic/electrostal/retro/alleya_na_prospekte_lenina_icon.jpg"
           self.updateMapAR()
           self.getImageGoogle(url: googleImage)
       
            //   self.findIntersectionOfCircle()
            //   self.trackingTimer()
            //   self.mapHere.mapScheme = NMAMapSchemeNormalNightTransit
        //self.loadArea()
        let color_AR = #colorLiteral(red: 0.2259057358, green: 0, blue: 0.9343965381, alpha: 1)
        let color_AR_line = #colorLiteral(red: 0.9343965381, green: 0.3316142686, blue: 0.2559086703, alpha: 0.7)
        let color_F = #colorLiteral(red: 0.5641394106, green: 0.4630807016, blue: 0.193962343, alpha: 0.54)
        let color_L = #colorLiteral(red: 0.1529411765, green: 0, blue: 1, alpha: 0.4105413732)
        var array = [NMAGeoCoordinates]()
        if areas != nil {
        for l in areas {
            for k in l.locate {
                array.append(NMAGeoCoordinates(latitude: k.lat, longitude: k.lot, altitude: 1))
                //arrayARObject.append(NMAGeoCoordinates(latitude: k.lat, longitude: k.lot, altitude: 1))
                self.createCircle(geoCoord: NMAGeoCoordinates(latitude: k.lat, longitude: k.lot, altitude: 1),color: color_AR,rad: Int(1))
                //array.append(array[0])
            }
            if l.positionID == 2 {
                self.createPolyline(CTR: array, color_AR_line, 6, isShow: true)
            } else if l.positionID == 1 {
                self.drawPolygonInMap(array,color_F,color_L)
            }
            array.removeAll()
            print(array)
           
            
            }
        } else {print("no: areas")}
        // MARK init scene
        let color_start = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 0.5)
        let color_view = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude: 55.79059240191234, longitude:  38.44084188862678), color: color_start, rad: 5)
        self.createCircle(geoCoord: NMAGeoCoordinates(latitude: 55.79059240191234, longitude:  38.44084188862678), color: color_view, rad: 2)
    }
    @IBAction func changeShema(_ sender: Any){
        self.setLocate()
    }
}


/// MARK 6 addBottomSheet
extension ViewController {
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(false)
       //    addBottomSheetView()
       }
    func addBottomSheetView() {
             // 1- Init bottomSheetVC
             let storyboard : UIStoryboard = UIStoryboard(name: "BottomSheet", bundle: nil)
             let bottomsheet : UIViewController =  storyboard.instantiateViewController(withIdentifier: "BottomSheet") as! BottomSheetViewController// ViewController()
             let bottomSheetVC = bottomsheet//BottomSheetViewController()
             // 2- Add bottomSheetVC as a child view
             self.addChild(bottomSheetVC)
             self.view.addSubview(bottomSheetVC.view)
             bottomSheetVC.didMove(toParent: self)

             // 3- Adjust bottomSheet frame and initial position.
             let height = view.frame.height
             let width  = view.frame.width
             bottomSheetVC.view.frame = CGRect(x:  self.view.frame.maxX, y: 0/*self.view.frame.maxY/2*/, width: width/4, height: height)
         }
}
extension ViewController : NMANavigationManagerDelegate {

    func navigationManagerWillReroute(_ navigationManager: NMANavigationManager) {
        
    }

    func navigationManager(_ navigationManager: NMANavigationManager,
                           didUpdateRoute routeResult: NMARouteResult) {

        let result = routeResult
        guard let routes = result.routes, routes.count > 0 else {
            // The routeResult doesn't contain route for redraw.
            // It might occur when navigation stop was called.
            return
        }

        // Let's add the 1st result onto the map
        ///route = routes[0]
        self.updateMapRoute(with: routes.first)
    }

    func navigationManager(_ navigationManager: NMANavigationManager, didRerouteWithError error: NMARoutingError) {
        var message : String
        if error == NMARoutingError.none {
            message = "successfully"
        } else {
            message = "with error \(error)"
        }
       // showMessage("Navigation manager finished attempt to route " + message)
    }

    // Signifies that there is new instruction information available
    func navigationManager(_ navigationManager: NMANavigationManager,
                           didUpdateManeuvers currentManeuver: NMAManeuver?,
                           _ nextManeuver: NMAManeuver?) {
       // showMessage("New maneuver is available")
    }

    // Signifies that the system has found a GPS signal
    func navigationManagerDidFindPosition(_ navigationManager: NMANavigationManager) {
        //showMessage("New position has been found")
        print(navigationManager.currentManeuver?.coordinates
        )
    }
    func updateMapRoute(with route: NMARoute?) {
        // remove previously created map route from map
        if let previousMapRoute = mapRouteNav {
            mapHere.remove(mapObject:previousMapRoute)
        }

        guard let unwrappedRoute = routeNav else {
            return
        }

        mapRouteNav = NMAMapRoute(unwrappedRoute)
        mapRouteNav?.traveledColor = .clear
        _ = mapRouteNav.map{ mapHere?.add(mapObject: $0) }

        // In order to see the entire route, we orientate the
        // map view accordingly
        if let boundingBox = unwrappedRoute.boundingBox {
            geoBoundingBox = boundingBox
            mapHere.set(boundingBox: boundingBox, animation: .linear)
        }
    }

}
extension ViewController {
    // MARK: User actions
       func add() {
          navigationManager.stop()

          if !(NMAPositioningManager.sharedInstance().dataSource is NMADevicePositionSource) {
              NMAPositioningManager.sharedInstance().dataSource = nil
          }

          // Restore the map orientation to show entire route on screen
          geoBoundingBox.map{ mapHere.set(boundingBox: $0, animation: .linear) }
          mapHere.orientation = 0
          enableMapTracking(false)
          //navigationControlButton.setTitle("Start Navigation", for: .normal)

          routeNav = nil
          if mapRouteNav != nil {
              _ = mapRouteNav.map{ mapHere.remove(mapObject: $0) }
          }
          mapRouteNav = nil
          geoBoundingBox = nil
      }
 
    private func enableMapTracking(_ enabled: Bool) {
        navigationManager.mapTrackingAutoZoomEnabled = enabled
        navigationManager.mapTrackingEnabled = enabled
    }
     func startNavigation() {
          // Display the position indicator on map
          mapHere.positionIndicator.isVisible = true
          // Configure NavigationManager to launch navigation on current map
          navigationManager.map = mapHere

          let alert = UIAlertController(title: "Choose Navigation mode",
                                        message: "Please choose a mode",
                                        preferredStyle: .alert)

          //Add Buttons

          let deviceButton = UIAlertAction(title: "Navigation",
                                           style: .default) { [weak self] _ in

              guard let routeS = self?.routeNav else {
                  return
              }

              // Start the turn-by-turn navigation. Please note if the transport mode of the passed-in
              // route is pedestrian, the NavigationManager automatically triggers the guidance which is
              // suitable for walking.
              self?.startTurnByTurnNavigation(with: routeS, useSimulation: false)
          }
        let simulateButton = UIAlertAction(title: "Simulation",
                                                 style: .default) { [weak self] _ in

                  guard let routeN = self?.routeNav else {
                      return
                  }

                  self?.startTurnByTurnNavigation(with: routeN, useSimulation: true)
              }
        let canceledAction = UIAlertAction(title: "Отменить", style: .cancel) {
                   (_) -> Void in
               }

          alert.addAction(deviceButton)
                alert.addAction(simulateButton)
        alert.addAction(canceledAction)
          present(alert, animated: true, completion: nil)
      }
    private func startTurnByTurnNavigation(with route: NMARoute, useSimulation: Bool) {
         if let error = navigationManager.startTurnByTurnNavigation(route) {
            // showMessage("Error:start navigation returned error code \(error._code)")
         } else {
             // Set the map tracking properties
             enableMapTracking(true)
            if useSimulation {
                          // Simulation navigation by init the PositionSource with route and set movement speed
                          let source = NMARoutePositionSource(route: route)
                          source.movementSpeed = 10
                          print(source.currentPosition())
                          NMAPositioningManager.sharedInstance().dataSource = source
                      }
         }
     }
}




