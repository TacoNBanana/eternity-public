local meta = FindMetaTable("Player")

function meta:OpenGUI(name, ...)
	netstream.Send("OpenGUI", {
		Name = name,
		Args = {...}
	}, self)
end