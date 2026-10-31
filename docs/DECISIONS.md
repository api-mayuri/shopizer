# Решения, принятые во время миграции

Здесь собраны решения, которые я принимал сам, пока тебя не было. По каждому: что выбрано, почему и какие были варианты.
Если с каким-то решением не согласен, его можно пересмотреть. Почти все они локальные и откатываются точечно.

Формат: **Решение** → *Почему* → *Альтернативы*.

---

## Общее

### D-01. Ветки и коммиты
- **Решение:** каждый шаг лежит в своей ветке: `migration/step1-boot27-java17`, `migration/step2-boot35-java21`, ...
  Каждая следующая ветка создаётся от предыдущей. Коммиты без строк соавторства (`Co-Authored-By`), как ты просил.
  **Ничего не пушится.** Исключение: ветка `migration/step0-baseline` и тег `migration-baseline` ушли на GitHub
  до твоего сообщения «не пушь». Удалять их с GitHub я не стал: это действие на удалённом репозитории.
- *Почему:* шаги можно ревьюить и откатывать по одному. Если какой-то шаг не нравится, его ветку можно пересобрать.
- *Альтернативы:* одна ветка с тегами на каждый шаг; отдельные PR.

### D-02. Автор коммитов
- **Решение:** в git-конфиге контейнера уже был указан автор `Claude <noreply@anthropic.com>`. Я оставил его и убрал только
  трейлеры `Co-Authored-By` и `Claude-Session`. Если нужно, чтобы автором был ты:
  `git rebase -r <base> --exec 'git commit --amend --no-edit --reset-author'`.
- *Альтернативы:* сразу подставить твой email. Не стал: ты просил не указывать автора, а не указать тебя.

### D-03. Критерий готовности шага
- **Решение:** `mvn -B -ntp install` (сборка и все тесты) + `scripts/smoke.sh`.
  Smoke поднимает приложение на H2 и проверяет: health, публичные API, 401 на приватных, `/v3/api-docs`,
  логин админа по JWT и запрос с токеном, 401 при неверном пароле, регистрацию и логин покупателя, профиль с токеном и без.
- *Почему:* тестов в проекте мало (около 40 реально выполняемых), и в основном они про каталог. Безопасность и JWT они почти не
  покрывают, а при переходе на Spring Security 6 ломается именно это.
- **Проверка самого smoke:** расширенный smoke я прогнал и на исходном коде (baseline). Все проверки безопасности дают
  те же коды, отличается только `/v3/api-docs` (на baseline его нет).

### D-04. Окружение сборки
- В контейнере изначально был только JDK 21. JDK 17 и 25 я поставил из репозиториев Ubuntu (`openjdk-17/25-jdk-headless`).
  Каждый шаг собирается на своей целевой версии JDK.
- Maven Central (`repo.maven.apache.org`) начал отвечать 429 (rate limit). В `~/.m2/settings.xml` **контейнера** прописано
  зеркало Google (`maven-central.storage-download.googleapis.com`). В репозиторий это не попадает.

### D-05. Пропущенные тесты
- В проекте 17 файлов с `@Ignore`/`@Disabled`, они пропускались и до миграции. Я их **не включал**: цель — «тесты проходят»
  на том же наборе, что и раньше. Включать их — отдельная задача, многие ходят во внешние сервисы.
- После перехода на JUnit 5 число «Tests run» в отчёте уменьшилось (28→21 в ядре, 33→31 в shop). Причина в том, что JUnit 5
  считает отключённый класс одним пропуском, а не каждый его метод. **Число реально выполненных тестов не изменилось:**
  15 в ядре, 25 в shop.

---

## Шаг 1. Spring Boot 2.5.12 → 2.7.18, Java 11 → 17

### D-10. Циклические зависимости бинов
- **Решение:** `spring.main.allow-circular-references=true` (в `application.properties` приложения и в тестовых properties).
- *Почему:* с Boot 2.6 циклы запрещены по умолчанию, а в сервисах Shopizer их много (`ProductService` ↔ `CategoryService` и т.д.).
  Разбирать их во время апгрейда фреймворка значит менять бизнес-код вместе с инфраструктурой.
