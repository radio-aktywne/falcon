local claims = std.extVar('claims');

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
