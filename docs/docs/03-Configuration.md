---
slug: /config
title: Configuration
---

## Environment variables

You can configure the service at runtime using various environment variables:

- `FALCON__COOKIES__DOMAIN` -
  domain for the cookies
  (default: ``)
- `FALCON__DEBUG` -
  enable debug mode
  (default: `true`)
- `FALCON__OBSIDIAN__SQL__HOST` -
  host of the SQL API of the obsidian database
  (default: `localhost`)
- `FALCON__OBSIDIAN__SQL__PASSWORD` -
  password to authenticate with the SQL API of the obsidian database
  (default: `password`)
- `FALCON__OBSIDIAN__SQL__PORT` -
  port of the SQL API of the obsidian database
  (default: `20110`)
- `FALCON__OIDC__GOOGLE__CLIENT` -
  client ID to authenticate with Google IdP
  (default: `falcon`)
- `FALCON__OIDC__GOOGLE__DOMAIN` -
  domain of the Google organization
  (default: ``)
- `FALCON__OIDC__GOOGLE__SECRET` -
  client secret to authenticate with Google IdP
  (default: `secret`)
- `FALCON__ORCHID__PUBLIC__HOST` -
  host of the public site of the orchid app
  (default: `localhost`)
- `FALCON__ORCHID__PUBLIC__PATH` -
  path of the public site of the orchid app
  (default: ``)
- `FALCON__ORCHID__PUBLIC__PORT` -
  port of the public site of the orchid app
  (default: `20120`)
- `FALCON__ORCHID__PUBLIC__SCHEME` -
  scheme of the public site of the orchid app
  (default: `http`)
- `FALCON__SECRETS__CIPHER` -
  cipher secrets
  (default: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)
- `FALCON__SECRETS__COOKIE` -
  cookie secrets
  (default: `XXXXXXXXXXXXXXXX`)
- `FALCON__SECRETS__DEFAULT` -
  default secrets
  (default: `XXXXXXXXXXXXXXXX`)
- `FALCON__SERVER__HOST` -
  host to run the server on
  (default: `0.0.0.0`)
- `FALCON__SERVER__PORTS__ADMIN` -
  port for admin traffic
  (default: `20101`)
- `FALCON__SERVER__PORTS__PUBLIC` -
  port for public traffic
  (default: `20100`)
- `FALCON__URLS__ADMIN` -
  admin URL
  (default: `http://localhost:20101`)
- `FALCON__URLS__PUBLIC` -
  public URL
  (default: `http://localhost:20100`)