- *Альтернативы:* разорвать циклы через `@Lazy` или рефакторинг. **Это техдолг**, логично сделать на этапе плагинной архитектуры:
  там всё равно переписываем конфигурацию ядра.

### D-11. H2 2.x
- **Решение:** перейти на H2 2.x, который идёт с Boot 2.7, и убрать `mv_store=false` из JDBC URL (в H2 2 нет старого PageStore).
- *Альтернативы:* закрепить H2 1.4.200. Отказался: это тупик, Boot 3 его не поддерживает.
- ⚠️ Старые файлы БД H2 1.x (например `SALESMANAGER.h2.db` для Docker-образа) H2 2 не открывает. Для Docker-профиля база
  создастся заново (`hbm2ddl=update` + инициализация данных при старте).

### D-12. Swagger: springfox → springdoc-openapi 1.8.0
- **Решение:** перешёл на springdoc. Аннотации конвертированы рецептом OpenRewrite `SpringFoxToSpringDoc`
  (`@Api`→`@Tag`, `@ApiOperation`→`@Operation`, `@ApiImplicitParam`→`@Parameter`, `@ApiIgnore`→`@Parameter(hidden = true)` …).
  `DocumentationConfiguration` переписан вручную (OpenAPI + JWT bearer + `GroupedOpenApi` по пакетам api.v1/v2).
- *Почему:* springfox мёртв и падает на Boot 2.6+ (NPE в `documentationPluginsBootstrapper`).
- Новые адреса: `/v3/api-docs`, `/swagger-ui.html` (вместо `/v2/api-docs`).
- *Альтернативы:* держать springfox через `spring.mvc.pathmatch.matching-strategy=ant_path_matcher`. Работает только до Boot 3.
- Рецепт оставил на контроллерах `@OpenAPIDefinition(tags=…)` (бывший `@SwaggerDefinition`). Он безвреден, springdoc берёт
  одно определение. Почистить можно потом.

### D-13. Найден и исправлен баг в маппинге
- В `ProductImageApi` был путь `/auth/product/{id}/image/{id}`: `{id}` указан дважды, и `imageId` на этом пути никогда не связывался.
  Новый парсер путей (`PathPatternParser`) такое запрещает. Исправил на `{imageId}`.

### D-14. Spring Security: `WebSecurityConfigurerAdapter` → бины `SecurityFilterChain`
- **Решение:** переписал уже на шаге 1 (Security 5.7 это поддерживает), чтобы на шаге Boot 3 не делать всё сразу.
  Четыре цепочки (`/shop/**`, `/services/**`, `/api/v*/private/**`, `/api/v*/auth/**`) с тем же порядком и правилами.
  У каждой свой `AuthenticationManager`, собранный так же, как раньше: `ProviderManager` + `DaoAuthenticationProvider`
  (свой `UserDetailsService` + BCrypt). У admin-API, как и раньше, вторым провайдером стоит `JWTAdminAuthenticationProvider`.
- Spring Security требует один главный `AuthenticationManager`, поэтому добавлен `@Primary` менеджер-заглушка,
  который никого не аутентифицирует. В трёх местах внедрения (`AuthenticateUserApi`, `AuthenticateCustomerApi`,
  `CustomerFacadeImpl`) поставлены явные `@Qualifier`. Раньше бин находился по имени поля.
- *Альтернативы:* оставить адаптер до шага Boot 3, где он удалён. Отказался: проверять переписанную безопасность
  проще на версии, где всё остальное уже работает.
- Попутно: два бина `authenticationProvider` (JWT admin и customer) с одинаковым именем молча перекрывали друг друга.
  Теперь у них разные имена.

### D-15. JUnit 4 → JUnit 5
- **Решение:** рецепт OpenRewrite `JUnit4to5Migration` + ручная замена оставшихся `@RunWith(SpringRunner)` на
  `@ExtendWith(SpringExtension)`. `junit-vintage-engine` удалён (в Boot 3 его всё равно нет).
- Рецепт добавлял `hamcrest-junit` во все pom'ы. Я его убрал: hamcrest и так приходит с `spring-boot-starter-test`.

### D-16. Что рецепт удалил попутно
- Из корневого `pom.xml` удалены закомментированные блоки oracle/postgres-зависимостей. Postgres вернётся нормальной
  зависимостью на шаге 3.

