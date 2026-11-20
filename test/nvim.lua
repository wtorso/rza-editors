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
check_group(12, 18, "rzaScalarType")
check_group(12, 30, "rzaScalarType")
check_group(12, 38, "rzaScalarType")
check_group(12, 55, "rzaScalarType")

local opcodes = {
    "cav", "res", "med", "view", "raise", "decay", "probe", "load", "loadb",
    "mov", "store", "storeb", "slt", "inc", "dec", "await", "print",
    "jmp", "brz", "brnz", "call", "proc", "casc", "acasc", "endc", "ret",
    "layout", "add", "sub", "mul", "div", "mod", "and", "or", "xor",
    "shl", "shr", "ushr", "cadd", "csub", "cmul", "cinc", "cdec", "crc32c",
}

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, opcodes)
vim.cmd("runtime! syntax/rza.vim")
for line, opcode in ipairs(opcodes) do
    check_group(line, 1, "rzaKeyword")
end

local typed = {}
local shared = {
    "mov", "load", "store", "add", "sub", "mul", "inc", "dec",
    "cadd", "csub", "cmul", "cinc", "cdec", "and", "or", "xor",
    "div", "mod", "shl", "ushr",
}
local types = {"i8", "u8", "i16", "u16"}
for _, base in ipairs(shared) do
    for _, type in ipairs(types) do
        table.insert(typed, base .. "." .. type)
    end
end
for _, opcode in ipairs({"shr.i8", "slt.i8", "ult.u8", "shr.i16", "slt.i16", "ult.u16"}) do
    table.insert(typed, opcode)
end
check(#typed == 86, "typed matrix must contain 86 spellings")

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, typed)
vim.cmd("runtime! syntax/rza.vim")
for line, opcode in ipairs(typed) do
    local suffix = string.find(opcode, ".", 1, true) + 1
    check_group(line, 1, "rzaKeyword")
    check_group(line, suffix, "rzaKeyword")
end

local inactive = {
    "load.i64", "store.i64", "mov.i64", "add.i64", "load.u32",
    "shr.u8", "slt.u8", "ult.i8", "shr.u16", "slt.u16", "ult.i16",
    "ult", "loadb.u8", "loadb.u16", "crc32c.i16", "print.u16", "cvt.i16",
    "add.f32",
}
vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, inactive)
vim.cmd("runtime! syntax/rza.vim")
for line, opcode in ipairs(inactive) do
    local dot = string.find(opcode, ".", 1, true)
    if dot then
        check(group_at(line, dot + 1) ~= "rzaKeyword",
            opcode .. " suffix must not be a typed keyword")
    end
end

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true, {"loop:"})
vim.cmd("runtime! syntax/rza.vim")
check_group(1, 1, "rzaLabel")

vim.cmd("enew")
vim.api.nvim_buf_set_lines(0, 0, -1, true,
    {"proc convert(input_m: ro, result_m: rw):"})
vim.cmd("runtime! syntax/rza.vim")
check_group(1, 6, "rzaLabel")

if #failures > 0 then
    for _, message in ipairs(failures) do
        vim.api.nvim_err_writeln(message)
    end
    vim.cmd("cquit")
else
    print("Neovim syntax and filetype checks passed")
    vim.cmd("qa!")
end
