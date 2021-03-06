//
//  Listing.swift
//  sherwoodrealestate
//
//  Created by Alex Beattie on 5/21/18.
//  Copyright © 2018 Alex Beattie. All rights reserved.
//

import UIKit


class Listing: Decodable, Encodable {
    
    struct responseData: Decodable {
        var D: ResultsData
    }
    struct ResultsData: Decodable {
        var Results: [resultsArr]
    }
    struct resultsArr: Decodable {
        var AuthToken: String
        var Expires: String
    }
    //    static let instance = Listing()
    
   
  
  
    
    //listing struct
    struct listingData: Codable {
        var D: listingResultsData
    }
    struct listingResultsData: Codable {
        var Results: [listingResults]
    }
    struct listingResults: Codable {
        var Id: String
        var ResourceUri: String
        var StandardFields: standardFields
    }
    struct standardFields: Codable {
        
        var ListingId: String
        
        var ListAgentName: String
        var ListAgentStateLicense: String
        var ListAgentEmail: String
        
        var CoListAgentName: String
        var CoListAgentStateLicense: String
        var ListOfficePhone: String
        var ListOfficeFax: String
        
        var UnparsedFirstLineAddress: String
        var City: String
        var PostalCode: String
        var StateOrProvince: String
        
        var UnparsedAddress: String
        var YearBuilt: Int?
        
        var CurrentPricePublic: Int
        var ListPrice: Int
        
        var BedsTotal: Int
        var BathsFull: Int
        var BathsHalf: Int?
        
        var BuildingAreaTotal: Int
        
        var PublicRemarks: String?
        
        var ListAgentURL: String
        var ListOfficeName: String
        
        let Latitude: Double
        let Longitude: Double
       
        var Photos: [PhotoDictionary]
        
        struct PhotoDictionary:Codable {
            var Id: String
            var Name: String
            var Uri1600: String
        
        }
        
        
        
        
        
        
       
        
        static func md5(_ string: String) -> String {
            let context = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: 1)
            var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5_Init(context)
            CC_MD5_Update(context, string, CC_LONG(string.lengthOfBytes(using: String.Encoding.utf8)))
            CC_MD5_Final(&digest, context)
            context.deallocate(capacity: 1)
            var hexString = ""
            for byte in digest {
                hexString += String(format:"%02x", byte)
            }
            return hexString
        }
        
        static func fetchListing(_ completionHandler: @escaping (listingData) -> ())  {
            let baseUrl = URL(string: "https://sparkapi.com/v1/session?ApiKey=vc_c15909466_key_1&ApiSig=a2b8a9251df6e00bf32dd16402beda91")!
            let request = NSMutableURLRequest(url: baseUrl)
            request.httpMethod = "POST"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
            
//            var photos: [Listing.photoResults]?
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                
                guard let data = data else { return }
                
                if let error = error {
                    print(error)
                }
                do {
                    let decoder = JSONDecoder()
                    let listing = try decoder.decode(responseData.self, from: data)
                    
                    print(listing.D.Results)
                    
                    
                    let authToken = listing.D.Results[0].AuthToken
                    
                    var myListingsPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken"
                    let myPhotoPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken\(authToken)_expandPhotos"
                    let mySortPass  = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken\(authToken)_expandPhotos_orderby-ListPrice"
                    let myFilterPass = "uTqE_dbyYSx6R1LvonsWOApiKeyvc_c15909466_key_1ServicePath/v1/my/listingsAuthToken\(authToken)_expandPhotos_filterNot MlsStatus Eq 'Sold'_orderby-ListPrice"
                    
//                    PropertyType Eq 'A'
                    let apiSig = self.md5(myListingsPass)
                    let photoApiSig = self.md5(myPhotoPass)
                    let sortedApiSig = self.md5(mySortPass)
                    let filteredApiSig = self.md5(myFilterPass)
//                    print("The FILTER Converted MD5 /my/listings: " + apiSig)
//                    print("The Converted MD5 /my/listings: " + apiSig)
                    
                    
//                    let call = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
//                    let photocall = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)_expand=Photos&ApiSig=\(photoApiSig)"
                    let call = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&ApiSig=\(apiSig)"
                    let photocall = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&_expand=Photos&ApiSig=\(photoApiSig)"
                    let sortecall = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&_expand=Photos&_orderby=-ListPrice&ApiSig=\(sortedApiSig)"
                   
                    let preFilteredCall = ("https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&_expand=Photos&_filter=Not MlsStatus Eq 'Sold'&_orderby=-ListPrice&ApiSig=\(filteredApiSig)")
                    let space = "%20"
                    let quote = "%27"
                    let filteredCall = "https://sparkapi.com/v1/my/listings?AuthToken=\(authToken)&_expand=Photos&_filter=Not\(space)MlsStatus\(space)Eq\(space)\(quote)Sold\(quote)&_orderby=-ListPrice&ApiSig=\(filteredApiSig)"
                    
                    
//                    var myListingsPass = MY_LISTINGS_PASS
//                    myListingsPass.append(authToken)

                    
                    let newCallUrl = URL(string: "\(filteredCall)")
//                    let filteredCall = newCallUrl.

                    var request = URLRequest(url: newCallUrl!)
                    request.httpMethod = "GET"
                    request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
                    request.addValue("SparkiOS", forHTTPHeaderField: "X-SparkApi-User-Agent")
                  //  request.addValue("_expand", forHTTPHeaderField: "Photos")
                    let newTask = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                        guard let data = data else { return }
                        print(data)
                        if let error = error {
                            print(error)
                        }
                        
                        do {
                            
                            let newDecoder = JSONDecoder()
                            let newListing = try newDecoder.decode(listingData.self, from: data)
                            
//                            print(newPhotos)
                            print(newListing.D.Results)
                            var emptyPhotoArray = [String]()
                            let theListing = newListing.D.Results
                            //print("THE LISTING IS: \(theListing)")
                            for aListing in (theListing) {
//                                print(aListing)
                                for aPhoto in aListing.StandardFields.Photos {
//                                    print(aPhoto.Uri1600)
                                    emptyPhotoArray.append(aPhoto.Uri1600)

                                }
                                print(emptyPhotoArray)

                                emptyPhotoArray.removeAll()
                            }
                           
                                
                            
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                completionHandler(newListing)
                            })
                        
                            
                           // var listingArray = [Listing]()
                            
//                            for photos in (listingArray) {
//                                print(photos)
//
////                                let pic = photos.count
//
//
//                            }

                            

                        } catch let err {
                            print(err)
                        }
                    }
                    newTask.resume()
                    
                } catch let err {
                    print(err)
                }
            }
            task.resume()
        }
    }
}