---

## Шаг 2. Spring Boot 2.7.18 → 3.5.16, Java 17 → 21

Основной инструмент — рецепты OpenRewrite (`UpgradeSpringBoot_3_5` + `UpgradeToJava21` + `MigrateToHibernate66`).
Они перевели javax→jakarta (≈700 файлов), Security 6, springdoc 2, HttpClient 5 и т.д.

### D-20. pom.xml рецептом не принят, переписан руками
- Рецепт испортил `dependencyManagement`: дубли, версия `6.0.x`, закреплённый `hibernate-ehcache 5.6`, Ehcache 2,
  milestone-версия `commons-fileupload 2.0.0-M4`. Я откатил pom'ы и перенёс изменения вручную:
  - убраны переопределения версий, которыми управляет Boot: jackson, postgresql (стояла 42.2.18!), commons-lang3, elasticsearch;
  - `javax.*` → `jakarta.*` (inject, validation, annotation, mail → `jakarta.mail-api` + `angus-mail`);
  - `mysql:mysql-connector-java` → `com.mysql:mysql-connector-j`;
  - `commons-fileupload` удалён (в коде не используется);
  - HttpClient 4 → `httpclient5` (рецепт перевёл UPS/USPS/Captcha на API 5);
  - mapstruct 1.3 → 1.6.3 (поддержка Java 21);
  - `maven.compiler.source/target` → `<release>${java.version}</release>`; убран отдельный `java.version` в `sm-core-model`.

### D-21. Кэш: Ehcache 2 → Ehcache 3 (JCache)
- `hibernate-ehcache` и `EhCacheCacheManager` удалены из Hibernate 6 и Spring 6.
- **Решение:** Ehcache 3 через JCache и для Spring Cache, и для L2-кэша Hibernate. Используется **один** `javax.cache.CacheManager`
  (бин `jCacheManager`, Hibernate получает его через `hibernate.javax.cache.cache_manager`).
  Конфиг `spring/ehcache3.xml`: те же регионы и размеры. В Ehcache 3 у кэша один тип истечения, поэтому пары TTI/TTL с одинаковыми
  значениями превратились в TTL. XML-конфиг `shopizer-core-ehcache.xml` заменён на `CacheConfiguration.java`.
- `CacheUtils` перебирал ключи через нативный API Ehcache 2, теперь перебирает через `javax.cache.Cache`.
- *Альтернативы:* Caffeine (проще, но нужен другой провайдер для L2 Hibernate); отключить L2-кэш (он работает только для Country/Currency/Language).

### D-22. Длинные текстовые колонки
- Рецепт **молча удалил** `@Type(type="org.hibernate.type.TextType")` у 8 полей (описания, комментарии, логи, конфиги).
  Без аннотации колонки стали бы `varchar(255)`, и при создании новой схемы длинные тексты обрезались бы.
- **Решение:** `@JdbcTypeCode(SqlTypes.LONG32VARCHAR)`. Это `text` в PostgreSQL, `longtext` в MySQL, `character varying` в H2.
- `@Type(type="locale")` удалён: Hibernate 6 маппит `Locale` нативно в тот же varchar.

### D-23. Hibernate 6.6 строже к маппингам и JPQL (исправлено в коде)
- `@Inheritance` и `@Table` на `@MappedSuperclass` удалены. JPA их всегда игнорировал, Hibernate 6 отвергает. Имена таблиц не меняются.
- `@JoinTable(... updatable = false)` → без `updatable` (6 мест): для связующей таблицы это ничего не значило.
- JPQL: повторный `join fetch` одного и того же пути (17 запросов в `@Query` и 8 мест в построителях запросов в Java-коде),
  а также один алиас для двух путей (`m.country mc` + `m.currency mc`, 6 запросов).
  Исправлено скриптами: повтор удалён, второй алиас переименован. На результат запросов это не влияет.
- Нативный запрос `findBySku` теперь возвращает `Long`, а не `BigInteger` → приведение через `Number`.

### D-24. ⚠️ id = 0 у новых сущностей (важно)
- DTO Shopizer приходят с `id = 0`, мапперы копируют это в сущность → Spring Data делает `merge()`.
  Hibernate 5 вставлял такую строку, а Hibernate 6.6 бросает *"Row was updated or deleted by another transaction"*.
