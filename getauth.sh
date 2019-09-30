#!/bin/bash 
# getauth.sh uses CURL to obtain an authorization code on eBay.
# It returns the authorization code in a variable named $authcode.
# The full JSON response is deposited into a file named authcode.json.
#
# eBay sadly calls this an access token, even though it's
# an OAuth2 authorization code, which is meant to be exchanged
# for an access token.
# https://developer.ebay.com/api-docs/static/oauth-client-credentials-grant.html

# If successful, the payload returned is a JSON value 
# something like this, although the "access_token" string
# is actually thousands of characters long:
# {"access_token":"^XDFDFD.....AAA=","expires_in":7200,"token_type":"Application Access Token"}

# How to use:
# 1. Export credentials from eBay in the environment
# using these names:
#   SANDBOX_CLIENT_ID="<YOUR EBAY CREDENTIALS>"
#   SANDBOX_CLIENT_SECRET="<YOUR EBAY CREDENTIALS>"
#   PRODUCTION_CLIENT_ID="<YOUR EBAY CREDENTIALS>"
#   PRODUCTION_CLIENT_SECRET="<YOUR EBAY CREDENTIALS>"
#
# 2. Set permissions so the file can be run.
# $ chmod +x apptoken.sh
#
# 3. Then just run at the shell
#
# Example usages
# Use production:
# ./getauth.sh 
#
# Use sandbox:
# ./getauth.sh sandbox
#

# Quit if the requisite environment variables haven't been exported.  
: ${SANDBOX_CLIENT_ID?"Environment variables like SANDBOX_CLIENT_ID aren't set"} 
: ${PRODUCTION_CLIENT_ID?"Environment variables like PRODUCTION_CLIENT_ID aren't set"} 

# The word "sandbox" as the parameter
# causes the sandbox API and secrets to be used.
production=$1

# Obtain an authentication code from eBay.
if [ "$production" == "sandbox" ]; 
	then 
	  prod=$SANDBOX_CLIENT_ID:$SANDBOX_CLIENT_SECRET 
  	  endpoint=https://api.sandbox.ebay.com/identity/v1/oauth2/token
	  apicall=https://api.sandbox.ebay.com/buy/browse/v1/item
  	else
    	  prod=$PRODUCTION_CLIENT_ID:$PRODUCTION_CLIENT_SECRET
  	  endpoint=https://api.ebay.com/identity/v1/oauth2/token
	  apicall=https://api.ebay.com/buy/browse/v1/item/v1
  fi

# The 'Authorization' header consists of the client ID, a ':' character, and the client secret.  
# They are base64-encoded. Then that string appended after the text
# 'Authorization: Basic ', which is NOT base64-encoded.  
# Not confusing at all.
urlencoded="$(echo ${prod}|base64)"


# Get the auth code
# Write the output to the file authcode.json
curl POST $endpoint \
-H "Content-Type: application/x-www-form-urlencoded" \
-H "Authorization: Basic ${urlencoded}" \
-d "grant_type=client_credentials&scope=https%3A%2F%2Fapi.ebay.com%2F%oauth%2F%api_scope%2Fbuy.marketing" > authcode.json

# Extract the authorization code from file containing the the JSON return.
# Assign it to the environment variable $authcode
authcode=$(grep -o '"access_token":"[^"]*' authcode.json | grep -o '[^"]*$')

echo "Authorization code is: ${authcode}\n"
