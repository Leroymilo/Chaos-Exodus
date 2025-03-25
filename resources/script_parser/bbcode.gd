extends ScriptBase
class_name ScriptBBCode
# handles bbcode tags

# format: {bbcode:bbcode_tag with=arguments|text in between the start and end tags}

var opening_tag: String
var closing_tag: String
var content: ScriptTree

func parse(raw_text: String, i: int) -> int:
	i += "{bbcode:".length()
	var j = raw_text.find('|', i)
	opening_tag = raw_text.substr(i, j-i)
	var k = opening_tag.find(' ')
	closing_tag = opening_tag.substr(0, k)
	k = closing_tag.find('=')
	closing_tag = closing_tag.substr(0, k)
	content = ScriptTree.new()
	return content.parse(raw_text, j+1)

func get_text(length: int) -> RichText:
	var result := content.get_text(length)
	result.text = '['+opening_tag+']' + result.text + "[/"+closing_tag+']'
	return result
