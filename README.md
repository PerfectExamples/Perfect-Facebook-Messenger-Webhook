# PerfectTemplate for Facebook Messenger Webhook

<p align="center">
    <a href="http://perfect.org/get-involved.html" target="_blank">
        <img src="http://perfect.org/assets/github/perfect_github_2_0_0.jpg" alt="Get Involed with Perfect!" width="854" />
    </a>
</p>

<p align="center">
    <a href="https://github.com/PerfectlySoft/Perfect" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_1_Star.jpg" alt="Star Perfect On Github" />
    </a>  
    <a href="http://stackoverflow.com/questions/tagged/perfect" target="_blank">
        <img src="http://www.perfect.org/github/perfect_gh_button_2_SO.jpg" alt="Stack Overflow" />
    </a>  
    <a href="https://twitter.com/perfectlysoft" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_3_twit.jpg" alt="Follow Perfect on Twitter" />
    </a>  
    <a href="http://perfect.ly" target="_blank">
        <img src="http://www.perfect.org/github/Perfect_GH_button_4_slack.jpg" alt="Join the Perfect Slack" />
    </a>
</p>

<p align="center">
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0">
    </a>
    <a href="https://developer.apple.com/swift/" target="_blank">
        <img src="https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms OS X | Linux">
    </a>
    <a href="http://perfect.org/licensing.html" target="_blank">
        <img src="https://img.shields.io/badge/License-Apache-lightgrey.svg?style=flat" alt="License Apache">
    </a>
    <a href="http://twitter.com/PerfectlySoft" target="_blank">
        <img src="https://img.shields.io/badge/Twitter-@PerfectlySoft-blue.svg?style=flat" alt="PerfectlySoft Twitter">
    </a>
    <a href="http://perfect.ly" target="_blank">
        <img src="http://perfect.ly/badge.svg" alt="Slack Status">
    </a>
</p>

Facebook Messenger App requires Webhook to start with. This project demonstrates how to setup such a Webhook based on PerfectTemplate.

## Compatibility with Swift

The master branch of this project currently compiles with **Xcode 8.2** or the **Swift 3.0.2** toolchain on Ubuntu.

## Quick Start

This project is based on PerfectTemplate, so please try it first before turning it into your production server:

```
git clone https://github.com/PerfectlySoft/PerfectTemplate.git
cd PerfectTemplate
swift build
.build/debug/PerfectTemplate
```

Once understood the Perfect HTTP Server, the following steps are precisely demanded to setup a Facebook Messenger Webhook production server:

- A Valid Server: The production webhook server must have a valid ip on internet and have an active instance.
- Privilege of 443: Facebook Messenger App demands 443 as the only valid port to access, which means that the webhook instance must run this project with sufficient privileges:

```
$ sudo /home/ubuntu/FBMsgSrv/PerfectTemplate
```

- Full Qualified Domain Name (FQDN): it is mandated to apply a FQDN for the webhook production server. Once registered the domain name, please *MERGE* the intermediate certificate file onto your own signed certificate, like `$ cp orginal.crt combo.crt; cat intermediate.crt >> combo.crt`, and paste these paths to the source, as below:

``` swift
let confData = [
	"servers": [
		[
			"name":"my.full.qualified.domain.name",
			"port":443,
			"routes":[
				["method":"get", "uri":"/webhook", "handler":webHookHandler]
			],
			"tlsConfig": [
        "certPath":"/path/to/combo.crt",
        "keyPath":"/path/to/my.private.key"
      ],
      "runAs": "valid-user-other-than-root"
    ]
	]
]
```

- Complete the webhook handle: a verify token, as your app's secret code created by your own, is required for webhook. Check this out:

``` swift
let VerifyToken = "Type Your Secrect Here And Copy It To You FB Messenger App Settings"

func webHookHandler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
    guard let mode = request.param(name: "hub.mode"), let token = request.param(name: "hub.verify_token"), let challenge = request.param(name: "hub.challenge")  else {
      response.completed(status: .forbidden)
      return
    }//end guard
    guard mode == "subscribe" && token == VerifyToken else {
      // reject invalid request
      response.completed(status: .forbidden)
      return
    }//end guard
    // send the challenge back to Facebook.
		response.appendBody(string: "\(challenge)")
    response.completed()
  }//end
}
```


## Issues

We are transitioning to using JIRA for all bugs and support related issues, therefore the GitHub issues has been disabled.

If you find a mistake, bug, or any other helpful suggestion you'd like to make on the docs please head over to [http://jira.perfect.org:8080/servicedesk/customer/portal/1](http://jira.perfect.org:8080/servicedesk/customer/portal/1) and raise it.

A comprehensive list of open issues can be found at [http://jira.perfect.org:8080/projects/ISS/issues](http://jira.perfect.org:8080/projects/ISS/issues)

## Further Information
For more information on the Perfect project, please visit [perfect.org](http://perfect.org).
