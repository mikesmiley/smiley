# Smiley Library

A collection of useful Node.js functions and utilities.

These are functions I use often but are too simple to have their own package.

## Functions

### `titleCase(string)`

Converts a string to Title Case. Hyphens and underscores are converted to spaces.

### `getNetworkInterfaces()`

Get an array of network interfaces in a different format than the typical `os.networkInterfaces()`. Makes traversing the interfaces easier.

### `getExternalIPAddress()`

Return an IP address marked as external in `os.networkInterfaces()`. No guarantees about internet access.

### `findModuleRoot(moduleName)`

Find the root of the given module defined as the first directory above the module's entry point with a `package.json` file.

### `smileyFace()`

This is just a fun one that returns an ASCII smiley face :)

## Installation

```bash
$ npm install smiley
```

## Testing

```bash
$ npm test
```

## License

  [MIT](LICENSE)
