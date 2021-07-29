package example

default allow = false       # by default, don't allow anyone

allow = true {              # allow is true if...
    input.role == "admin"   # the user is an admin
}

curtis = { "name": "Curtis", "role": "admin" }

josh = { "name": "Josh", "role": "foo" }
