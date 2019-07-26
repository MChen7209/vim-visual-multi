"commands to add/subtract regions with visual selection
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! vm#visual#add(mode) abort

    call s:create_group()
    let [ w, h ] = [ 0, 0 ]

    if a:mode ==# 'v'     | call s:vchar()
    elseif a:mode ==# 'V' | call s:vline()
    else                  | let w = s:vblock(1)
    endif

    call s:remove_group(0)
    call s:G.rebuild_from_map()

    if a:mode ==# 'V'
        call s:G.split_lines()
        call s:G.remove_empty_lines()
    elseif a:mode ==# 'v'
        for r in s:R()
            if r.h | let h = 1 | break | endif
        endfor
    endif

    if h | let s:v.multiline = 1 | endif
    call s:G.update_and_select_region({'id': s:v.IDs_list[-1]})
    if w | call s:F.toggle_option('block_mode', 0) | endif
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! vm#visual#subtract(mode) abort

    call s:create_group()

    if a:mode ==# 'v'     | call s:vchar()
    elseif a:mode ==# 'V' | call s:vline()
    else                  | call s:vblock(1)
    endif

    call s:remove_group(1)
    call s:G.rebuild_from_map()
    call s:G.update_and_select_region({'id': s:v.IDs_list[-1]})
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! vm#visual#cursors(mode) abort
    """Create cursors, one for each line of the visual selection."""

    call s:create_group()

    "convert to visual block, if not V
    if a:mode ==# 'v' | exe "normal! \<C-v>" | endif

    if a:mode ==# 'V' | call s:vline()
    else              | call s:vblock(0)
    endif

    call s:remove_group(0)
    call s:G.rebuild_from_map()

    if a:mode ==# 'V'
        call s:G.split_lines()
        call s:G.cursor_mode()
        if get(g:, 'VM_autoremove_empty_lines', 1)
            call s:G.remove_empty_lines()
        endif
    else
        call s:G.cursor_mode()
    endif

    call s:G.update_and_select_region({'id': s:v.IDs_list[-1]})
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! vm#visual#split() abort
    """Split regions with regex pattern."""
    call s:init()
    if !len(s:R()) | return | endif

    echohl Type   | let pat = input('Pattern to remove > ') | echohl None
    if empty(pat) | call s:F.msg('Command aborted.', 1)     | return | endif

    let start = s:R()[0]                "first region
    let stop = s:R()[-1]                "last region

    call s:F.Cursor(start.A)            "check for a match first
    if !search(pat, 'nczW', stop.L)     "search method: accept at cursor position
        call s:F.msg("\t\tPattern not found", 1)
        call s:G.select_region(s:v.index)
        return
    endif

    let oldmap = copy(s:V.Bytes)
    call vm#commands#erase_regions()
    call s:create_group()

    "backup old patterns and create new regions
    let oldsearch = copy(s:v.search)
    call s:V.Search.get_slash_reg(pat)

    call s:G.get_all_regions(start.A, stop.B)

    "subtract regions and rebuild from map
    call extend(s:V.Bytes, oldmap)
    call s:remove_group(1)
    call s:G.rebuild_from_map()
    call s:V.Search.apply(oldsearch)
    call s:G.update_and_select_region()
endfun

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! s:vchar() abort
    "characterwise
    silent keepjumps normal! `<y`>`]
    call s:G.check_mutliline(0, s:G.new_region())
endfun

fun! s:vline() abort
    "linewise
    silent keepjumps normal! '<y'>`]
    call s:G.new_region()
endfun

fun! s:vblock(extend) abort
    "blockwise
    let start = getpos("'<")[1:2]
    let end = getpos("'>")[1:2]
    let w = end[1] - start[1]

    "create cursors downwards until end of block
    call cursor(start)

    while getpos('.')[1] < end[0]
        call vm#commands#add_cursor_down(0, 1)
    endwhile

    if a:extend
        call vm#commands#motion('l', w, 1, 0)
    endif
    return w
endfun

fun! s:create_group() abort
    "use a temporary regions group, so that it won't interfere with previous regions
    call s:init()
    let s:old_group      = s:v.active_group
    let s:v.no_search    = 1
    let s:v.active_group = -1
    let s:V.Groups[-1]   = []
    let s:v.eco = 1
endfun

fun! s:remove_group(subtract) abort
    "remove temporary region group
    for r in s:V.Groups[-1]
        if a:subtract | call r.clear(1)
        else          | let r.group = s:old_group
        endif
    endfor

    let s:v.active_group = s:old_group
    call remove(s:V.Groups, -1)
    let s:v.silence = 0
endfun

fun! s:init() abort
    "init script vars
    let s:V = b:VM_Selection
    let s:v = s:V.Vars
    let s:G = s:V.Global
    let s:F = s:V.Funcs
endfun

let s:R = { -> s:V.Regions }


" vim: et ts=4 sw=4 sts=4 :
