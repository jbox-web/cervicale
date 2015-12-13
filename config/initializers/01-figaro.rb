RAILS_REQUIRED_KEYS = [
  'DB_ADAPTER',
  'DB_HOST',
  'DB_PORT',
  'DB_NAME',
  'DB_USER',
  'DB_PASS',
  'SECRET_KEY_BASE'
]

EASY_APP_REQUIRED_KEYS = [
  'OWNER_NAME',
  'OWNER_URL'
]

FIGARO_REQUIRED_KEYS = RAILS_REQUIRED_KEYS + EASY_APP_REQUIRED_KEYS

Figaro.require_keys(*FIGARO_REQUIRED_KEYS)