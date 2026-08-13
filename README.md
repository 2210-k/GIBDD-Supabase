# GIBDD-Supabase

Закрытая веб-система ГИБДД/ДПС на Supabase.

## Структура

- `index.html` — интерфейс приложения.
- `css/style.css` — дизайн в стиле исходного GIBDD.
- `js/supabase.js` — клиент Supabase.
- `js/auth.js` — вход/выход через Supabase Auth.
- `js/app.js` — рабочая логика, CRUD, поиск и статистика.
- `supabase/schema.sql` — структура базы, профили инспекторов и RLS.

## Перед запуском

1. В Supabase создай проект.
2. В Authentication → Users создай первого пользователя.
3. В `js/supabase.js` укажи Project URL и anon/public key.
4. Выполни `supabase/schema.sql` в SQL Editor.
5. После создания Auth-пользователя добавь его профиль в `inspectors` через SQL.

Пароли и `service_role` ключ в GitHub не добавляются. Для браузера используется только публичный anon key.
