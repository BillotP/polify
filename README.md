# Polify V2

![ci](https://github.com/billotp/polify/actions/workflows/ci.yml/badge.svg) [![wakatime](https://wakatime.com/badge/user/ed55f0c5-8fd9-4246-9af5-28282782e541/project/5c71355c-1ae8-424b-9c3b-fc8ef0232c29.svg)](https://wakatime.com/badge/user/ed55f0c5-8fd9-4246-9af5-28282782e541/project/5c71355c-1ae8-424b-9c3b-fc8ef0232c29)

A cross-platform S3 based streaming music player for Android and Linux

## :rocket: App Features

- [x] Add bucket access credentials at build time in .env file

- [ ] Add bucket access credentials at runtime with dedicated form

- [x] List Buckets

- [x] List Bucket Objects

- [x] Save Songs metadatas to sqlite app embedded db

- [x] Save Albums metadatas to sqlite app embedded db

- [x] Save Artists metadatas to sqlite app embedded db

- [x] Play Songs, Albums or Artists on tap

## :hammer: Development

- Clone this repository on your linux based os with an up-to-date flutter sdk installed.

- Install dart dependencies with `flutter pub get`

- Create a _.env_ file at the root of this repo with the following format :

```dotenv
S3_ENDPOINT=your.s3.endpoint
ACCESS_KEY=youracceskey
SECRET_KEY=yoursecretkey
```

- Run `dart run build_runner build --delete-conflicting-output` to generate database and dotenv helpers class.

- Connect your Android phone with AndroidDebugBridge activated\*

- Run `flutter run -d android` or `flutter run -d linux`

- Enjoy !

\*Optional, only for Android version

## :book: Documentation

### Database

See [database.md](./database.md) document.

## Prerequisites

Buckets **music folder** should be scaffolded like :

```
Bucket

-- MusicFolder/

---- Artist 1/

------ Album 1/

-------- Song 1

-------- Song 2

-------- .....



```
