if !has('python')
    finish
endif

function! Markdown2HTML()
python << EOF
import vim
import markdown
import string

try:
    html = string.join(vim.current.buffer, "\n")
    html = markdown.markdown(html, output_format='html5')
    
    filename = vim.current.buffer.name+".html"
    
    f = open(filename, 'w')
    f.write(html)
    f.close()
     
    print "HTML output written to "+filename
except ImportError, e:
    print "MarkDown package not installed, please run: pip install markdown"
EOF

endfunction


map <leader>md  :call Markdown2HTML()<CR>
