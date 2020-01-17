#! /bin/bash

string2arg() {
    export arg_filename=$(cut -d":" -f1 <<< $1);
    export arg_linenum=$(cut -d":" -f2 <<< $1);
    min_offset=40
    let max_offset="min_offset*2"
    min=0
    if (($min_offset < $arg_linenum)); then
        let min="arg_linenum-$min_offset"
    fi
    let max="arg_linenum+$max_offset"
    if (($HIGHLIGHT_AREA == 0)); then
        bat --color=always --highlight-line $arg_linenum \
            --theme="Monokai Extended Light"\
            --style=header,grid,numbers --line-range $min:$max $arg_filename;
    else
        bat --color=always --highlight-line $arg_linenum \
            --theme="Monokai Extended Light"\
            --style=header,grid,numbers --line-range $min:$max $arg_filename;
    fi

}
