# array_last
# ------------------------------------------------------------------------------

array_last
[]
null

array_last
[1, 2, 3]
3

reverse | array_last
["foo", "bar"]
"foo"

# repeat
# ------------------------------------------------------------------------------

repeat(3)
[]
[[], [], []]

# repeat_str
# ------------------------------------------------------------------------------

repeat_str(3)
"words"
"wordswordswords"

# includes
# ------------------------------------------------------------------------------

includes(0)
[6, 47, 12, 0, 22, 9]
true

map(. / 3) | includes(4)
[6, 47, 12, 0, 22, 9]
true

includes("foo")
[6, 47, 12, 0, 22, 9]
false

# included_in
# ------------------------------------------------------------------------------

included_in([6, 47, 12, 0, 22, 9])
0
true

included_in([6, 47, 12, 0, 22, 9] | map(. / 3))
4
true

included_in([6, 47, 12, 0, 22, 9])
"foo"
false

# filter
# ------------------------------------------------------------------------------

filter(length <= 3)
["foo", "bar", "foobar"]
["foo", "bar"]

filter(. % 3 == 0)
[6, 47, 12, 0, 22, 9]
[6, 12, 0, 9]

filter(. | startswith("foo") | not)
["foo", "bar", "foobar", "fobar", "barfoo"]
["bar", "fobar", "barfoo"]

filter((unique | length >= 3) and (filter(type == "string") | length <= 2))
[["a", "b", "c", []], [true, 2, "a", 2], [1, false, "false"], [[], [], false, []]]
[[true, 2, "a", 2], [1, false, "false"]]

# filter_obj
# ------------------------------------------------------------------------------

filter_obj(.key != .value)
{ "foo": "foo", "bar": 2 }
{ "bar": 2 }

filter_obj(.key != .value and (.value | type != "boolean"))
{ "foo": "foo", "bar": "foobar", "baz": true }
{ "bar": "foobar" }

# find
# ------------------------------------------------------------------------------

find(type == "string")
["a", 2, false, "b", true]
"a"

find(type == "number")
["a", 2, false, "b", true]
2

find(type == "object")
["a", 2, false, "b", true]
null

# rfind
# ------------------------------------------------------------------------------

rfind(type == "string")
["a", 2, false, "b", true]
"b"

rfind(type == "number")
["a", 2, false, "b", true]
2

rfind(type == "object")
["a", 2, false, "b", true]
null

# find_index
# ------------------------------------------------------------------------------

find_index(type == "string")
["a", 2, false, "b", true]
0

find_index(type == "number")
["a", 2, false, "b", true]
1

find_index(type == "object")
["a", 2, false, "b", true]
null

# rfind_index
# ------------------------------------------------------------------------------

rfind_index(type == "string")
["a", 2, false, "b", true]
3

rfind_index(type == "number")
["a", 2, false, "b", true]
1

rfind_index(type == "object")
["a", 2, false, "b", true]
null

# arrays_and
# ------------------------------------------------------------------------------

arrays_and([1, "a", true]; ["b", 1, false, 1])
null
[1]

arrays_and(["foo", "bar", "foo"]; ["bar", "foo", "bar"])
null
["bar", "foo"]

arrays_and([ [], [[]] ]; [ [[]] ])
null
[ [[]] ]

# zip
# ------------------------------------------------------------------------------

zip
[[1, 2, 3], [], ["a", "b"]]
[[1, null, "a"], [2, null, "b"], [3, null, null]]

# zip_with
# ------------------------------------------------------------------------------

zip_with([true, false, true])
["a", "b"]
[["a", true], ["b", false]]

zip_with([true])
["a", "b"]
[["a", true], ["b", null]]

zip_with([0, 1, 2, 3, 4])
[]
[]

# vim:ft=config
