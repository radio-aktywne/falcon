#!/bin/sh

tmpconfig="$(mktemp --suffix=.yaml)"

# Fill values in the configuration file
gomplate \
	--file src/config.yaml.tpl \
	--out "${tmpconfig}"

tmpkratos="$(mktemp --suffix=.yaml)"

# Fill values in the Ory Kratos configuration file
gomplate \
	--file src/kratos.yaml.tpl \
	--datasource config="${tmpconfig}" \
	--out "${tmpkratos}"

# Run migrations
# shellcheck disable=SC2312
kratos \
	migrate \
	sql \
	--yes \
	--config "${tmpkratos}" \
	"$(yq eval '.dsn' "${tmpkratos}")"

# Start Ory Kratos
# shellcheck disable=SC2046,SC2312
kratos \
	serve \
	--sqa-opt-out \
	$([ "$(yq eval '.debug' "${tmpconfig}")" = "true" ] && echo "--dev") \
	--config "${tmpkratos}"

# Clean up
rm --force "${tmpconfig}" "${tmpkratos}"
