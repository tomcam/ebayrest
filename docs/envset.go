// Ensure required environment variables have been set.
// These are a private convention to store secrets
// required by the eBay API.
// Pass true to debug to write names
// of missing vars to stderr
func envSet(debug bool) bool {
	vars := []string{"PRODUCTION_CLIENT_ID",
		"PRODUCTION_CLIENT_SECRET",
		"SANDBOX_CLIENT_ID",
		"SANDBOX_CLIENT_SECRET"}
  allset := true
	for _, envar := range vars {
		if os.Getenv(envar) == "" {
			if debug {
        fmt.Fprintf(os.Stderr, "Missing environment variable %v\n", envar)
      }
      allset = false
		}
	}
	return allset
}


