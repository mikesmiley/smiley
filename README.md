# Smiley Library

A collection of useful Node.js functions and utilities.

These are functions I use often but are too simple to have their own package.

## Functions

### `zeroPad(string, totalLength) -> String`

Zero pad the given number into a string with the given total length.

### `hexDump(Buffer) -> String`

Render the bytes of the given Buffer to a hex-editor-like format.

### `isUUID(string) -> Boolean`

Uses a Regex to test the given string for the UUID format.

### `iecToDecimal(string) -> Number`

Converts an IEC size (e.g. 4.0K) to a full decimal Number (e.g. 4096)

### `titleCase(string) -> String`

Converts a string to Title Case. Hyphens and underscores are converted to spaces.

### `getNetworkInterfaces() -> Array`

Get an array of network interfaces in a different format than the typical `os.networkInterfaces()`. Makes traversing the interfaces easier.

### `getExternalIPAddress() -> String`

Return an IP address marked as external in `os.networkInterfaces()`. No guarantees about internet access.

### `findModuleRoot(moduleName) -> String`

Find the root of the given module defined as the first directory above the module's entry point with a `package.json` file.

### `debounce(function, waitMS, runImmediate) -> function`

Debounce the given function by preventing multiple executions within the given waitMS time. If runImmediate is true, the function will be executed immediately the first time.

### `smileyFace() -> String`

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
