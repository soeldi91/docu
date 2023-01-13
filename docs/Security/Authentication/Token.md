# Klassifizierung
- Self-contained Token (Assertion) 
    - SAML (Security Assertion Markup Language)
        - SAML Request
        - SAML Response
    - JSON Web Token (JWT)
        - ID Token
        - Access Token
- Opaque Token (Handle) s
    - Auth Code
    - Refresh Token


# SAML
## Request
- Enthält Informationen für die Ausstellung des Tokens
- Sollte signiert werden
- So weiss der IDP, wofür später das Token ausgestellt wird

## Response
- Das Token zur Authentisierung
- Es enthält eine Referenz zum Request

Weitere Daten:
• Eindeutiger Name (Subject)
• Gültigkeitsdatum (von/bis)
• Signatur


# JWT 
## ID Token
- Enthält Informationen zur Identität
- Universell gültig bis zum Ablaufdatum 
- Erforderliche Felder (Payload): 
    - Eindeutiger Name (Subject) 
    - Gültigkeitsdatum (von/bis) 
    - Aussteller (Issuer) 
    - Audience 
- Weitere Felder (Payload): : 
    - Authentisierungsmethode 
    - Nonce

## Access Token
- Enthält neben der Identität weitere Einschränkungen
- Entsprechend eingeschränkt gültig bis zum Ablaufdatum
- Erforderliche Felder:
    - Eindeutiger Name (Subject)
    - Gültigkeitsdatum (von/bis)
    - Aussteller (Issuer)
    - Scope des Tokens
- Mögliche weitere Felder:
    - Rollen
    - Berechtigungen

# Opaque Token
- Keine JSON-Datenstruktur
- Zufälliger String
- Die zugehörigen Daten sind in einer internen Datenbank gespeichert
- Daten werden nur im Hintergrund ausgetauscht

Beispiel: Refresh Token
- Berechtigt zum Holen von neuen Token

# Bearer Token
- Ein Token, das jeder durch Vorzeigen verwenden kann
- Typischerweise via HTTP-Header mitgegeben
- «Authorization: Bearer»


Federated Identity
Delegated Authorization

## SAML 2.0
User Agent | Service Provider | Identity Provider
- Connection Flows
- Web Browser SSO Profile
- Enhanced Client or Proxy (ECP) Profile

## OpenID Connect
User Agent | Relying Party | OpenID Provider
- Connection Flows
    - Authorization Code Flow
    - Implicit Flow
    - Hybrid Flow

## Oauth 2.0
User Agent | Client | Authorization Server
- Connection Flows
    - Authorization Code Flow
    - Implicit Flow
    - Resource Owner Password Credentials Flow
    - Client Credentials Flow


# Sessionmanagement
- Sessionmanagement klassisch – mit Session-ID und State
- Sessionmanagement ohne State (mit Self-contained Token)

