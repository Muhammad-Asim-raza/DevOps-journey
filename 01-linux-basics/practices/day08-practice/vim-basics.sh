#!/bin/bash
# ================================================
# vim-basics.sh
# Vim Basics Demonstration and Reference
# Author: Asim Raza
# Day 8 of DevOps Journey
# ================================================

echo "============================================"
echo "   VIM BASICS REFERENCE"
echo "============================================"

echo ""
echo "[ VIM MODES ]"
echo "  NORMAL  = default mode, navigation and commands"
echo "  INSERT  = typing text (press i to enter)"
echo "  VISUAL  = selecting text (press v to enter)"
echo "  COMMAND = running commands (press : to enter)"

echo ""
echo "[ OPENING VIM ]"
echo "  vim filename     = open or create file"
echo "  vim +10 file     = open at line 10"
echo "  vim file1 file2  = open multiple files"

echo ""
echo "[ EXITING VIM ]"
echo "  :q               = quit (no changes)"
echo "  :q!              = force quit (discard changes)"
echo "  :w               = save (write)"
echo "  :wq              = save and quit"
echo "  :x               = save and quit"
echo "  ZZ               = save and quit (no colon)"

echo ""
echo "[ NAVIGATION ]"
echo "  h j k l          = left down up right"
echo "  w b e            = word forward back end"
echo "  0 $              = line start end"
echo "  gg G             = file start end"
echo "  Ctrl+f Ctrl+b    = page down up"

echo ""
echo "[ EDITING ]"
echo "  i I a A o O      = enter insert mode"
echo "  x                = delete character"
echo "  dd               = delete line"
echo "  yy               = copy line"
echo "  p P              = paste after before"
echo "  u Ctrl+r         = undo redo"

echo ""
echo "[ SEARCH AND REPLACE ]"
echo "  /word            = search forward"
echo "  ?word            = search backward"
echo "  n N              = next previous match"
echo "  :%s/old/new/g    = replace all"
echo "  :%s/old/new/gc   = replace with confirm"

echo ""
echo "[ COMMAND MODE ]"
echo "  :set number      = show line numbers"
echo "  :syntax on       = syntax highlighting"
echo "  :set paste       = paste mode"

echo ""
echo "============================================"
echo "   VIM REFERENCE COMPLETE"
echo "============================================"
