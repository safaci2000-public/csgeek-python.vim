function! CassToCLI(columnFamily) 
python << EOF
import os, vim, string

def main():
    data = ["The following lines are cassandra-cli inserts, simply paste them \
into the cassandra-cli to write them into your cass cluster::"]
    cf = vim.eval("a:columnFamily")
    buffer  = string.join(vim.current.buffer, "\n")
    count = 0
    lines = buffer.split("\n")
    rowkey = ""
    for line in buffer.split("\n"):
        if line.startswith("RowKey"):
            rowkey = get_row_key(line)
        elif line.startswith("=> "):
            fixed = fix_insert(line, rowkey, cf)
            if fixed is not None:
                data.append(fixed)


    vim.current.buffer.append(data)

def get_row_key(key):
    # Example:  RowKey: 12345
    key = key.replace("RowKey:", "")
    return key.strip()

def fix_insert(line, rowkey, cf):
    import re
    # Exmaple:  => (column=1357718400000, value=ThisIsATest, timestamp=1372359948489000)
    column = value = None
    m = re.search("\(column=(.+),.*value=", line)
    if m is not None:
        column = m.group(1)
    m = re.search("value=(.+),", line)
    if m is not None:
        value = m.group(1)

    if column is not None and value is not None:
        return "set {CF}['{row}']['{column}'] = '{value}';".format(CF=cf,
        row=rowkey, column=column, value=value)

main()

EOF


endfunction

