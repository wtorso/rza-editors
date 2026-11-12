local failures = {}

local function check(condition, message)
    if not condition then
        table.insert(failures, message)
    end
end

local function group_at(line, column)
    return vim.fn.synIDattr(vim.fn.synID(line, column, 1), "name")
end

local function check_group(line, column, expected)
    check(group_at(line, column) == expected,
        string.format("line %d column %d: expected %s, got %s",
            line, column, expected, group_at(line, column)))
end

vim.opt.runtimepath:prepend(vim.fn.getcwd() .. "/nvim")
vim.cmd("filetype plugin on")
vim.cmd("syntax enable")
vim.cmd("edit test/fixtures/sample.rza")

check(vim.bo.filetype == "rza", "filetype must be rza, got " .. vim.bo.filetype)
check(vim.bo.commentstring == "; %s",
    "commentstring must be '; %s', got " .. vim.bo.commentstring)

check_group(1, 1, "rzaKeyword")
check_group(1, 8, "rzaLayout")
check_group(1, 19, "rzaScalarType")
check_group(1, 30, "rzaScalarType")
check_group(2, 21, "rzaLayout")
check(group_at(1, 8) ~= group_at(1, 19), "layout and scalar types must differ")
check_group(2, 14, "rzaConstant")
check_group(3, 26, "rzaConstant")
check_group(4, 5, "rzaRegister")
check_group(5, 5, "rzaRegister")
check_group(4, 10, "rzaNumber")
check_group(5, 11, "rzaNumber")
check_group(2, 27, "rzaNumber")
check_group(7, 24, "rzaNumber")
check_group(6, 25, "rzaField")
check_group(7, 27, "rzaField")
check_group(8, 6, "rzaLabel")
check_group(10, 1, "rzaComment")
check_group(10, 3, "rzaComment")
check_group(10, 10, "rzaComment")
check_group(10, 14, "rzaComment")
check(group_at(11, 5) == "", "%r16 must not have a syntax group")

local opcodes = {
    "cav", "res", "med", "raise", "decay", "probe", "load", "loadb",
    "mov", "store", "storeb", "slt", "inc", "dec", "await", "print",
    "jmp", "brz", "brnz", "call", "proc", "casc", "acasc", "endc", "ret",
    "layout", "add", "sub", "mul", "div", "mod", "and", "or", "xor",
    "shl", "shr",
}

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, opcodes)
vim.cmd("runtime! syntax/rza.vim")
for line, opcode in ipairs(opcodes) do
    check_group(line, 1, "rzaKeyword")
end

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, {"loop:"})
vim.cmd("runtime! syntax/rza.vim")
check_group(1, 1, "rzaLabel")

if #failures > 0 then
    for _, message in ipairs(failures) do
        vim.api.nvim_err_writeln(message)
    end
    vim.cmd("cquit")
else
    print("Neovim syntax and filetype checks passed")
    vim.cmd("qa!")
end
