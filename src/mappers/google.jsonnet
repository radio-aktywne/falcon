local claims = std.extVar('claims');

{
  identity: {
    traits: {
      [if 'name' in claims then 'names']: {
        [if 'name' in claims then 'display']: claims.name,
      },
      [if 'picture' in claims then 'pictures']: {
        [if 'picture' in claims then 'profile']: {
          [if 'picture' in claims then 'url']: claims.picture,
        },
      },
      [if 'locale' in claims then 'locales']: {
        [if 'locale' in claims then 'preferred']: claims.locale,
      },
    },
  },
}
