backend/
│
├── app/
│   ├── Core/
│   │   ├── Contracts/
│   │   ├── Enums/
│   │   ├── Exceptions/
│   │   └── Traits/
│   │
│   ├── DTO/
│   │   ├── Auth/
│   │   └── ...
│   │
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── Admin/
│   │   │       ├── Auth/
│   │   │       └── Public/
│   │   │
│   │   ├── Middleware/
│   │   ├── Requests/
│   │   │   ├── Auth/
│   │   │   └── ...
│   │   │
│   │   └── Resources/
│   │       ├── BaseCollection.php
│   │       ├── Auth/
│   │       └── ...
│   │
│   ├── Models/
│   ├── Repositories/
│   ├── Services/
│   └── Providers/
│
├── bootstrap/
├── config/
├── database/
│   ├── factories/
│   ├── migrations/
│   └── seeders/
│
├── docs/
├── public/
├── resources/
├── routes/
│   └── api/
│       ├── admin/
│       ├── auth.php
│       └── public.php
│
├── storage/
├── tests/
│   ├── Feature/
│   └── Unit/
│
├── artisan
├── composer.json
├── phpunit.xml
├── .env
└── .env.example