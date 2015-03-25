haxe -D stage3Donly -swf-version 12 -cp src -dce no --macro include('robotlegs') -lib openfl -lib lime -lib msignal -lib swiftsuspenders -swf bin/openfl-robotlegs.swc

pause