- **Решение:** `ZeroIdMergeEventListener` подключён через Hibernate `Integrator` (`META-INF/services`). Если у сущности
  **сгенерированный** id равен `0`, слушатель считает её новой. Это одно место на весь проект, включая каскады.
- *Альтернативы:* править каждый маппер (их десятки, легко пропустить); реализовать `Persistable.isNew()` в базовом классе
  (не покрывает сущности не из `SalesManagerEntity` и каскады).
- Правильное долгосрочное решение — DTO с `Long id = null`. Это задача на рефакторинг.

### D-25. ⚠️ Генераторы id (`@TableGenerator`) и существующие данные
- В Hibernate 5 был выставлен `hibernate.id.new_generator_mappings=false`, то есть старый hilo-режим `@TableGenerator`
  (80 сущностей, таблица `SM_SEQUENCER`). В Hibernate 6 этого режима нет.
- Для **новой** БД (H2, новый PostgreSQL) это неважно. Для **существующей** БД MySQL значения в `SM_SEQUENCER` нужно
  выставить не ниже `max(id)+1` каждой таблицы, иначе возможны конфликты ключей. Это часть переноса данных на шаге 3.

### D-26. Bean Validation: поведение сохранено (валидация выключена, как и было)
- Неожиданная находка: **в исходном проекте валидация не работала совсем**. С Boot 2.3+ провайдер (hibernate-validator)
  не входит в `starter-web`, а в проекте его не было. Аннотации `@NotEmpty`, `@Pattern`, `@Valid` ничего не проверяли.
- springdoc 2 подтягивает hibernate-validator (и без него `/v3/api-docs` падает). Валидация включилась сама и сломала
  тесты: например, API создаёт продукт без `sku`, а `Product.sku` помечен `@NotEmpty`.
- **Решение:** провайдер на classpath оставлен, но валидация явно выключена в двух местах:
  - JPA: `jakarta.persistence.validation.mode=none` (`DataConfiguration`);
  - MVC: no-op `Validator` в `ShopApplicationConfiguration.getValidator()`.
- Включить валидацию = удалить эти два места. Но это **изменение поведения API**: клиенты начнут получать 400 там, где раньше
  получали 200. Нужна отдельная задача с проверкой мобильного/веб-клиента.

### D-27. Слеш в конце URL
- Spring 6 убрал сопоставление `/path/` с `/path`. Тесты (и, вероятно, клиенты) вызывают `/api/v1/cart/`, `/api/v1/private/tax/class/`.
- **Решение:** `UrlHandlerFilter.trailingSlashHandler("/**").wrapRequest()`. Это рекомендованная Spring замена,
  она есть и в Spring 7. Фильтр стоит первым и прозрачно убирает слеш в конце. Четыре маппинга, объявленные со слешем
  в конце (`/private/user/`, `/auth/customer/`, `/private/content/`), приведены к виду без слеша.
- *Альтернативы:* `setUseTrailingSlashMatch(true)` (удалён в Spring 7), дублировать пути во всех контроллерах.

### D-28. Сторонние зависимости, которые оставлены как есть (техдолг)
- **Стартеры `com.shopizer`** (canadapost, opensearch): javax persistence/servlet они не используют, но регистрируются через
  `spring.factories`, а Boot 3 его для автоконфигурации не читает. Их классы перечислены в
  `sm-core/.../META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`. Форк не понадобился.
- **Infinispan 9.4** (CMS-хранилище файлов/картинок) несовместим с Caffeine 3 (`CacheWriter` удалён) и падал при старте.
  **Решение:** `caffeine.version=2.9.3`. Caffeine больше никто в проекте не использует. Infinispan 14+ убрал модуль
  `tree`, на котором написан CMS. Переход = переписать CMS-модуль (или сразу на S3/файловую систему). **Техдолг.**
- **jjwt 0.8** использует `javax.xml.bind.DatatypeConverter` → добавлен `javax.xml.bind:jaxb-api:2.3.1`.
  Обновлять jjwt до 0.12 сейчас не стал: секрет по умолчанию `aSecret` (≈5 байт после base64), а jjwt 0.12 требует
  ≥ 64 байт для HS512. Апгрейд = новый секрет во всех окружениях + перелогин всех пользователей. **Рекомендую сделать
  отдельно, и секрет в любом случае заменить: текущий небезопасен.**
