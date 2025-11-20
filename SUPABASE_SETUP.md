# Налаштування Supabase для форм контакту

## Крок 1: Створення проекту в Supabase

1. Перейдіть на [https://supabase.com](https://supabase.com)
2. Створіть обліковий запис або увійдіть
3. Створіть новий проект
4. Запишіть URL проекту та API ключі

## Крок 2: Створення таблиць в базі даних

Вам потрібно створити 4 окремі таблиці для кожного типу форми.

**Швидкий спосіб:** Використайте готовий SQL скрипт `supabase_tables.sql` з кореня проекту. Просто скопіюйте весь вміст файлу та виконайте його в Supabase SQL Editor - це створить всі таблиці, політики та індекси автоматично.

**Або створіть таблиці вручну:**

### Таблиця 1: General Inquiries (`general_inquiries`)

1. У вашому проекті Supabase перейдіть до **Table Editor**
2. Натисніть **New Table**
3. Назвіть таблицю: `general_inquiries`
4. Додайте наступні колонки:

| Column Name | Type        | Default Value     | Nullable         |
| ----------- | ----------- | ----------------- | ---------------- |
| id          | uuid        | gen_random_uuid() | No (Primary Key) |
| name        | text        | -                 | No               |
| email       | text        | -                 | No               |
| subject     | text        | -                 | No               |
| message     | text        | -                 | No               |
| created_at  | timestamptz | now()             | No               |

5. Натисніть **Save**

### Таблиця 2: Commission Requests (`commission_requests`)

1. Натисніть **New Table**
2. Назвіть таблицю: `commission_requests`
3. Додайте наступні колонки:

| Column Name          | Type        | Default Value     | Nullable         |
| -------------------- | ----------- | ----------------- | ---------------- |
| id                   | uuid        | gen_random_uuid() | No (Primary Key) |
| name                 | text        | -                 | No               |
| email                | text        | -                 | No               |
| purpose              | text        | -                 | No               |
| recipient            | text        | -                 | No               |
| size                 | text        | -                 | No               |
| medium               | text        | -                 | No               |
| display_context      | text        | -                 | No               |
| coa_registration     | text        | -                 | No               |
| ownership_preference | text        | -                 | No               |
| additional_notes     | text        | -                 | Yes              |
| created_at           | timestamptz | now()             | No               |

4. Натисніть **Save**

### Таблиця 3: Appraisal Requests (`appraisal_requests`)

1. Натисніть **New Table**
2. Назвіть таблицю: `appraisal_requests`
3. Додайте наступні колонки:

| Column Name       | Type        | Default Value     | Nullable         |
| ----------------- | ----------- | ----------------- | ---------------- |
| id                | uuid        | gen_random_uuid() | No (Primary Key) |
| collector_name    | text        | -                 | No               |
| email             | text        | -                 | No               |
| phone             | text        | -                 | Yes              |
| artwork_title     | text        | -                 | No               |
| proof_file        | text        | -                 | Yes              |
| condition_notes   | text        | -                 | No               |
| appraisal_purpose | text        | -                 | No               |
| additional_info   | text        | -                 | Yes              |
| created_at        | timestamptz | now()             | No               |

4. Натисніть **Save**

### Таблиця 4: Registry Enrollments (`registry_enrollments`)

1. Натисніть **New Table**
2. Назвіть таблицю: `registry_enrollments`
3. Додайте наступні колонки:

| Column Name      | Type        | Default Value     | Nullable         |
| ---------------- | ----------- | ----------------- | ---------------- |
| id               | uuid        | gen_random_uuid() | No (Primary Key) |
| collector_name   | text        | -                 | No               |
| email            | text        | -                 | No               |
| phone            | text        | -                 | Yes              |
| address          | text        | -                 | Yes              |
| owned_artworks   | text        | -                 | No               |
| registry_consent | text        | -                 | No               |
| annual_appraisal | text        | -                 | No               |
| additional_notes | text        | -                 | Yes              |
| created_at       | timestamptz | now()             | No               |

4. Натисніть **Save**

## Крок 3: Налаштування Row Level Security (RLS)

**Якщо ви використали SQL скрипт `supabase_tables.sql`**, RLS вже налаштовано автоматично. Пропустіть цей крок.

**Якщо створювали таблиці вручну**, для кожної таблиці потрібно налаштувати RLS:

1. Перейдіть до **Authentication** → **Policies**
2. Для кожної таблиці (`general_inquiries`, `commission_requests`, `appraisal_requests`, `registry_enrollments`) створіть політику:
   - **Policy Name**: Allow public inserts
   - **Allowed Operation**: INSERT
   - **Target Roles**: anon, authenticated
   - **USING expression**: `true`
   - **WITH CHECK expression**: `true`

Або виконайте SQL запити в **SQL Editor** для всіх таблиць одночасно (включено в `supabase_tables.sql`):

```sql
-- Enable RLS for all tables
ALTER TABLE general_inquiries ENABLE ROW LEVEL SECURITY;
ALTER TABLE commission_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE appraisal_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE registry_enrollments ENABLE ROW LEVEL SECURITY;

-- Create policies for all tables
CREATE POLICY "Allow public inserts" ON general_inquiries
FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "Allow public inserts" ON commission_requests
FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "Allow public inserts" ON appraisal_requests
FOR INSERT TO anon, authenticated WITH CHECK (true);

CREATE POLICY "Allow public inserts" ON registry_enrollments
FOR INSERT TO anon, authenticated WITH CHECK (true);
```

## Крок 4: Отримання API ключів

1. Перейдіть до **Settings** → **API**
2. Скопіюйте:
   - **Project URL** (це ваш `SUPABASE_URL`)
   - **anon/public key** (це ваш `SUPABASE_ANON_KEY`)

## Крок 5: Налаштування в коді

1. Відкрийте файл `contact.html`
2. Знайдіть рядки з конфігурацією Supabase (близько рядка 4310-4311)
3. Замініть значення:

```javascript
const SUPABASE_URL = 'https://ваш-проект.supabase.co';
const SUPABASE_ANON_KEY = 'ваш-anon-ключ';
```

## Перевірка роботи

1. Відкрийте `contact.html` у браузері
2. Виберіть тип форми з дропдауну
3. Заповніть форму
4. Натисніть кнопку відправки
5. Перевірте в Supabase Table Editor відповідну таблицю, чи з'явився новий запис

## Структура таблиць

### general_inquiries

- Зберігає загальні запити від користувачів
- Поля: name, email, subject, message

### commission_requests

- Зберігає запити на створення кастомних робіт
- Поля: name, email, purpose, recipient, size, medium, display_context, coa_registration, ownership_preference, additional_notes

### appraisal_requests

- Зберігає запити на оцінку та документацію робіт
- Поля: collector_name, email, phone, artwork_title, proof_file, condition_notes, appraisal_purpose, additional_info

### registry_enrollments

- Зберігає реєстрації колекціонерів
- Поля: collector_name, email, phone, address, owned_artworks, registry_consent, annual_appraisal, additional_notes

## Примітки

- `SUPABASE_ANON_KEY` - це публічний ключ, який безпечно використовувати на клієнті
- RLS (Row Level Security) дозволяє контролювати доступ до даних
- Всі повідомлення зберігаються в відповідних таблицях залежно від типу форми
- Ви можете переглядати повідомлення в Supabase Dashboard → Table Editor
- Завантаження файлів (для appraisal form) поки що зберігається як текст (ім'я файлу). Для повної підтримки файлів потрібно налаштувати Supabase Storage.

## Додаткові налаштування (опціонально)

### Надсилання email-сповіщень

Ви можете налаштувати Supabase Edge Functions для надсилання email-сповіщень при отриманні нового повідомлення через Database Webhooks або Edge Functions.

### Експорт даних

Всі дані можна експортувати з Supabase Dashboard або через SQL запити.

### Зберігання файлів

Для повної підтримки завантаження файлів (appraisal form) налаштуйте Supabase Storage:

1. Перейдіть до **Storage**
2. Створіть bucket для файлів
3. Налаштуйте політики доступу
4. Оновіть JavaScript код для завантаження файлів через Supabase Storage API
