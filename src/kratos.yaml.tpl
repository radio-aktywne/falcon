{{- define "obsidian.sql.url" -}}
{{- $host := ( ds "config" ).obsidian.sql.host -}}
{{- $port := ( ds "config" ).obsidian.sql.port -}}
{{- $password := ( ds "config" ).obsidian.sql.password -}}
cockroach://user:{{ print $password }}@{{ print $host }}:{{ print $port }}/database
{{- end -}}

{{- define "orchid.public.url" -}}
{{- $scheme := ( ds "config" ).orchid.public.scheme -}}
{{- $host := ( ds "config" ).orchid.public.host -}}
{{- $port := ( ds "config" ).orchid.public.port -}}
{{- $path := ( ds "config" ).orchid.public.path -}}
{{ print $scheme }}://{{ print $host }}{{ if test.IsKind "number" $port }}:{{ print $port }}{{ end }}{{ if test.IsKind "string" $path }}{{ print $path }}{{ end }}
{{- end -}}

# Self-service configuration.
selfservice:
  # Redirect browsers to set URL per default.
  # Ory Kratos redirects to this URL per default on completion of self-service flows and other browser interaction. Read this [article for more information on browser redirects](https://www.ory.sh/kratos/docs/concepts/browser-redirect-flow-completion).
  default_browser_return_url: "{{ template "orchid.public.url" . }}/default"

  # Allowed Return To URLs.
  # List of URLs that are allowed to be redirected to. A redirection request is made by appending `?return_to=...` to Login, Registration, and other self-service flows.
  allowed_return_urls:
    - "{{ template "orchid.public.url" . }}"

  # Configuration of self-service flows.
  flows:
    # Configuration of settings flow.
    settings:
      # URL of the Settings page.
      # URL where the Settings UI is hosted. Check the [reference implementation](https://github.com/ory/kratos-selfservice-ui-node).
      ui_url: "{{ template "orchid.public.url" . }}/settings"

      # Configuration of behavior after completing the flow.
      after:
        # Redirect browsers to set URL per default.
        # Ory Kratos redirects to this URL per default on completion of self-service flows and other browser interaction. Read this [article for more information on browser redirects](https://www.ory.sh/kratos/docs/concepts/browser-redirect-flow-completion).
        default_browser_return_url: "{{ template "orchid.public.url" . }}/settings/callback"

    # Configuration of registration flow.
    logout:
      # Configuration of behavior after completing the flow.
      after:
        # Redirect browsers to set URL per default.
        # Ory Kratos redirects to this URL per default on completion of self-service flows and other browser interaction. Read this [article for more information on browser redirects](https://www.ory.sh/kratos/docs/concepts/browser-redirect-flow-completion).
        default_browser_return_url: "{{ template "orchid.public.url" . }}/logout/callback"

    # Configuration of registration flow.
    registration:
      # Enable User Registration.
      # If set to true will enable [User Registration](https://www.ory.sh/kratos/docs/self-service/flows/user-registration/).
      enabled: true

      # Registration UI URL.
      # URL where the Registration UI is hosted. Check the [reference implementation](https://github.com/ory/kratos-selfservice-ui-node).
      ui_url: "{{ template "orchid.public.url" . }}/registration"

      # Configuration of behavior after completing the flow.
      after:
        # Redirect browsers to set URL per default.
        # Ory Kratos redirects to this URL per default on completion of self-service flows and other browser interaction. Read this [article for more information on browser redirects](https://www.ory.sh/kratos/docs/concepts/browser-redirect-flow-completion).
        default_browser_return_url: "{{ template "orchid.public.url" . }}/registration/callback"

        # Configuration of behavior after completing the flow when OIDC method is used.
        oidc:
          # Configuration of hooks.
          hooks:
            # Login users after registration.
            - hook: session

    # Configuration of login flow.
    login:
      # Login UI URL.
      # URL where the Login UI is hosted. Check the [reference implementation](https://github.com/ory/kratos-selfservice-ui-node).
      ui_url: "{{ template "orchid.public.url" . }}/login"

      # Configuration of behavior after completing the flow.
      after:
        # Redirect browsers to set URL per default.
        # Ory Kratos redirects to this URL per default on completion of self-service flows and other browser interaction. Read this [article for more information on browser redirects](https://www.ory.sh/kratos/docs/concepts/browser-redirect-flow-completion).
        default_browser_return_url: "{{ template "orchid.public.url" . }}/login/callback"

    # Configuration of recovery flow.
    verification:
      # Disable Email/Phone Verification.
      # If set to true will enable [Email and Phone Verification and Account Activation](https://www.ory.sh/kratos/docs/self-service/flows/verify-email-account-activation/).
      enabled: false

    # Configuration of recovery flow.
    recovery:
      # Disable Account Recovery.
      # If set to true will enable [Account Recovery](https://www.ory.sh/kratos/docs/self-service/flows/password-reset-account-recovery/).
      enabled: false

    # Configuration of error flow.
    error:
      # Ory Kratos Error UI URL.
      # URL where the Ory Kratos Error UI is hosted. Check the [reference implementation](https://github.com/ory/kratos-selfservice-ui-node).
      ui_url: "{{ template "orchid.public.url" . }}/error"

  # Configuration of self-service methods.
  methods:
    # Configuration of the profile method.
    profile:
      # Enable Profile Management Method.
      enabled: true

    # Configuration of the link method.
    link:
      # Disable Link Method.
      enabled: false

    # Configuration of the code method.
    code:
      # Disable Code Method.
      enabled: false

    # Configuration of the password method.
    password:
      # Disable Username/Email and Password Method.
      enabled: false

    # Configuration of the TOTP method.
    totp:
      # Disable the TOTP method.
      enabled: false

    # Configuration of the lookup secret method.
    lookup_secret:
      # Disable the lookup secret method.
      enabled: false

    # Configuration of the WebAuthn method.
    webauthn:
      # Disable the WebAuthn method.
      enabled: false

    # Configuration of the passkey method.
    passkey:
      # Disable the Passkey method.
      enabled: false

    # Configuration of the OIDC method.
    oidc:
      # Enable OpenID Connect Method.
      enabled: true

      # Configuration of the OIDC method.
      config:
        # OpenID Connect and OAuth2 Providers.
        # A list and configuration of OAuth2 and OpenID Connect providers Ory Kratos should integrate with.
        providers:
          # Configuration of the Google provider.
          - # Identifier of the provider.
            id: google

            # Type of the provider.
            provider: google

            # Client ID to authenticate with the provider.
            client_id: {{ ( ds "config" ).oidc.google.client | strings.Quote }}

            # Client Secret to authenticate with the provider.
            client_secret: {{ ( ds "config" ).oidc.google.secret | strings.Quote }}

            # Jsonnet Mapper URL.
            # The URL where the jsonnet source is located for mapping the provider's data to Ory Kratos data.
            mapper_url: {{ env.Getenv "KRATOS__MAPPERS__GOOGLE" | strings.Quote }}

            # Scopes to request from the provider.
            scope:
              - openid
              - profile
              - email

