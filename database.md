# Polify DB Models

Sqlite models found in [database.dart](lib/database.dart)

# MusicBuckets

An S3 compactible storage bucket from any compactible provider eg aws, digital ocean, google storage, wasaby ...

### bucket-Id : integer

### bucket-name : text **unique**

### bucket-musicFolderPrefix : text || null

# Genres

A music genre eg rock, pop, funk, jazz ...

### genres-Id : integer

### genres-Name : text **unique**

# Labels

A record label eg Blue Note, Studio One, Trojan Records ...

### labels-Id : integer

### labels-Name : text **unique**

### labels-ImageUrl : text || null

# LabelGenres

One (label) to Many (genres) relation table

### Id : text = $labelId-$genreId

### [labelId](#labels-id--integer) : integer

### [genreId](#genres-id--integer) : integer

# Groups

Many Artists together formed a Group

### groups-Id : integer

### groups-BucketPrefix : text

### groups-Name : text

### groups-ImageUrl : text

# GroupGenres

One (group) to Many (genres) relation table

### Id : text = $groupId-$genreId

### [groupId](#groups-id--integer) : integer

### [genreId](#genres-id--integer) : integer

# GroupLabels

One (group) to Many (labels) relation table

### Id : text = $groupId-$labelsId

### [groupId](#groups-id--integer) : integer

### [labelId](#labels-id--integer) : integer

# Artists

A Music Artist eg Stan Getz, Rick James, Freeze Corleone ...

### artists-Id : integer

### artists-BucketPrefix : text

### artists-Name : integer **unique**

### artists-ImageUrl : text || null

# Albums

### albums-Id : integer

### albums-Name : text

### albums-Year : integer

### albums-CoverUrl : text

### albums-LabelId : integer

# TODO : Add relation tables for genre, label and artists

# Songs

### songs-Id : integer

### songs-Name : text

### songs-Url : text

### songs-Year : integer

### songs-Length : integer

### songs-IsSingle : boolean

### songs-IsFavorite : boolean

### songs-AlbumId : integer

### songs-LabelId : integer

### songs-ArtistIds : integer[]

### songs-GroupIds : integer[]

### songs-GenreIds : integer[]

# Playlists

- Id : integer
- Name : integer
- SongIds : integer[]
