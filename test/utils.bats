#!/usr/bin/env bats

TEST_DIR="$(dirname "${BATS_TEST_FILENAME:-}")"

setup() {
	load ./node_modules/bats-support/load.bash
	load ./node_modules/bats-assert/load.bash
}

_jq() {
	local script="$1"
	local json="$2"

	jq -L "${TEST_DIR}/../src" --compact-output "include \"utils\"; ${script}" <<< "${json}" | sed --regexp-extended -e 's/([,:{])/\1 /g' -e 's/}/ }/g'
}

@test "array_last" { # {{{

	run _jq 'array_last' '[]'
	assert_output 'null'

	run _jq 'array_last' '[1, 2, 3]'
	assert_output '3'

	run _jq 'reverse | array_last' '["foo", "bar"]'
	assert_output '"foo"'


} # }}}

@test "repeat" { # {{{

	run _jq 'repeat(3)' '[]'
	assert_output '[[], [], []]'

} # }}}

@test "includes" { # {{{

	run _jq 'includes(0)' '[6, 47, 12, 0, 22, 9]'
	assert_output 'true'

	run _jq 'map(. / 3) | includes(4)' '[6, 47, 12, 0, 22, 9]'
	assert_output 'true'

	run _jq 'includes("foo")' '[6, 47, 12, 0, 22, 9]'
	assert_output 'false'

} # }}}

@test "included_in" { # {{{

	run _jq 'included_in([6, 47, 12, 0, 22, 9])' '0'
	assert_output 'true'

	run _jq 'included_in([6, 47, 12, 0, 22, 9] | map(. / 3))' '4'
	assert_output 'true'

	run _jq 'included_in([6, 47, 12, 0, 22, 9])' '"foo"'
	assert_output 'false'


} # }}}

@test "filter" { # {{{

	run _jq 'filter(length <= 3)' '["foo", "bar", "foobar"]'
	assert_output '["foo", "bar"]'

	run _jq 'filter(. % 3 == 0)' '[6, 47, 12, 0, 22, 9]'
	assert_output '[6, 12, 0, 9]'

	run _jq 'filter(. | startswith("foo") | not)' '["foo", "bar", "foobar", "fobar", "barfoo"]'
	assert_output '["bar", "fobar", "barfoo"]'

	run _jq 'filter((unique | length >= 3) and (filter(type == "string") | length <= 2))' '[["a", "b", "c", []], [true, 2, "a", 2], [1, false, "false"], [[], [], false, []]]'
	assert_output '[[true, 2, "a", 2], [1, false, "false"]]'

} # }}}

@test "filter_obj" { # {{{

	run _jq 'filter_obj(.key != .value)' '{ "foo": "foo", "bar": 2 }'
	assert_output '{ "bar": 2 }'

	run _jq 'filter_obj(.key != .value and (.value | type != "boolean"))' '{ "foo": "foo", "bar": "foobar", "baz": true }'
	assert_output '{ "bar": "foobar" }'

} # }}}

@test "find" { # {{{

	run _jq 'find(type == "string")' '["a", 2, false, "b", true]'
	assert_output '"a"'

	run _jq 'find(type == "number")' '["a", 2, false, "b", true]'
	assert_output '2'

	run _jq 'find(type == "object")' '["a", 2, false, "b", true]'
	assert_output 'null'

} # }}}

@test "rfind" { # {{{

	run _jq 'rfind(type == "string")' '["a", 2, false, "b", true]'
	assert_output '"b"'

	run _jq 'rfind(type == "number")' '["a", 2, false, "b", true]'
	assert_output '2'

	run _jq 'rfind(type == "object")' '["a", 2, false, "b", true]'
	assert_output 'null'

} # }}}

@test "find_index" { # {{{

	run _jq 'find_index(type == "string")' '["a", 2, false, "b", true]'
	assert_output '0'

	run _jq 'find_index(type == "number")' '["a", 2, false, "b", true]'
	assert_output '1'

	run _jq 'find_index(type == "object")' '["a", 2, false, "b", true]'
	assert_output 'null'

} # }}}

@test "rfind_index" { # {{{

	run _jq 'rfind_index(type == "string")' '["a", 2, false, "b", true]'
	assert_output '3'

	run _jq 'rfind_index(type == "number")' '["a", 2, false, "b", true]'
	assert_output '1'

	run _jq 'rfind_index(type == "object")' '["a", 2, false, "b", true]'
	assert_output 'null'

} # }}}

@test "zip" { # {{{

	run _jq 'zip' '[[1, 2, 3], [], ["a", "b"]]'
	assert_output '[[1, null, "a"], [2, null, "b"], [3, null, null]]'

} # }}}

@test "zip_with" { # {{{

	run _jq 'zip_with([true, false, true])' '["a", "b"]'
	assert_output '[["a", true], ["b", false]]'

	run _jq 'zip_with([true])' '["a", "b"]'
	assert_output '[["a", true], ["b", null]]'

	run _jq 'zip_with([0, 1, 2, 3, 4])' '[]'
	assert_output '[]'

} # }}}
