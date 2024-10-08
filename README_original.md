cisco-nso-saml2-auth
====================

This authentication package provides SAMLv2 functionality for the
NSO Single Sign-On functionality.


Table of contents

    1. Configuration
    1.1. Installation
    1.2. NSO Configuration
    1.3. Package Configuration
    2. Usage
    3. Requirements
    4. Limitations
    5. Example SAMLResponse


1. Configuration

1.1. Installation

   In order to use this package, NSO must be run with access to the
   required Python packages found in requirements.txt.


1.2. NSO Configuration

   This authentication package needs both NSO Package Authentication and
   NSO Single Sign-On to be enabled.

   Enable Package Authentication by setting
   /ncs-config/aaa/package-authentication/enabled = true.

   Add the SAMLv2 package (cisco-nso-saml2-auth) to the list of available
   authentication packages by setting
   /ncs-config/aaa/package-authentication/packages.

   Enable Single Sign-On by setting
   /ncs-config/aaa/single-sign-on/enabled = true.


1.3. Package Configuration

   In order to configure SAMLv2 the cisco-nso-saml2-auth.yang model
   needs to be populated with at least the following configuration

   The Identity Provider (IdP) required configuration:

      saml2-auth identity-provider entity-id
      saml2-auth identity-provider metadata

   The metadata needs to contain SingleSignOnService with attributes
   Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" and
   Location set.

   The NSO Service Provider (SP) required configuration:

       saml2-auth service-provider base-url
       saml2-auth service-provider entity-id
       saml2-auth service-provider metadata

   Furthermore, in order to process signed and also sign messages, the
   following extra configuration is required:

       saml2-auth service-provider signature-algorithm
       saml2-auth service-provider private-key-signing

   The KeyDescriptor with attribute use="signing", needs to be set in
   IdP the metadata as well.


2. Usage

   The /sso/saml/login/ endpoint will redirect unauthenticated requests
   towards the IdP. When the IdP authenticates a request it redirects to
   /sso/saml/acs/ which in turn authenticates the user and creates a
   session.

   It is also possible to logout an authenticated session at the
   /sso/saml/logout/ endpoint.


3. Requirements

   The SAMLResponse from the IdP must include the following attributes
   (required by NSO Package Authentication) to work:

   * uid     - user id, positive integer
   * gid     - group id, positive integer
   * homedir - home directory, arbitrary string

   The following attributes can be included if wanted:

   * groups - list of extra group names, space separated string
   * gids   - matching gids for the list of extra groups, space
              separated positive integers

   See Section 5 for an example SAMLResponse with the above attributes.


4. Limitations

   Only RSA keys are supported for signed messages.

   Only rsa-sha256 signature algorithm is supported.

   Even if the IdP SingleLogoutService is defined in the metadata, it is
   not used. I.e. no logout request is sent to the IdP when doing a
   logout.


