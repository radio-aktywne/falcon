#!/bin/sh

tmpconfig="$(mktemp --suffix=.yaml)"

# Fill values in the configuration file
gomplate \
	--file src/config.yaml.tpl \
	--out "${tmpconfig}"

tmpgooglemapper="$(mktemp --suffix=.jsonnet)"

# Fill values in mappers
gomplate \
	--file src/mappers/google.jsonnet.tpl \
	--datasource config="${tmpconfig}" \
	--out "${tmpgooglemapper}"

tmpkratos="$(mktemp --suffix=.yaml)"

# Fill values in the Ory Kratos configuration file
KRATOS__MAPPERS__GOOGLE="file://${tmpgooglemapper}" \
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
rm --force "${tmpconfig}" "${tmpgooglemapper}" "${tmpkratos}"
