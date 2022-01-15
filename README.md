# 🧰 jq-extra-utils

![License](https://badgen.net/github/license/cheap-glitch/jq-extra-utils?color=green)
![Latest release](https://badgen.net/github/release/cheap-glitch/jq-extra-utils?color=green)

This  is a  module  containing some  useful  filters and  functions  for use  in
[jq](https://stedolan.github.io/jq/)  scripts.  It  aims  to fill  gaps  in  the
built-in library, speed up development and make scripts more expressive.

## Features

 * Equivalents of `contains` and `inside` that [behave as usually expected](#includesneedle)
 * Useful functions that are missing from the built-ins: `repeat`, `find`, `find_index`, etc.
 * Convenient aliases of common operations for more expressive scripts: `filter`, `array_last`, etc.

## Installation

Obviously, you need to [install `jq` first](https://stedolan.github.io/jq/download).

Install this module with npm:

```shell
npm i jq-extra-utils
```

Or directly download the contents of the file:

```shell
curl https://raw.githubusercontent.com/cheap-glitch/jq-extra-utils/main/src/utils.jq > utils.jq
```

## Usage

To use in your scripts, indicate the path of the directory containing the module
with the `-L` option and import it with `include` (without the extension):

```shell
jq -L path/to/module/dir 'include "utils"; repeat(13) + ["Batman!"] | join(" ")' <<< '"Na"'
> "Na Na Na Na Na Na Na Na Na Na Na Na Na Batman!"
```

→ Read more about importing modules in `jq` [here](https://stedolan.github.io/jq/manual/#Modules).

## API

### array_last

Returns the last element of an array.

```text
[1, 2, 3] | array_last
> 3
```

### repeat(n)

Returns an array containing the input repeated `n` times.

```text
[] | repeat(3)
> [[], [], []]
```

### includes(needle)

Returns `true` if the array contains the exact needle, `false` otherwise.
Takes the needle as argument.

```text
[1, 2, 3] | includes(3)
> true
```

> Note:  this  is  not  the  same   as  the  built-in  `contains`  function.  It
> checks for  strict equality  between the  needle and  every element  just like
> `Array.includes` in JavaScript does, whereas `contains` checks if each element
> _contains_ the needle, which can give surprising results when using strings or
> nested arrays:
>
> ```shell
> jq '["bar", "baz", "foobar"] | contains(["foo"])'
> > true
> ```

### included_in(array)

Returns `true` if the array contains the exact needle, `false` otherwise.
Takes the array as argument.

```text
"3" | included_in([1, 2, 3])
> false
```

### filter(sieve)

Filters the array.

```text
["foo", "bar", "foobar"] | filter(length <= 3)
> ["foo", "bar"]
```

### filter_obj(sieve)

Filters the object.

```text
{ "foo"
> { "bar"
```

### find(condition)

Returns the first element in the array to satisfy the condition, or `null` if there is none.

```text
["a", 2, false, "b", true] | find(type == "string")
> "a"
```

### rfind(condition)

Returns the last element in the array to satisfy the condition, or `null` if there is none.

```text
["a", 2, false, "b", true] | rfind(type == "string")
> "b"
```

### find_index(condition)

Returns the index of the first element in the array to satisfy the condition, or `null` if there is none.

```text
["a", 2, false, "b", true] | find_index(type == "string")
> 0
```

### rfind_index(condition)

Returns the index of the last element in the array to satisfy the condition, or `null` if there is none.

```text
["a", 2, false, "b", true] | rfind_index(type == "string")
> 0
```

### zip

Takes an array of arrays and zip them together.

```text
[[1, 2, 3], [], ["a", "b"]] | zip
> [[1, null, "a"], [2, null, "b"], [3, null, null]]
```

### zip_with(array)

Zip two arrays together.

```text
["a", "b"] | zip_with([true, false, true])
> [["a", true], ["b", false]]
```

## Changelog

See the full changelog [here](https://github.com/cheap-glitch/devlint/releases).

## Contributing

Contributions are welcomed! Please open an issue before proposing any significant changes.

## Related

 * [https://stedolan.github.io/jq/manual](https://stedolan.github.io/jq/manual) - The official `jq` manual

## License

ISC
