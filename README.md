# DUO Integration for cisco-nso-saml2-auth  (With CLI 2FA)

This NSO authentication package provides SAMLv2 functionality based on original cisco-nso-saml2-auth and modified to compatible with Cisco DUO.  The limitation and configuration that applied on cisco-nso-saml2-auth still applies on this packages. For the original Readme of the cisco-nso-saml2-auth, please refer to README_original.md file. 

## Demo Testbed include Deployment Guide
* Native NSO installation without assertion encryption enabled - https://github.com/NSO-developer/nso-sso-duo-integration---native 
* Containerized NSO installation with assertion encryption enabled - https://github.com/NSO-developer/nso-sso-duo-integration---containerzed-nso 

### CLI Specific Steps
Follow the guide [login_duo Guide](https://duo.com/docs/loginduo) and setup login_duo.conf in /etc/duo or /etc/security as below
```
[duo]
; Duo integration key
ikey = <integration key>
; Duo secret key
skey = <secret key>
; Duo API host
host = <DUO URL>
; `failmode = safe` In the event of errors with this configuration file or connection to the Duo service
; this mode will allow login without 2FA.
; `failmode = secure` This mode will deny access in the above cases. Misconfigurations with this setting
; enabled may result in you being locked out of your system.
failmode = safe
; Send command for Duo Push authentication
pushinfo = yes
prompts = 1
autopush = yes
```

### Special Notice
This version of the code only works in Linux base system. MacOS and Windows will not work due to login_duo only support Linux. More specificly Ubuntu 24 is what this code written upon and can provide more seamless expierence.   
CLI protection support via login_duo also do not require external reachable URL/IP address like WebUI protection via SAML. 


## Feature List
### Fix 
* "IssueInstant" Formatting Issue with DUO
Oiriginal cisco-nso-saml2-auth enforce the unstandarlized "IssueInstant" formating - "2024-06-13T14:57:58.693137+00:00". Change to OASIS standard "IssueInstant" formating - "2004-12-05T09:21:59Z"

* IDP cert input validation through metadata_url
 Clean up the certification string inside metadata and remove unessasary linebreak in the end. 

### New Feature
* Better authentication method than checking extra "saml:AttributeStatement"
If the uid,gid,homedir,groups,gids attribute is not provided by the IdP, the package will try to obtain the information from the following source
    * groups,gids  - NACM configuration
    * uid,gid,homedir - First try aaa. If username is not in aaa try to get from PAM. Otherwise access denined
* Propose better debugging and logging for SSO
Verbose logging in Python VM



### Copyright and License Notice
``` 
Copyright (c) 2024 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
``` 