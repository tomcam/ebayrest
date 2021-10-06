// Get an application access token from eBay.
// No support for the eBay Sandbox
package main

import (
	b64 "encoding/base64"
	"fmt"
	"io/ioutil"
	"net/http"
	"strings"
)


type InProduction int

// Replace the following with your secrets.
// Obviously DON'T embed them in your
// source code. Read them from the
// environment or from a config file.
// This just keeps the code listing short.
const (
	productionClientId     = "eSnipeIn-Rapidfir-PRD-cb27d3335-9fa5c3c6"
	productionClientSecret = "PRD-b27d33355f15-83de-4c5f-8541-b52c"
)

// The HTTP parameter expects the client ID and
// client secrets separated by a colon and
// base64 encoded.
func encodeCredentials() string {
	var toEncode string
	toEncode = productionClientId + ":" + productionClientSecret
	return (b64.StdEncoding.EncodeToString([]byte(toEncode)))
}

// The REST endpoint and its scope.

// Obtain an access token, using
// either production or
// sandbox credentials,
// in the form of a big long string.
//
// Theese tokens only last a few hours, so
// beware the time to live returned in JSON.
// Reference:
// https://developer.ebay.com/api-docs/static/oauth-client-credentials-grant.html#sequence
func getApplicationAccessToken() (string, error) {
	// Build up the POST request.
	params := "grant_type=client_credentials" +
		"&scope=https%3A%2F%2Fapi.ebay.com%2Foauth%2Fapi_scope"

	b := strings.NewReader(params)
	req, err := http.NewRequest("POST", "https://api.ebay.com/identity/v1/oauth2/token", b)
	if err != nil {
		panic("Unable to create request")
	}
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Add("Authorization", "Basic "+encodeCredentials())
	client := &http.Client{}

	// Execute the POST request.
	// Return with JSON payload in resp.Body
	resp, err := client.Do(req)
	defer resp.Body.Close()

	if err != nil {
		return "", err
	}
	// Item information was available.
	// More information than you could
	// possibly want has been returned
	// in resp.Body.
	data, err := ioutil.ReadAll(resp.Body)
	return string(data), nil
}

// Driver program shows how to obtain the
// application access token for either
// production or sandbox use.
// Dumps the contents of both to the
// terminal. Normally you'd write them
// to a variable and pass it to subsequent
// calls to the eBay RESTful API.
func main() {
  token, err := getApplicationAccessToken()
	if err != nil {
		fmt.Println(err)
	} else {
		fmt.Println("Application Access token for Production:\n%s", token)
	}
}
