if !has('python')
    finish
endif

"TODO: move all .py code in the lib/ relative path.
let s:py_dir = expand("<sfile>:p:h") . "/lib/"

function! GetPath()
"TODO: Figure out how to get the path of the .vim file so that I 
"can store all the .py code in a lib/ relative path.
python << EOF
import vim 
import os

filename = vim.current.buffer.name
print dir(vim.current)
libPath=os.path.join(os.path.dirname(filename), "lib")
raw = "let g:path=\"{path}\"".format(path=libPath)
vim.command(raw)
EOF
endfunction



function! GetHTMLFileName()
python << EOF
import os
import vim
vim.command("let g:htmlFile=\"\"")
dirname = os.path.dirname(vim.current.buffer.name)
filename = os.path.basename(vim.current.buffer.name)
filename = os.path.splitext(filename)[0]
filename =  os.path.join(dirname, filename + ".html")
vim.command("let g:htmlFile=\"{html}\"".format(html=filename))
EOF
endfunction

function! Markdown2HTML()
call GetHTMLFileName()
"Generates a .html version of the current file.
python << EOF

import vim
import markdown
import string

try:
    filename =  vim.eval("g:htmlFile")

    html = string.join(vim.current.buffer, "\n")
    html = markdown.markdown(html, output_format="html")
    
    f = open(filename, 'w')
    f.write(html)
    f.close()
     
    print "HTML output written to "+filename
except ImportError, e:
    print "MarkDown package not installed, please run: pip install markdown"
EOF

endfunction

function! MarkdownPreview()
call GetHTMLFileName()
" Will launch the generated html in a webrowser "
python << EOF
import vim 
import webbrowser

filename =  vim.eval("g:htmlFile")
webbrowser.open(filename)

EOF
endfunction

map <leader>md  :call Markdown2HTML()<CR>
map <leader>mdv  :call MarkdownPreview()<CR>
