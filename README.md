# Mongol Converter

A Cyrillic to Mongolian converter built with Flutter. The backend is hosted with PocketBase.

## Updating the Flutter app

1. Update the version in `pubspec.yaml`.
2. Run `flutter build web --base-href /apps/cyrillic/` to build the web app.
3. Copy the contents of `build/web` to the `/apps/cyrillic` folder of `suragch.github.io`.

## Updating the PocketBase backend

### Nginx configuration

```
/etc/nginx/sites-available/cyrillic.suragch.dev
```

This is a reverse proxy for PocketBase running at http://127.0.0.1:8090.

### PocketBase configuration

Pocketbase is running globally with the data folder in the home folder.


