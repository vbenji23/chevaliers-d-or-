package two_fer

import "core:fmt"

two_fer :: proc(name: string = "") -> string {
	target := name == "" ? "you" : name
	return fmt.aprintf("One for %s, one for me.", target)
}