- **Drools 7.32** работает на Java 21 без изменений (тесты с правилами доставки зелёные).

### D-29. Method security
- `@EnableGlobalMethodSecurity` + наследование от `GlobalMethodSecurityConfiguration` → `@EnableMethodSecurity`
  (`prePostEnabled` теперь включён по умолчанию). Рецепт поменял аннотацию, но оставил наследование. Исправлено.

### D-30. Прочее
- H2 2.x + Hibernate 6: колонка `VALUE` (MerchantConfiguration, CustomerOptin) — зарезервированное слово. В H2-URL добавлен
  `NON_KEYWORDS=VALUE` (только для H2). Глобальное `hibernate.auto_quote_keyword` не включал: оно меняет регистр имён в PostgreSQL.
- JAX-RS `@Produces` в Spring-контроллере ни на что не влиял (и не компилировался без JAX-RS), удалён. Удалены неиспользуемые импорты `antlr`.

---

## Шаг 3. PostgreSQL 18

### D-31. Версия PostgreSQL
- **Решение:** PostgreSQL **18** (в тестах 18.6). PostgreSQL 19 на дату миграции только `19rc1`: для продакшена рано.
  Переход 18 → 19 потом не потребует изменений в коде, только образа и pg_upgrade.

### D-32. Как подключён PostgreSQL
- Новый профиль Spring `postgresql`. Добавлен в XML-конфиг ядра (как остальные профили) и в списки `@Profile` у
  4 бинов, которые были привязаны к конкретным профилям.
- Настройки через переменные окружения (`SHOPIZER_DB_URL` и др., см. `docs/POSTGRESQL.md`), без секретов в репозитории.
- Схемой управляет **Flyway** (`V1__baseline.sql`), Hibernate только проверяет (`validate`). Раньше везде было `hbm2ddl=update`.
  *Почему:* `update` на PostgreSQL не удаляет и не меняет колонки, схема молча расходится с кодом. Для платформы, на
  которой будут жить плагины со своими таблицами, нужны версионируемые миграции.
- **H2 оставлен** профилем по умолчанию для `mvn install` и быстрого старта (тесты за минуты, без Docker).
  MySQL-профили сохранены (диалект обновлён на `MySQLDialect`: `MySQL5InnoDBDialect` в Hibernate 6 удалён), но я их
  не тестировал. Считаю их legacy.
- *Альтернативы:* сделать PostgreSQL профилем по умолчанию (тогда `mvn install` требует Docker); Testcontainers прямо в тестах
  (удобно, но нужно переписать тестовую конфигурацию двух модулей; скрипт `scripts/test-postgres.sh` даёт то же без изменений тестов).

### D-33. Генераторы id при переносе данных
- `scripts/postgresql/reset-sm-sequencer.sql` (80 генераторов) **сгенерирован из аннотаций** `@TableGenerator`
  + первичных ключей из `V1__baseline.sql`. Ставит `seq_count = max(id) + allocationSize + 1` и никогда не уменьшает значение.
  Проверено: после скрипта приложение создаёт новые записи (smoke на тестовой БД).

### D-34. Текстовые колонки (уточнение D-22)
- `@JdbcTypeCode(SqlTypes.LONG32VARCHAR)` на PostgreSQL ломал вставку `null` (драйвер не знает внутренний код типа 4001).
  Заменено на рекомендованное Hibernate `@Column(length = Length.LONG32)`: в PostgreSQL то же `text`, но привязка как обычный `VARCHAR`.

### D-35. CHECK-ограничения для enum
- Hibernate 6 генерирует `CHECK (col IN (...))` для enum-колонок (19 штук). Из базовой миграции они **убраны**: иначе
  новое значение enum (в том числе из плагина) требует миграции, а старый код с ними не жил. Целостность значений
  по-прежнему гарантирует Java-код.

