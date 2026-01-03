# Configuration for the cookies
cookies:
  # Domain for the cookies
  domain: {{ env.Getenv "FALCON__COOKIES__DOMAIN" | strings.Quote | strings.TrimPrefix `""` | default "null" }}

# Enable debug mode
debug: {{ env.Getenv "FALCON__DEBUG" "true" | conv.ToBool }}

# Configuration of the obsidian database
obsidian:
  # Configuration of the SQL API of the obsidian database
  sql:
    # Host of the SQL API
    host: {{ env.Getenv "FALCON__OBSIDIAN__SQL__HOST" "localhost" | strings.Quote }}

    # Password to authenticate with the SQL API
    password: {{ env.Getenv "FALCON__OBSIDIAN__SQL__PASSWORD" "password" | strings.Quote }}

    # Port of the SQL API
    port: {{ env.Getenv "FALCON__OBSIDIAN__SQL__PORT" "20110" | conv.ToInt }}

# Configuration of the OIDC Identity Providers
oidc:
  # Configuration of Google IdP
  google:
    # Client ID to authenticate with the IdP
    client: {{ env.Getenv "FALCON__OIDC__GOOGLE__CLIENT" "falcon" | strings.Quote }}

    # Domain of the Google organization
    domain: {{ env.Getenv "FALCON__OIDC__GOOGLE__DOMAIN" | strings.Quote | strings.TrimPrefix `""` | default "null" }}

    # Client secret to authenticate with the IdP
    secret: {{ env.Getenv "FALCON__OIDC__GOOGLE__SECRET" "secret" | strings.Quote }}

# Configuration of the orchid app
orchid:
  # Configuration of the public site of the orchid app
  public:
    # Host of the public site
    host: {{ env.Getenv "FALCON__ORCHID__PUBLIC__HOST" "localhost" | strings.Quote }}

    # Path of the public site
    path: {{ env.Getenv "FALCON__ORCHID__PUBLIC__PATH" | strings.Quote | strings.TrimPrefix `""` | default "null" }}

    # Port of the public site
    port: {{ env.Getenv "FALCON__ORCHID__PUBLIC__PORT" "20120" | default "null" }}

    # Scheme of the public site
    scheme: {{ env.Getenv "FALCON__ORCHID__PUBLIC__SCHEME" "http" | strings.Quote }}

# Configuration of the secrets
secrets:
  # Cipher secrets
  cipher:
    {{- range ( env.Getenv "FALCON__SECRETS__CIPHER" "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX" | strings.Split "," ) }}
    - {{ . | strings.Quote }}
    {{- end }}

  # Cookie secrets
  cookie:
    {{- range ( env.Getenv "FALCON__SECRETS__COOKIE" "XXXXXXXXXXXXXXXX" | strings.Split "," ) }}
    - {{ . | strings.Quote }}
    {{- end }}

  # Default secrets
  default:
    {{- range ( env.Getenv "FALCON__SECRETS__DEFAULT" "XXXXXXXXXXXXXXXX" | strings.Split "," ) }}
    - {{ . | strings.Quote }}
    {{- end }}

# Configuration of the server
server:
  # Host to run the server on
  host: {{ env.Getenv "FALCON__SERVER__HOST" "0.0.0.0" | strings.Quote }}

  # Configuration of server ports
  ports:
    # Port for admin traffic
    admin: {{ env.Getenv "FALCON__SERVER__PORTS__ADMIN" "20101" | conv.ToInt }}

    # Port for public traffic
    public: {{ env.Getenv "FALCON__SERVER__PORTS__PUBLIC" "20100" | conv.ToInt }}

# Configuration of the URLs
urls:
  # Admin URL
  admin: {{ env.Getenv "FALCON__URLS__ADMIN" "http://localhost:20101" | strings.Quote }}

  # Public URL
  public: {{ env.Getenv "FALCON__URLS__PUBLIC" "http://localhost:20100" | strings.Quote }}
