# DUO Integration for cisco-nso-saml2-auth

This NSO authentication package provides SAMLv2 functionality based on original cisco-nso-saml2-auth and modified to compatible with Cisco DUO.  The limitation and configuration that applied on cisco-nso-saml2-auth still applies on this packages. For the original Readme of the cisco-nso-saml2-auth, please refer to README_original.md file. 

## Tested Enviorment
NSO Version Requirment: >=6.3.0

## Demo Testbed include Deployment Guide
* Native NSO installation without assertion encryption enabled - https://github.com/NSO-developer/nso-sso-duo-integration---native 
* Containerized NSO installation with assertion encryption enabled - https://github.com/NSO-developer/nso-sso-duo-integration---containerzed-nso 

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