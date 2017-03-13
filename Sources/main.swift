//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectNet

let VerifyToken = "PerfectCookieMonster"
// curl "https://cookiemonster.perfect.org/webhook?hub.mode=subscribe&hub.verify_token=PerfectCookieMonster&hub.challenge=commontest"

func webHookHandler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
    print("incoming query ------------------>")
    print(request.params())
    print("incoming body  ------------------>")
    print(request.postBodyString ?? "")
    print("processing ================>")
    guard let mode = request.param(name: "hub.mode"), let token = request.param(name: "hub.verify_token"), let challenge = request.param(name: "hub.challenge")  else {
      response.completed(status: .forbidden)
      return
    }//end guard
    print("mode: \(mode)\ntoken:\(token)\nchallenge:\(challenge)")
    guard mode == "subscribe" && token == VerifyToken else {
      print("rejected")
      response.completed(status: .forbidden)
      return
    }//end guard
    print("send back")
    //response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "\(challenge)")
    response.completed()
  }//end
}

let confData = [
	"servers": [
		[
			"name":"cookiemonster.perfect.org",
			"port":443,
			"routes":[
				["method":"get", "uri":"/webhook", "handler":webHookHandler]
			],
			"tlsConfig": [
        "certPath":"/home/ubuntu/combo.crt",
        "keyPath":"/home/ubuntu/cookiemonster.perfect.org.key"
      ],
      "runAs": "ubuntu"
    ]
	]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