# Data Source Name.
# DSN is used to specify the database credentials as a connection URI.
dsn: {{ template "obsidian.sql.url" . | strings.Quote }}

# Controls the configuration for the http(s) daemon(s).
serve:
  # Controls the admin daemon serving administrative endpoints.
  admin:
    # Admin Base URL.
    # The URL where the admin endpoint is exposed at.
    base_url: {{ ( ds "config" ).urls.admin | strings.Quote }}

    # Admin Port.
    # The port kratos' admin endpoint listens on.
    port: {{ ( ds "config" ).server.ports.admin | conv.ToInt }}

    # Admin Host.
    # The host (interface) kratos' admin endpoint listens on.
    host: {{ ( ds "config" ).server.host | strings.Quote }}

  # Controls the public daemon serving public API endpoints.
  public:
    # Base URL.
    # The URL where the endpoint is exposed at. This domain is used to generate redirects, form URLs, and more.
    base_url: {{ ( ds "config" ).urls.public | strings.Quote }}

    # Public Port.
    # The port kratos' public endpoint listens on.
    port: {{ ( ds "config" ).server.ports.public | conv.ToInt }}

    # Public Host.
    # The host (interface) kratos' public endpoint listens on.
    host: {{ ( ds "config" ).server.host | strings.Quote }}

# Configuration of identities.
identity:
  # The default Identity Schema.
  # This Identity Schema will be used as the default for self-service flows. Its ID needs to exist in the "schemas" list.
  default_schema_id: "1"

  # All JSON Schemas for Identity Traits.
  # Note that identities that used the "default_schema_url" field in older kratos versions will be corrupted unless you specify their schema url with the id "default" in this list.
  schemas:
    - # The schema's ID.
      id: "1"

      # JSON Schema URL for identity traits schema.
      # URL for JSON Schema which describes a identity's traits. Can be a file path, a https URL, or a base64 encoded string.
      url: file://src/schemas/1.schema.json

# Configuration of secrets.
secrets:
  # Default Encryption Signing Secrets.
  # The first secret in the array is used for signing and encrypting things while all other keys are used to verify and decrypt older things that were signed with that old secret.
  default:
    {{- range ( ds "config" ).secrets.default }}
    - {{ . | strings.Quote }}
    {{- end }}

  # Signing Keys for Cookies.
  # The first secret in the array is used for encrypting cookies while all other keys are used to decrypt older cookies that were signed with that old secret.
  cookie:
    {{- range ( ds "config" ).secrets.cookie }}
    - {{ . | strings.Quote }}
    {{- end }}

  # Secrets to use for encryption by cipher.
  # The first secret in the array is used for encryption data while all other keys are used to decrypt older data that were signed with.
  cipher:
    {{- range ( ds "config" ).secrets.cipher }}
    - {{ . | strings.Quote }}
    {{- end }}

# HTTP Cookie Configuration.
# Configure the HTTP Cookies. Applies to both CSRF and session cookies.
cookies:
  # HTTP Cookie Same Site Configuration.
  # Sets the session and CSRF cookie SameSite.
  same_site: Lax

# Configuration of session.
session:
  # Session Lifespan.
  # Defines how long a session is active. Once that lifespan has been reached, the user needs to sign in again.
  lifespan: 720h

  # Configuration of session cookie.
  cookie:
    # Session Cookie Name.
    # Sets the session cookie name. Use with care!
    name: falcon-session

# The kratos version this config is written for.
# SemVer according to https://semver.org/ prefixed with `v` as in our releases.
version: v1.3.1
