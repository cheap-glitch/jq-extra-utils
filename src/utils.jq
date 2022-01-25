# jq-extra-utils
#
# Copyright (c) 2021-present, cheap glitch
# This software is distributed under the ISC license

#
# Returns the last element of an array.
#
# [1, 2, 3] | array_last
# > 3
#
def array_last: .[length - 1];

#
# Returns an array containing the input repeated `n` times.
#
# [] | repeat(3)
# > [[], [], []]
#
def repeat(n): . as $input | [range(n) | $input];

#
# Returns a string made of the input repeated `n` times.
#
# "words" | repeat_str(3)
# > "wordswordswords"
#
def repeat_str(n): repeat(n) | join("");

#
# Returns `true` if the array contains the exact needle, `false` otherwise.
# Takes the needle as argument
#
# [1, 2, 3] | includes(3)
# > true
#
def includes(needle): any(.[]; . == needle);

#
# Returns `true` if the array contains the exact needle, `false` otherwise.
# Takes the array as argument.
#
# "3" | included_in([1, 2, 3])
# > false
#
def included_in(array): . as $needle | array | includes($needle);

#
# Filters the array.
#
# ["foo", "bar", "foobar"] | filter(length <= 3)
# > ["foo", "bar"]
#
def filter(sieve): map(select(sieve));

#
# Filters the object.
#
# { "foo": "foo", "bar": 2 } | filter_obj(.key != .value)
# > { "bar": 2 }
#
def filter_obj(sieve): with_entries(select(sieve));

#
# Returns the first element in the array to satisfy the condition, or `null` if there is none.
#
# ["a", 2, false, "b", true] | find(type == "string")
# > "a"
#
def find(condition): filter(condition)[0];

#
# Returns the last element in the array to satisfy the condition, or `null` if there is none.
#
# ["a", 2, false, "b", true] | rfind(type == "string")
# > "b"
#
def rfind(condition): filter(condition) | array_last;

#
# Returns the index of the first element in the array to satisfy the condition, or `null` if there is none.
#
# ["a", 2, false, "b", true] | find_index(type == "string")
# > 0
#
def find_index(condition): to_entries | filter(.value | condition)[0].key;

#
# Returns the index of the last element in the array to satisfy the condition, or `null` if there is none.
#
# ["a", 2, false, "b", true] | rfind_index(type == "string")
# > 0
#
def rfind_index(condition): to_entries | filter(.value | condition) | array_last.key;

#
# Takes an array of arrays and zip them together.
#
# [[1, 2, 3], [], ["a", "b"]] | zip
# > [[1, null, "a"], [2, null, "b"], [3, null, null]]
#
def zip: . as $arrays | max_by(length) | keys | map(. as $index | $arrays | map(.[$index]));

#
# Zip two arrays together.
#
# ["a", "b"] | zip_with([true, false, true])
# > [["a", true], ["b", false]]
#
def zip_with(array): . as $input | keys | map([$input[.], array[.]]);

# vim:ft=config
