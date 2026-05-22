# thanh-archetype-quickstart

## What This Project Is

This is a **Maven Archetype** — a project template generator, not a runnable application. It produces scaffolded plain-Java projects as a modern replacement for the outdated `maven-archetype-quickstart`.

- Archetype coordinates: `com.thanh:thanh-archetype-quickstart:1.0`
- Archetype itself compiles with Java 11; **generated projects target Java 16**
- No Spring Boot, no database, no REST — just plain Java with logging and testing

## Directory Structure

```
thanh-archetype-quickstart/
├── pom.xml                          # Archetype POM (packaging: maven-archetype, Java 11)
├── gen.sh                           # Example mvn archetype:generate commands
├── README.md
└── src/main/resources/
    ├── META-INF/maven/
    │   └── archetype-metadata.xml   # Declares which template files are generated
    └── archetype-resources/         # Everything here becomes the generated project
        ├── pom.xml                  # Template POM (Java 16, all dependencies)
        ├── .gitignore
        ├── README.md
        └── src/
            ├── main/
            │   ├── java/Main.java           # Template entry point
            │   └── resources/log4j2.xml     # Template logging config
            └── test/
                └── MainTest.java            # Template JUnit 5 test
```

## Key Commands

### Install the archetype locally
```bash
mvn clean install
```
This installs `com.thanh:thanh-archetype-quickstart:1.0` into the local Maven repository so it can be used to generate projects.

### Generate a new project from the archetype
```bash
mvn archetype:generate \
  -DgroupId=com.your.company \
  -DartifactId=your-project-name \
  -Dversion=1.0 \
  -DarchetypeGroupId=com.thanh \
  -DarchetypeArtifactId=thanh-archetype-quickstart
```

### Build and test a generated project
```bash
cd your-project-name
mvn clean package          # compiles + tests + creates fat JAR
java -jar target/your-project-name-1.0-jar-with-dependencies.jar
```

## Template Dependency Stack (in `archetype-resources/pom.xml`)

| Library | Version | Purpose |
|---------|---------|---------|
| `org.slf4j:slf4j-api` | 2.0.17 | Logging facade |
| `org.apache.logging.log4j:log4j-slf4j2-impl` | 2.26.0 | SLF4J → Log4j2 bridge |
| `org.apache.logging.log4j:log4j-core` | 2.26.0 | Log4j2 implementation |
| `org.junit.jupiter:junit-jupiter-api` | 5.12.2 | JUnit 5 test API |
| `org.junit.jupiter:junit-jupiter-engine` | 5.12.2 | JUnit 5 test engine |

Build plugins in generated projects: `maven-compiler-plugin:3.15.0`, `maven-surefire-plugin:3.5.5`, `maven-assembly-plugin:3.8.0` (produces fat JAR).

## Template Variables

Inside `archetype-resources/` files, Maven archetype substitutes these variables at generation time:

| Variable | Example value |
|----------|--------------|
| `${groupId}` | `com.your.company` |
| `${artifactId}` | `your-project-name` |
| `${version}` | `1.0` |

All files under `archetype-resources/` are **filtered** (variables replaced). Java source files are also **packaged** (placed inside the correct package directory matching `groupId`).

## How to Modify the Archetype

### Add a dependency to generated projects
Edit `src/main/resources/archetype-resources/pom.xml` — add the `<dependency>` block there, not in the root `pom.xml`.

### Add a new template file
1. Create the file under `src/main/resources/archetype-resources/` in the appropriate path.
2. Register it in `src/main/resources/META-INF/maven/archetype-metadata.xml` under the correct `<fileSet>`:
   - `filtered="true" packaged="true"` — Java source files (placed in package directory)
   - `filtered="true" packaged="false"` — resource files (placed as-is, no package path)
   - `filtered="true"` (no packaged attr) — root files like `.gitignore`, `README.md`

### Change the Java target version
Edit `<java.version>` in `src/main/resources/archetype-resources/pom.xml`.

## Logging Configuration (Template)

`archetype-resources/src/main/resources/log4j2.xml` configures two appenders in generated projects:

- **Console**: `%d{HH:mm:ss.SSS} [%t] %-5level %logger{36} - %msg%n`
- **RollingFile**: `./logs/${artifactId}.log`, rolls at 10 MB, keeps 4 backup files
  - Pattern includes MDC fields `%X{id}` and `%X{username}` for request tracing

Logger levels: root at INFO; the generated project's own package (`${groupId}`) at DEBUG.

## Verifying Archetype Changes End-to-End

```bash
# 1. Install the modified archetype
mvn clean install

# 2. Generate a test project
cd /tmp
mvn archetype:generate \
  -DgroupId=test.verify \
  -DartifactId=verify-project \
  -Dversion=1.0 \
  -DarchetypeGroupId=com.thanh \
  -DarchetypeArtifactId=thanh-archetype-quickstart \
  -DinteractiveMode=false

# 3. Build and run the generated project
cd verify-project
mvn clean package
java -jar target/verify-project-1.0-jar-with-dependencies.jar
# Expected output: INFO log line "It works"
```

## Common Pitfalls

- **Do not confuse the two `pom.xml` files.** The root `pom.xml` controls the archetype build itself. `archetype-resources/pom.xml` is the template for generated projects — dependency changes go here.
- **`packaged="true"` moves Java files into the package directory.** If you add a `.java` file to a `packaged="false"` fileSet, it will not be placed under the correct package path.
- **`${artifactId}` in `log4j2.xml` is a template variable.** It is replaced at generation time. Do not confuse it with a Log4j2 lookup.
- **Re-install after every change.** Maven caches the archetype locally; `mvn clean install` must be re-run for changes to take effect in newly generated projects.
