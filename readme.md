This is an OpenFL 2.x/Haxe port of the popular AS3 Micro-Architecture framework Robotlegs v2.2.1
built on 2014/12/29

For more information on Robotlegs I suggest viewing the official as3 library repo
https://github.com/robotlegs/robotlegs-framework

DIFFERENCES BETWEEN AS3 AND HAXE VERSIONS

metadata syntax is slightly different in haxe compared to AS3.
AS3: [Inject]
Haxe: @inject

AS3: [Inject(optional=true)]
Haxe: @inject("optional=true")

The curernt haxe robotlegs implementation relies on the use of Runtime Type Information meta tag (@:rtti) on any classes that require injection.
eg:
@:rtti
class ClassName
{
	...
}

LICENSE

The MIT License

Copyright (c) 2009 - 2013 the original author or authors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.