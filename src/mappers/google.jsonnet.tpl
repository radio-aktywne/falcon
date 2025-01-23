local claims = std.extVar('claims');
local domain = '{{ ( ds "config" ).oidc.google.domain | default "" }}';

if domain != '' && !('hd' in claims) then
  error '"hd" claim is missing'
else if domain != '' && claims.hd != domain then
  error '"hd" claim is invalid'
else
  {
    identity: {
      traits: {
        names: {
          [if 'name' in claims then 'display']: claims.name,
        },
        pictures: {
          profile: {
            [if 'picture' in claims then 'url']: claims.picture,
          },
        },
        locales: {
          [if 'locale' in claims then 'preferred']: claims.locale,
        },
      },
    },
  }
