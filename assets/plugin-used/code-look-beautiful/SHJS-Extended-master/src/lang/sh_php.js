if(!this.sh_languages){this.sh_languages={}}var lang="php";sh_languages[lang]=[[[/\b(?:include|include_once|require|require_once)\b/g,"sh-preproc",-1],[/\/\//g,"sh-comment",1],[/#/g,"sh-comment",1],[/\b[+-]?(?:(?:0x[A-Fa-f0-9]+)|(?:(?:[\d]*\.)?[\d]+(?:[eE][+-]?[\d]+)?))u?(?:(?:int(?:8|16|32|64))|L)?\b/g,"sh-number",-1],[/"/g,"sh-string",2],[/'/g,"sh-string",3],[/\b(?:and|or|xor|__FILE__|exception|php_user_filter|__LINE__|array|as|break|case|cfunction|class|const|continue|declare|default|die|do|each|echo|else|elseif|empty|enddeclare|endfor|endforeach|endif|endswitch|endwhile|eval|exit|extends|for|foreach|function|global|if|isset|list|new|old_function|print|return|static|switch|unset|use|var|while|__FUNCTION__|__CLASS__|__METHOD__)\b/g,"sh-keyword",-1],[/\/\/\//g,"sh-comment",4],[/\/\//g,"sh-comment",1],[/\/\*\*/g,"sh-comment",9],[/\/\*/g,"sh-comment",10],[/(?:\$[#]?|@|%)[A-Za-z0-9_]+/g,"sh-variable",-1],[/<\?php|~|!|%|\^|\*|\(|\)|-|\+|=|\[|\]|\\|:|;|,|\.|\/|\?|&|<|>|\|/g,"sh-symbol",-1],[/\{|\}/g,"sh-cbracket",-1],[/(?:[A-Za-z]|_)[A-Za-z0-9_]*(?=[ \t]*\()/g,"sh-function",-1]],[[/$/g,null,-2]],[[/\\(?:\\|")/g,null,-1],[/"/g,"sh-string",-2]],[[/\\(?:\\|')/g,null,-1],[/'/g,"sh-string",-2]],[[/$/g,null,-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,"sh-url",-1],[/<\?xml/g,"sh-preproc",5,1],[/<!DOCTYPE/g,"sh-preproc",6,1],[/<!--/g,"sh-comment",7],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)(?:\/)?>/g,"sh-keyword",-1],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)/g,"sh-keyword",8,1],[/&(?:[A-Za-z0-9]+);/g,"sh-preproc",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*(?:\/)?>/g,"sh-keyword",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*/g,"sh-keyword",8,1],[/@[A-Za-z]+/g,"sh-type",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,"sh-todo",-1]],[[/\?>/g,"sh-preproc",-2],[/([^=" \t>]+)([ \t]*)(=?)/g,["sh-type","sh-normal","sh-symbol"],-1],[/"/g,"sh-string",2]],[[/>/g,"sh-preproc",-2],[/([^=" \t>]+)([ \t]*)(=?)/g,["sh-type","sh-normal","sh-symbol"],-1],[/"/g,"sh-string",2]],[[/-->/g,"sh-comment",-2],[/<!--/g,"sh-comment",7]],[[/(?:\/)?>/g,"sh-keyword",-2],[/([^=" \t>]+)([ \t]*)(=?)/g,["sh-type","sh-normal","sh-symbol"],-1],[/"/g,"sh-string",2]],[[/\*\//g,"sh-comment",-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,"sh-url",-1],[/<\?xml/g,"sh-preproc",5,1],[/<!DOCTYPE/g,"sh-preproc",6,1],[/<!--/g,"sh-comment",7],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)(?:\/)?>/g,"sh-keyword",-1],[/<(?:\/)?[A-Za-z](?:[A-Za-z0-9_:.-]*)/g,"sh-keyword",8,1],[/&(?:[A-Za-z0-9]+);/g,"sh-preproc",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*(?:\/)?>/g,"sh-keyword",-1],[/<(?:\/)?[A-Za-z][A-Za-z0-9]*/g,"sh-keyword",8,1],[/@[A-Za-z]+/g,"sh-type",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,"sh-todo",-1]],[[/\*\//g,"sh-comment",-2],[/(?:<?)[A-Za-z0-9_\.\/\-_~]+@[A-Za-z0-9_\.\/\-_~]+(?:>?)|(?:<?)[A-Za-z0-9_]+:\/\/[A-Za-z0-9_\.\/\-_~]+(?:>?)/g,"sh-url",-1],[/(?:TODO|FIXME|BUG)(?:[:]?)/g,"sh-todo",-1]]];if(sh_afterLoad){sh_afterLoad(lang)};