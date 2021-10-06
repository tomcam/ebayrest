# eBay RESTful API notes

[apptoken.go](apptoken.go) shows how to get an application access token. Pretty sure it's the same in theory as getauth.sh
so I need to rename one of these and clean up the docs.

## Client credentials grant request (aka authorization code)

[envset.go](envset.go) returns true if eBay secret environment variables have been set.

[getauth.sh](getauth.sh) is a Bash shell script using curl that
uses your client ID and client secret to do what eBay calls a "[client credentials grant](https://developer.ebay.com/api-docs/static/oauth-client-credentials-grant.html)". In the rest of the OAuth2 world this is minting
a temporary [authorization code](https://www.oauth.com/oauth2-servers/accessing-data/authorization-request/), which you're later expected to exchange for a real authorization token.
