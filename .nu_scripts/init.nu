#const scripts = '.config/nushell/.nu_scripts'
const load = '.config/nushell/.nu_scripts/load.nu'
const commands = '.config/nushell/.nu_scripts/commands'
let list = (ls ...(glob $'.config/nushell/.nu_scripts/commands/**/*.nu') | get name)
print $list
let length = ($list | length)

mut x = 0; while $x < $length {let file = ($list | get $x); $"source '($file)'\n" | save --append $load; $x += 1}