### D-36. Docker
- `sm-shop/Dockerfile`: `adoptopenjdk/openjdk11` (снят с поддержки) → `eclipse-temurin:21-jre`, профиль `postgresql`.
  Из образа убрано копирование `SALESMANAGER.h2.db`. Этот файл (H2 1.x) и `SALESMANAGER.trace.db` удалены из репозитория:
  H2 2 их не открывает.
- Добавлен `docker-compose.yml` (PostgreSQL 18 + Shopizer).
- На шаге 3 собрать образ сразу не удалось: Docker Hub ответил 429. **Проверено позже, на шаге 4:**
  `docker compose up --build` поднимает PostgreSQL 18 и Shopizer на `eclipse-temurin:25-jre` (Java 25.0.5), Flyway
  применяет миграцию, эндпоинты (публичные, приватные с JWT, OpenAPI) отвечают 200.

---

## Шаг 4. Spring Boot 3.5.16 → 4.0.9, Java 21 → 25

Рецепты: `UpgradeSpringBoot_4_0` (Spring Framework 7, Security 7, Hibernate 7.1, springdoc 3, модульные стартеры),
`UpgradeToJava25`, `UpgradeJackson_2_3` (Jackson 3, пакеты `tools.jackson.*`).

### D-40. Правки после рецепта в pom.xml
- Рецепт удалил `dependencyManagement` для `infinispan-core` и заменил `javax.xml.bind:jaxb-api` на jakarta (а jjwt 0.8
  нужен именно javax). Это откатил. Жёстко прописанные версии `4.0.9` у Boot-артефактов убрал: ими управляет parent.
- Остальное принято: `spring-boot-starter-aop` → `spring-boot-starter-aspectj`, `spring-security-test` →
  `spring-boot-starter-security-test`, `spring-boot-starter-flyway`, `spring-boot-resttestclient` для `TestRestTemplate`,
  javaagent Mockito для surefire (требование JDK 21+).

### D-41. ⚠️ Infinispan удалён, CMS по умолчанию переведён на файловую систему
- Infinispan 9.4 **не работает на Java 24+**: вызывает `Subject.getSubject()`, удалённый вместе с SecurityManager (JEP 486).
  Модуль `infinispan-tree`, на котором написан CMS по умолчанию (картинки товаров, статика, загрузки), существует
  только до 9.x, поэтому просто обновить Infinispan нельзя.
- **Решение:** небольшая замена TreeCache на файловой системе (`cms/impl/tree`: `TreeCache`, `Node`, `Fqn` с тем же API,
  что использовал CMS). Узел = каталог, ключ = файл. Имена кодируются (URL-encode), так что ключ не может выйти за
  пределы каталога (есть тест). Запись атомарная (temp + move). Классы CMS поменялись только импортами.
  Данные лежат в `<config.cms.store.location>/StoreRepository/...` и т.д.
- Infinispan, jgroups и закреплённый Caffeine 2.9.3 удалены из зависимостей.
- ⚠️ **Существующие данные CMS в формате Infinispan (`*.dat`) новая реализация не читает.** Для продакшена в Shopizer
  в любом случае рекомендуются `config.cms.method=aws|gcp` (S3/GCS). Если есть боевые картинки в Infinispan-хранилище,
  их нужно выгрузить до перехода на Java 25 (на сборке шага 3, Java 21). Инструмент выгрузки не писал: в репозитории
  файлы `.dat` были пустыми (только заголовок). Удалил их из git, каталоги `files/store`, `files/repos` оставил.
- *Альтернативы:* сделать `httpd`/`aws` методом по умолчанию (меняет URL картинок и требует внешний веб-сервер или S3);
  остаться на Java 21 (противоречит цели).

### D-42. Jackson 3 — формат JSON API не изменился
- REST API: убран лишний `MappingJackson2HttpMessageConverter` в `configureMessageConverters`. JSON пишет авто-сконфигурированный
  Boot-конвертер Jackson 3, плюс `spring.jackson.use-jackson2-defaults=true`.
- Программные мапперы (детали транзакций и конфигурации модулей **хранятся в БД как JSON**, загрузчики справочников):
  рецепт заменил `new ObjectMapper()` на `new JsonMapper()`. Я поменял на `JsonMapper.builderWithJackson2Defaults().build()`,
  чтобы новые записи были в том же формате, а старые читались.
