#!/bin/sh

### Temporary files

tmpconfig="$(mktemp --suffix=.yaml)"
tmpgooglemapper="$(mktemp --suffix=.jsonnet)"
tmpkratosconfig="$(mktemp --suffix=.yaml)"

### Functions

# Cleanup function to remove temporary files
cleanup() {
	rm --force "${tmpconfig}" "${tmpgooglemapper}" "${tmpkratosconfig}"
}

# Function to fill values in the configuration file
fillconfig() {
	gomplate --file src/config.yaml.tpl --out "${1}"
}

# Function to fill values in the Google mapper
fillgooglemapper() {
	gomplate --file src/mappers/google.jsonnet.tpl --datasource config="${1}" --out "${2}"
}

# Function to fill values in the Ory Kratos configuration file
fillkratosconfig() {
	KRATOS__MAPPERS__GOOGLE="file://${2}" gomplate --file src/kratos.yaml.tpl --datasource config="${1}" --out "${3}"
}

# Function to setup ignoring signals
ignoresignals() {
	for signal in INT TERM HUP QUIT; do
		trap '' "${signal}"
	done
}

# Function to start migrations
startmigrations() {
	dsn="$(yq eval '.dsn' "${1}")"

	echo "Running migrations..."

	kratos migrate sql --yes --config "${1}" "${dsn}" &
}

# Function to start Ory Kratos
startkratos() {
	debug="$(yq eval '.debug' "${1}")"

	echo "Starting Ory Kratos..."

	# shellcheck disable=SC2046,SC2312
	kratos serve --sqa-opt-out $([ "${debug}" = "true" ] && echo "--dev") --config "${2}" &
}

# Function to setup signal handling
handlesignals() {
	for signal in INT HUP; do
		trap 'kill -TERM '"${1}"'; wait '"${1}"'; status=$?; cleanup; exit "${status}"' "${signal}"
	done

	for signal in TERM QUIT; do
		trap 'kill -'"${signal}"' '"${1}"'; wait '"${1}"'; status=$?; cleanup; exit "${status}"' "${signal}"
	done
}

# Function to wait for Ory Kratos to exit and handle cleanup
waitandcleanup() {
	wait "${1}"
	status=$?

	# Cleanup temporary files
	cleanup

	exit "${status}"
}

### Main script execution

# Fill values in files
fillconfig "${tmpconfig}"
fillgooglemapper "${tmpconfig}" "${tmpgooglemapper}"
fillkratosconfig "${tmpconfig}" "${tmpgooglemapper}" "${tmpkratosconfig}"

# Temporarily ignore signals
ignoresignals

# Run migrations
startmigrations "${tmpkratosconfig}"

# Setup signal handling
pid=$!
handlesignals "${pid}"

# Wait for migrations to complete
wait "${pid}"

# Temporarily ignore signals
ignoresignals

# Start Ory Kratos in the background
startkratos "${tmpconfig}" "${tmpkratosconfig}"

# Setup signal handling
pid=$!
handlesignals "${pid}"

# Wait for Ory Kratos to exit
waitandcleanup "${pid}"
