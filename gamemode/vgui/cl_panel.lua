local PANEL = {}

AccessorFunc(PANEL, "_DrawColor", "DrawColor")
AccessorFunc(PANEL, "_DrawBorder", "DrawBorder")

function PANEL:Paint(w, h)
	if self._DrawColor then
		surface.SetDrawColor(self._DrawColor)
		surface.DrawRect(0, 0, w, h)
	end

	if self._DrawBorder then
		surface.SetDrawColor(self._DrawBorder)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
end

vgui.Register("eternity_panel", PANEL, "DPanel")