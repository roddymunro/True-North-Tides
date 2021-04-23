//
//  StationAPI.swift
//  True North Tides
//
//  Created by Roddy Munro on 2021-04-14.
//

import Foundation

final class StationAPI {
    
    init() { }
    
    private let baseUrl = URL(string: "https://ws-shc.qc.dfo-mpo.gc.ca/predictions?wsdl")!
    
    lazy var dateFormatter = makeDateFormatter()
    
    public func getHiLoTides(for station: Station, startingDate: Date=Date().addingTimeInterval(-43200), _ completion: @escaping (Result<[Reading], Error>) -> Void) {
        let sdt = startingDate.stringFromDescendingFormat()!
        let edt = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date().addingTimeInterval(172800))!.stringFromDescendingFormat()!
        let soapEnv = """
        <soapenv:Envelope xmlns:soapenv= \"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:cgs= \"https://ws-shc.qc.dfo-mpo.gc.ca/\">
            <soapenv:Header />
            <soapenv:Body>
                <search>
                    <dataName>hilo</dataName>
                    <latitudeMin>-90.0</latitudeMin>
                    <latitudeMax>90.0</latitudeMax>
                    <longitudeMin>-180.0</longitudeMin>
                    <longitudeMax>180.0</longitudeMax>
                    <depthMin>0.0</depthMin>
                    <depthMax>0.0</depthMax>
                    <dateMin>\(sdt)</dateMin>
                    <dateMax>\(edt)</dateMax>
                    <start>1</start>
                    <sizeMax>5</sizeMax>
                    <metadata>true</metadata>
                    <metadataSelection>station_id=\(station.id)</metadataSelection>
                    <order>asc</order>
                </search>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        let request = NSMutableURLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.httpBody = soapEnv.data(using: .utf8)
        request.addValue(String(soapEnv.count), forHTTPHeaderField: "Content-Length")
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("search", forHTTPHeaderField: "SOAPAction")

        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            } else if let data = data {
                guard let dic = SwiftXMLParser.makeDic(string: String(data: data, encoding: .utf8)!) else {
                    print("failed to parse")
                    completion(.failure(TNTError.invalidData))
                    return
                }
                
                guard let jsondata = self.extractData(from: dic["soapenv:Envelope"] as! [String: Any]) else {
                    print("failed to parse")
                    completion(.failure(TNTError.invalidData))
                    return
                }
                
                let tideData = try? JSONDecoder().decode(TideData.self, from: jsondata)
                
                var dates: [String: Date] = [:]
                
                guard let multirefs = tideData?.soapenvBody.multiRef else {
                    print("no multirefs")
                    completion(.failure(TNTError.noData))
                    return
                }
                
                for multiRef in multirefs {
                    if let maxStr = multiRef.max?.swiftXMLParserTextKey {
                        if let maxDate = self.dateFormatter.date(from: maxStr) {
                            let id = multiRef.xmlAttributes.id
                            let dateVals = dates.map { $0.value }
                            if !dateVals.contains(maxDate) {
                                dates[id] = maxDate
                            }
                        }
                    }
                }
                
                var readings: [Reading] = []
                for multiRef in (tideData?.soapenvBody.multiRef)! {
                    if let valueStr = multiRef.value?.swiftXMLParserTextKey, let boundaryDateId = multiRef.boundaryDate?.xmlAttributes.href {
                        if let value = Double(valueStr), value != 0.0 {
                            let id = boundaryDateId.replacingOccurrences(of: "#", with: "")
                            if let date = dates[id] {
                                readings.append(Reading(dateTime: date, height: Measurement(value: value, unit: .meters)))
                            }
                        }
                    }
                }
                
                readings.sort { $0.dateTime < $1.dateTime }
                
                if let lastReading = readings.last {
                    if lastReading.dateTime > Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Date().addingTimeInterval(86400))! {
                        completion(.success(readings))
                    } else {
                        self.getHiLoTides(for: station, startingDate: lastReading.dateTime) { result in
                            switch result {
                                case .success(let newReadings):
                                    let currentDates = readings.map { $0.dateTime }
                                    let filtered = newReadings.filter {
                                        !currentDates.contains($0.dateTime)
                                    }
                                    let concReadings = (readings + filtered).sorted { $0.dateTime < $1.dateTime }
                                    completion(.success(concReadings))
                                default:
                                    completion(result)
                            }
                        }
                    }
                } else {
                    completion(.success(readings))
                }
            }
        }).resume()
    }
    
    private func extractData(from dic: [String: Any]) -> Data? {
        if let body = dic["soapenv:Body"] {
            if(!JSONSerialization.isValidJSONObject(body)) {
                print("is not a valid json object")
                return nil
            }
            
            let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
            return data
        } else {
            return nil
        }
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        return dateFormatter
    }
}
