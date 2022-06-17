--highlight clear
--syntax reset
local s = {
    black       = { gui = "#282c34", cterm = "236" },
    red         = { gui = "#e06c75", cterm = "168" },
    green       = { gui = "#98c379", cterm = "114" },
    yellow      = { gui = "#e5c07b", cterm = "180" },
    blue        = { gui = "#61afef", cterm = "75"  },
    purple      = { gui = "#c678dd", cterm = "176" },
    cyan        = { gui = "#56b6c2", cterm = "73"  },
    white       = { gui = "#dcdfe4", cterm = "188" },

    fg          = { gui = "#dcdfe4", cterm = "188" },
    bg          = { gui = "#282c34", cterm = "236" },

    comment_fg  = { gui = "#5c6370", cterm = "241" },
    gutter_bg   = { gui = "#282c34", cterm = "236" },
    gutter_fg   = { gui = "#919baa", cterm = "247" },
    non_text    = { gui = "#373C45", cterm = "239" },

    cursor_line = { gui = "#313640", cterm = "237" },
    color_col   = { gui = "#313640", cterm = "237" },

    selection   = { gui = "#474e5d", cterm = "239" },
    vertsplit   = { gui = "#313640", cterm = "237" },
}

local cmd = vim.cmd

function h(group, fg, bg, attr)
  if type(fg) == "table" then
    cmd("hi " .. group .. " guifg=" .. fg["gui"] .. " ctermfg=" .. fg["cterm"])
  else
    cmd("hi " .. group .. " guifg=NONE cterm=NONE")
  end
  if type(bg) == "table" then
    cmd("hi " .. group .. " guibg=" .. bg["gui"] .. " ctermbg=" .. bg["cterm"])
  else
    cmd("hi " .. group .. " guibg=NONE ctermbg=NONE")
  end
  if attr == "" then
    cmd("hi " .. group .. " gui=NONE cterm=NONE")
  else
    cmd("hi " .. group .. " gui=" .. attr .. " cterm=" .. attr)
  end
end


h("Cursor", s["bg"], s["blue"], "")
h("CursorColumn", "", s["cursor_line"], "")
h("CursorLine", "", s["cursor_line"], "")

h("LineNr", s["gutter_fg"], s["gutter_bg"], "")
h("CursorLineNr", s["fg"], "", "")

h("DiffAdd", s["green"], "", "")
h("DiffChange", s["yellow"], "", "")
h("DiffDelete", s["red"], "", "")
h("DiffText", s["blue"], "", "")

h("IncSearch", s["bg"], s["yellow"], "")
h("Search", s["bg"], s["yellow"], "")

h("ErrorMsg", s["fg"], "", "")
h("ModeMsg", s["fg"], "", "")
h("MoreMsg", s["fg"], "", "")
h("WarningMsg", s["red"], "", "")
h("Question", s["purple"], "", "")

h("Pmenu", s["bg"], s["fg"], "")
h("PmenuSel", s["fg"], s["blue"], "")
h("PmenuSbar", "", s["selection"], "")
h("PmenuThumb", "", s["fg"], "")

h("SpellBad", s["red"], "", "")
h("SpellCap", s["yellow"], "", "")
h("SpellLocal", s["yellow"], "", "")
h("SpellRare", s["yellow"], "", "")

h("StatusLine", s["blue"], s["cursor_line"], "")
h("StatusLineNC", s["comment_fg"], s["cursor_line"], "")
h("TabLine", s["comment_fg"], s["cursor_line"], "")
h("TabLineFill", s["comment_fg"], s["cursor_line"], "")
h("TabLineSel", s["fg"], s["bg"], "")

h("Visual", "", s["selection"], "")
h("VisualNOS", "", s["selection"], "")

h("ColorColumn", "", s["color_col"], "")
h("Conceal", s["fg"], "", "")
h("Directory", s["blue"], "", "")
h("VertSplit", s["vertsplit"], s["vertsplit"], "")
h("Folded", s["fg"], "", "")
h("FoldColumn", s["fg"], "", "")
h("SignColumn", s["fg"], "", "")

h("MatchParen", s["blue"], "", "underline")
h("SpecialKey", s["fg"], "", "")
h("Title", s["green"], "", "")
h("WildMenu", s["fg"], "", "")


h("Whitespace", s["non_text"], "", "")
h("NonText", s["non_text"], "", "")
h("Comment", s["comment_fg"], "", "italic")
h("Constant", s["cyan"], "", "")
h("String", s["green"], "", "")
h("Character", s["green"], "", "")
h("Number", s["yellow"], "", "")
h("Boolean", s["yellow"], "", "")
h("Float", s["yellow"], "", "")

h("Identifier", s["red"], "", "")
h("Function", s["blue"], "", "")
h("Statement", s["purple"], "", "")

h("Conditional", s["purple"], "", "")
h("Repeat", s["purple"], "", "")
h("Label", s["purple"], "", "")
h("Operator", s["fg"], "", "")
h("Keyword", s["red"], "", "")
h("Exception", s["purple"], "", "")

h("PreProc", s["yellow"], "", "")
h("Include", s["purple"], "", "")
h("Define", s["purple"], "", "")
h("Macro", s["purple"], "", "")
h("PreCondit", s["yellow"], "", "")

h("Type", s["yellow"], "", "")
h("StorageClass", s["yellow"], "", "")
h("Structure", s["yellow"], "", "")
h("Typedef", s["yellow"], "", "")

h("Special", s["blue"], "", "")
h("SpecialChar", s["fg"], "", "")
h("Tag", s["fg"], "", "")
h("Delimiter", s["fg"], "", "")
h("SpecialComment", s["fg"], "", "")
h("Debug", s["fg"], "", "")
h("Underlined", s["fg"], "", "")
h("Ignore", s["fg"], "", "")
h("Error", s["red"], s["gutter_bg"], "")
h("Todo", s["purple"], "", "")




h("GitGutterAdd", s["green"], s["gutter_bg"], "")
h("GitGutterDelete", s["red"], s["gutter_bg"], "")
h("GitGutterChange", s["yellow"], s["gutter_bg"], "")
h("GitGutterChangeDelete", s["red"], s["gutter_bg"], "")

h("diffAdded", s["green"], "", "")
h("diffRemoved", s["red"], "", "")




h("gitcommitComment", s["comment_fg"], "", "")
h("gitcommitUnmerged", s["red"], "", "")
h("gitcommitOnBranch", s["fg"], "", "")
h("gitcommitBranch", s["purple"], "", "")
h("gitcommitDiscardedType", s["red"], "", "")
h("gitcommitSelectedType", s["green"], "", "")
h("gitcommitHeader", s["fg"], "", "")
h("gitcommitUntrackedFile", s["cyan"], "", "")
h("gitcommitDiscardedFile", s["red"], "", "")
h("gitcommitSelectedFile", s["green"], "", "")
h("gitcommitUnmergedFile", s["yellow"], "", "")
h("gitcommitFile", s["fg"], "", "")

cmd("hi link gitcommitNoBranch gitcommitBranch")
cmd("hi link gitcommitUntracked gitcommitComment")
cmd("hi link gitcommitDiscarded gitcommitComment")
cmd("hi link gitcommitSelected gitcommitComment")
cmd("hi link gitcommitDiscardedArrow gitcommitDiscardedFile")
cmd("hi link gitcommitSelectedArrow gitcommitSelectedFile")
cmd("hi link gitcommitUnmergedArrow gitcommitUnmergedFile")



