# eBay RESTful API notes

## Client credentials grant request (aka authorization code)

[getauth.sh](getauth.sh) is a Bash shell script using curl that
uses your client ID and client secret to do what eBay calls a "[client credentials grant](https://developer.ebay.com/api-docs/static/oauth-client-credentials-grant.html)". In the rest of the OAuth2 world this is minting
a temporary [authorization code](https://www.oauth.com/oauth2-servers/accessing-data/authorization-request/), which you're later expected to exchange for a real authorization token.