- **Проверено сравнением**: 17 эндпоинтов (публичные и приватные) на сборке шага 3 (Boot 3.5 + Jackson 2) и шага 4,
  нормализованный JSON. Все ответы совпали байт в байт, кроме:
  - времени в `timestamp` у ответов-ошибок (формат тот же, отличается только само время);
  - порядка двух стран в `/api/v1/country`: названия стран приложение берёт из данных локалей JDK (CLDR), а они
    в JDK 25 обновились. Это не связано со Spring.
- Аннотации `com.fasterxml.jackson.annotation.*` в Jackson 3 остались в том же пакете, их не трогали.
- Сторонние библиотеки (Stripe, Braintree, AWS SDK, OpenSearch-клиент) продолжают тянуть Jackson 2. Он живёт рядом в своём пакете.

### D-43. Прочие изменения Boot 4 / Spring 7 / Hibernate 7
- **`javax.inject.@Inject` больше не поддерживается Spring 7.** Один пропущенный импорт в `ProductFacadeImpl`
  молча оставлял поле `null` (`/api/v1/products` отвечал 503). Исправлено, `javax.inject`/`javax.annotation` в коде больше нет.
- Spring Data 4 подключил к `PageableCategoryRepository` класс `PageableCategoryRepositoryImpl` по имени, и тот перекрыл
  `@Query`. Класс был мёртвым и сломанным (несуществующий именованный запрос, count через `getMaxResults()`). Удалён.
- Security 7: `DaoAuthenticationProvider` принимает `UserDetailsService` в конструкторе (у JWT-провайдеров добавлены конструкторы).
- Hibernate 7: `@org.hibernate.annotations.OrderBy` → `@SQLOrder`.
- Boot 4: `ServletComponentScan`, `WebServerInitializedEvent`, `TestRestTemplate` переехали в новые модули/пакеты;
  `server.error.whitelabel.enabled` → `spring.web.error.whitelabel.enabled`.
- Случайный импорт `org.jgroups.util.UUID` (jgroups приходил с Infinispan) генерировал временные пароли из «сырых» байт.
  Заменён на `java.util.UUID.randomUUID()`.

### D-44. Версия Boot 4
- Рецепт OpenRewrite есть только для 4.0, поэтому сначала Boot **4.0.9** (полностью зелёный, коммит), затем отдельным
  шагом последняя 4.1.x (см. D-45).

### D-45. ⚠️ Spring Boot 4.1 пока не берём: финальная версия 4.0.9
- Попробовал Boot **4.1.2** (+ springdoc 3.2.0). Он приносит **Hibernate 7.2**, и в нём два теста упали с некорректным SQL
  (`Column "C1_0.CATEGORY_ID" not found`, `"L1_0.LANGUAGE_ID" not found`). Причина: Hibernate 7.2 по-новому делает
  пагинацию запросов с `join fetch` коллекций (через подзапрос), и условия `where` по алиасам fetch-коллекций
  оказываются вне подзапроса. В Shopizer этот шаблон встречается массово (фильтр по `categs.id`, `cd.language`... при
  `setFirstResult/setMaxResults` или `Pageable`), а тесты покрывают малую часть из 229 запросов.
- **Решение:** остаться на Boot **4.0.9** (последний патч 4.0; поддерживаемая комбинация с Hibernate 7.1), всё зелёное.
- *Что нужно для 4.1.* Сканер нашёл 6 запросов с `Pageable` в `Pageable*Repository` и несколько динамических в
  `ProductRepositoryImpl`, которые ставят условие на алиас `join fetch`-коллекции. **Тонкость:** часть из них делает
  это нарочно. Например, `left join fetch c.descriptions cd ... where cd.language.id = ?`, чтобы загрузить описания
  только на одном языке. Переписать такое на отдельный `join` = подтянуть все языки, и мапперы могут отдать не то
  описание. Нужна аккуратная переработка (например, `@Filter` Hibernate по языку или DTO-проекции) и тесты на мультиязычность.
  Пробную правку фильтра категорий я сделал и **откатил**: на 4.0.9 она не нужна, а состав `categories` в ответе API она меняет.
- *Альтернатива:* Boot 4.1.2 с принудительным `hibernate.version` 7.1. Это неподдерживаемая комбинация, отказался.
