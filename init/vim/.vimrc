"设置行号"                                                                                                                                                         
"set number"

"设置下划线"
set cursorline

"设置语法高亮"
syntax on

"如果取消自动缩进与智能缩进的注释,复制粘贴内容时会产生缩进问题"
"设置自动缩进"
"set autoindent"

"设置自动缩进,针对C语言"
"set cindent"

"设置智能缩进"
"set smartindent"

"设置TAB制表符占用空格的数量"
set tabstop=4

"设置每层缩进的空格数"
set shiftwidth=4

"设置制表符展开成空格（替换成空格）"
set expandtab

"设置退格键每次退格删除空格的数量"
set softtabstop=4

"智能tab，在行首按TAB将加入sw（shiftwidth）个空格，否则加入ts（tabstop）个空格"
set smarttab

"分离状态栏"
set laststatus=2

"设置状态栏状态信息"
"文件格式:%{&fileformat}"
"文件编码:%{&encoding}"
set statusline=当前文件路径:%F\ \ \ \ %0(当前行位置:%l\ \ \ \ 当前字符位置:%c\ \ \ \ 总行数:%L%)
