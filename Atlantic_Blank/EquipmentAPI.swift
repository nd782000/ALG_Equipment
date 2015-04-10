import UIKit
import Alamofire


@objc public protocol ResponseCollectionSerializable {
    static func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

extension Alamofire.Request {
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
        
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                println("responseCollection")
                println("JSON\(JSON)")
                
                return (T.collection(response: response!, representation: JSON!), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? [T], error)
        })
    }
}

@objc public protocol ResponseObjectSerializable {
    init(response: NSHTTPURLResponse, representation: AnyObject)
}

extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                println("responseObject")
                println("JSON\(JSON)")
                
                return (T(response: response!, representation: JSON!), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? T, error)
        })
    }
}



extension Alamofire.Request {
    class func imageResponseSerializer() -> Serializer {
        return { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            let image = UIImage(data: data!, scale: UIScreen.mainScreen().scale)
            println("Image\(image)")
            
            return (image, nil)
        }
    }
    
    func responseImage(completionHandler: (NSURLRequest, NSHTTPURLResponse?, UIImage?, NSError?) -> Void) -> Self {
        return response(serializer: Request.imageResponseSerializer(), completionHandler: { (request, response, image, error) in
            completionHandler(request, response, image as? UIImage, error)
        })
    }
}



struct EquipmentAPI {
    enum Router: URLRequestConvertible {
        //static let baseURLString = "https://api.500px.com/v1"
        //static let consumerKey = "kue2IxRo7UonR75h4zXZ8x4KBtXE0WeiiapqapuQ"
        //static let baseURLString = "http://test.plantcombos.com/app"
        static let baseURLString = "http://atlanticlawnandgarden.com/cp/app"
        
        
        
        
        
        case EquipmentList()
        case EquipmentInfo(String)
        case Comments(Int, Int)
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .EquipmentList ():
                    let params = ["page": "\(1)"]
                    println("EquipmentList")
                    return ("/equipment.php", params)
                    //return ("/allPlants.php", params)
                    //return ("/photos", params)
                    
                    
                    
                case .EquipmentInfo(let equipmentID):
                    var params = ["ID": "\(equipmentID)"]
                    return ("/equipment.php", params)
                    
                    
                case .Comments(let photoID, let commentsPage):
                    var params = ["comments": "1", "comments_page": "\(commentsPage)"]
                    return ("/photos/\(photoID)/comments", params)
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            println("url = \(URL)")
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            println("URLRequest = \(URLRequest)")
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    
}

class EquipmentInfo: NSObject, ResponseObjectSerializable  {
    
    let id: String
    let name: String
    let typeName: String
    let make: String
    let model: String
    let status: String
    let crew: String
    let engine: String
    let fuel: String
    let mileage: String
    let pic: String
    
    
    
    
    init(id: String, name: String, typeName: String, make: String, model: String, status: String, crew: String, mileage: String, fuel: String, engine: String, pic: String) {
        println("EquipmentInfo init ")
        println("EquipmentInfo init id: \(id)")
        self.id = id
        
        self.name = name
        self.typeName = typeName
        self.make = make
        self.model = model
        self.status = status
        self.crew = crew
        self.engine = engine
        self.fuel = fuel
        self.mileage = mileage
        self.pic = pic
        
    }
    
    
    
    required init(response: NSHTTPURLResponse, representation: AnyObject) {
        println("EquipmentInfo init response: \(response)")
        self.id = representation.valueForKeyPath("equipment.id") as! String
        
        self.name = representation.valueForKeyPath("equipment.name") as! String
        self.typeName = representation.valueForKeyPath("equipment.typeName") as! String
        self.make = representation.valueForKeyPath("equipment.make") as! String
        self.model = representation.valueForKeyPath("equipment.model") as! String
        self.status = representation.valueForKeyPath("equipment.status") as! String
        self.crew = representation.valueForKeyPath("equipment.crew") as! String
        self.engine = representation.valueForKeyPath("equipment.engine") as! String
        self.fuel = representation.valueForKeyPath("equipment.fuel") as! String
        self.mileage = representation.valueForKeyPath("equipment.mileage") as! String
        self.pic = representation.valueForKeyPath("equipment.pic") as! String
        
        
    }
    
    
    
    override func isEqual(object: AnyObject!) -> Bool {
        return (object as! EquipmentInfo).id == self.id
    }
    /*
    override var hash: String {
    return (self as EquipmentInfo).id
    }
    */
}

final class Comment: ResponseCollectionSerializable {
    @objc class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Comment] {
        var comments = [Comment]()
        
        for comment in representation.valueForKeyPath("comments") as! [NSDictionary] {
            comments.append(Comment(JSON: comment))
        }
        
        return comments
    }
    
    let userFullname: String
    let userPictureURL: String
    let commentBody: String
    
    init(JSON: AnyObject) {
        userFullname = JSON.valueForKeyPath("user.fullname") as! String
        userPictureURL = JSON.valueForKeyPath("user.userpic_url") as! String
        commentBody = JSON.valueForKeyPath("body") as! String
    }
}