5. Example SAMLResponse

   An example SAMLResponse that this package can consume correctly is
   supplied below.

   Note that the included certificates, digest, and signature have been
   replaced with the base64encodedvalue== placeholder!

   ```xml
   <?xml version="1.0"?>
   <samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol"
                   Destination="http://localhost:8080/sso/saml/acs/"
                   ID="_15ea409ab180483da4c284fd0f964d21"
                   InResponseTo="_bf28082217cc4bd3b3969ee77a984f8e"
                   IssueInstant="2023-03-24T13:22:47.564823+00:00"
                   Version="2.0">
     <saml:Issuer xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">
     http://localhost:8000/saml/metadata.xml
     </saml:Issuer>
     <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
       <ds:SignedInfo>
         <ds:CanonicalizationMethod
          Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
         <ds:SignatureMethod
          Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
         <ds:Reference URI="#_15ea409ab180483da4c284fd0f964d21">
           <ds:Transforms>
             <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#envelop\
   ed-signature"/>
             <ds:Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
           </ds:Transforms>
           <ds:DigestMethod
            Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
           <ds:DigestValue>
           VCnJ/cQ57UejCvDm5sZLkXmFsONcN9V5nLR7dM1bUHE=
           </ds:DigestValue>
         </ds:Reference>
       </ds:SignedInfo>
       <ds:SignatureValue>base64encodedvalue==</ds:SignatureValue>
       <ds:KeyInfo>
         <ds:X509Data>
           <ds:X509Certificate>base64encodedvalue==</ds:X509Certificate>
         </ds:X509Data>
       </ds:KeyInfo>
     </ds:Signature>
     <samlp:Status>
       <samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/>
     </samlp:Status>
     <saml:Assertion xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion"
                     ID="_309b037418ab40f1b4badd3cff23855c"
                     IssueInstant="2023-03-24T13:22:47.564823+00:00"
                     Version="2.0">
       <saml:Issuer>http://localhost:8000/saml/metadata.xml</saml:Issuer>
       <ds:Signature xmlns:ds="http://www.w3.org/2000/09/xmldsig#">
         <ds:SignedInfo>
           <ds:CanonicalizationMethod
            Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
           <ds:SignatureMethod
            Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256"/>
           <ds:Reference URI="#_309b037418ab40f1b4badd3cff23855c">
             <ds:Transforms>
               <ds:Transform Algorithm="http://www.w3.org/2000/09/xmldsig#envel\
   oped-signature"/>
               <ds:Transform
                Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#"/>
             </ds:Transforms>
             <ds:DigestMethod
              Algorithm="http://www.w3.org/2001/04/xmlenc#sha256"/>
             <ds:DigestValue>base64encodedvalue==</ds:DigestValue>
           </ds:Reference>
         </ds:SignedInfo>
         <ds:SignatureValue>base64encodedvalue==</ds:SignatureValue>
         <ds:KeyInfo>
           <ds:X509Data>
             <ds:X509Certificate>base64encodedvalue==</ds:X509Certificate>
           </ds:X509Data>
         </ds:KeyInfo>
       </ds:Signature>
       <saml:Subject>
         <saml:NameID
          Format="urn:oasis:names:tc:SAML:2.0:nameid-format:unspecified"
          SPNameQualifier="http://localhost:8080/sso/saml/metadata/">
         admin
         </saml:NameID>
         <saml:SubjectConfirmation
          Method="urn:oasis:names:tc:SAML:2.0:cm:bearer">
           <saml:SubjectConfirmationData
            InResponseTo="_bf28082217cc4bd3b3969ee77a984f8e"
            NotOnOrAfter="2023-03-24T13:37:47.564823+00:00"
            Recipient="http://localhost:8080/sso/saml/acs/"/>
         </saml:SubjectConfirmation>
       </saml:Subject>
       <saml:Conditions NotBefore="2023-03-24T13:19:47.564823+00:00"
                        NotOnOrAfter="2023-03-24T13:37:47.564823+00:00">
         <saml:AudienceRestriction>
           <saml:Audience>
           http://localhost:8080/sso/saml/metadata/
           </saml:Audience>
         </saml:AudienceRestriction>
       </saml:Conditions>
       <saml:AuthnStatement AuthnInstant="2023-03-24T13:22:47.564823+00:00">
         <saml:AuthnContext>
           <saml:AuthnContextClassRef>
           urn:oasis:names:tc:SAML:2.0:ac:classes:Password
           </saml:AuthnContextClassRef>
         </saml:AuthnContext>
       </saml:AuthnStatement>
       <saml:AttributeStatement>
         <saml:Attribute
          Name="groups"
          NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
           <saml:AttributeValue>admin wheel</saml:AttributeValue>
         </saml:Attribute>
         <saml:Attribute
          Name="uid"
          NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
           <saml:AttributeValue>1000</saml:AttributeValue>
         </saml:Attribute>
         <saml:Attribute
          Name="gid"
          NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
           <saml:AttributeValue>1000</saml:AttributeValue>
         </saml:Attribute>
         <saml:Attribute
          Name="gids"
          NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
           <saml:AttributeValue>100</saml:AttributeValue>
         </saml:Attribute>
         <saml:Attribute
          Name="homedir"
          NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:basic">
           <saml:AttributeValue>/home/admin</saml:AttributeValue>
         </saml:Attribute>
       </saml:AttributeStatement>
     </saml:Assertion>
   </samlp:Response>
   ```