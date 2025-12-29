local AZN_RadialMenu = {}
AZN_RadialMenu.utils = AZN_RadialMenu.utils or {}
AZN_RadialMenu.utils.math = AZN_RadialMenu.utils.math or {}
AZN_RadialMenu.Selected = AZN_RadialMenu.Selected or {}
Map = Map or {}
local math = math
local ipairs = ipairs
local table = table
local surface = surface
local draw = draw
local noTexture = draw.NoTexture
local drawText = draw.DrawText
local setDrawColor = surface.SetDrawColor
local Color = Color
local sqrt = math.sqrt
local ease = math.ease
local max = math.max
local rad = math.rad
local cos = math.cos
local sin = math.sin
local abs = math.abs
local floor = math.floor
local drawPoly = surface.DrawPoly
local insert = table.insert
AZN_RadialMenu.ShowMenu = false
-- perform a linear interpolation but with colors
function AZN_RadialMenu.utils.math.lerpColor(t, from, to)
    local fr, fg, fb, fa = from.r, from.g, from.b, from.a or 255
    local tr, tg, tb, ta = to.r, to.g, to.b, to.a or 255
    local r = fr + (tr - fr) * t
    local g = fg + (tg - fg) * t
    local b = fb + (tb - fb) * t
    local a = fa + (ta - fa) * t
    return r, g, b, a
end

function AZN_RadialMenu.utils.math.easedLerpColor(frac, from, to)
    return AZN_RadialMenu.utils.math.lerpColor(ease.InSine(frac), from, to)
end

-- computes area using determinant
-- A := [ x1 y1 1  
--         x2 y2 1  
--         x3 y3 1 ]
-- Area = 1/2 * detA
function AZN_RadialMenu.utils.math.triangleArea(p1, p2, p3)
    local x1, y1 = p1.x, p1.y
    local x2, y2 = p2.x, p2.y
    local x3, y3 = p3.x, p3.y
    return 0.5 * (x1 * (y2 - y3) - x2 * (y1 - y3) + x3 * (y1 - y2))
end

-- for each triangle, check using barycentric coordinates whether P(x, y) lies within the triangle
function AZN_RadialMenu.utils.math.inPolygon(triangles, x, y)
    local p = {
        x = x,
        y = y
    }

    for _, t in ipairs(triangles) do
        if #t == 3 then
            local alpha = ((t[2].y - t[3].y) * (x - t[3].x) + (t[3].x - t[2].x) * (y - t[3].y)) / ((t[2].y - t[3].y) * (t[1].x - t[3].x) + (t[3].x - t[2].x) * (t[1].y - t[3].y))
            local beta = ((t[3].y - t[1].y) * (x - t[3].x) + (t[1].x - t[3].x) * (y - t[3].y)) / ((t[2].y - t[3].y) * (t[1].x - t[3].x) + (t[3].x - t[2].x) * (t[1].y - t[3].y))
            local gamma = 1 - alpha - beta
            if alpha > 0 and beta > 0 and gamma > 0 then return true end
        end
    end
    return false
end

-- find polygon centroid 
function AZN_RadialMenu.utils.math.centroid(triangles)
    local points = {}
    local areas = {}
    local polygonArea = 0
    for k, t in ipairs(triangles) do
        if #t == 3 then
            local area = AZN_RadialMenu.utils.math.triangleArea(t[1], t[2], t[3])
            polygonArea = polygonArea + area
            insert(areas, area)
        end
    end

    for k, t in ipairs(triangles) do
        if #t == 3 then
            local localCentroidX = (t[1].x + t[2].x + t[3].x) / 3
            local localCentroidY = (t[1].y + t[2].y + t[3].y) / 3
            insert(points, {(localCentroidX * areas[k]) / polygonArea, (localCentroidY * areas[k]) / polygonArea})
        end
    end

    local centroid = {
        x = 0,
        y = 0
    }

    for k, v in ipairs(points) do
        centroid.x = centroid.x + v[1]
        centroid.y = centroid.y + v[2]
    end
    return centroid
end

-- >________________< to /\/\/\/\/\/\/\/\
function AZN_RadialMenu.utils.math.triangulate(inner, outer)
    local triangles = {}
    for i = 1, #inner + #outer do
        local p1, p2, p3
        p1 = outer[floor(i / 2) + 1]
        p3 = inner[floor((i + 1) / 2) + 1]
        if i % 2 == 0 then
            p2 = outer[floor((i + 1) / 2)]
        else
            p2 = inner[floor((i + 1) / 2)]
        end

        insert(triangles, {p1, p2, p3})
    end
    return triangles
end

-- Helper function to cache the triangles that will be drawn to the screen
function AZN_RadialMenu.utils.cacheArc(x0, y0, r, start_angle, end_angle, thickness, roughness)
    -- Fails silently
    if not (r > 0) then return {} end
    local triangles
    local step = max(roughness or 1, 1)
    if start_angle > end_angle then step = abs(step) * -1 end
    local inner, outer = {}, {}
    local innerRadius = r - thickness
    for t = start_angle, end_angle, step do
        local trad = rad(t)
        local xt0, yt0 = cos(trad), -sin(trad)
        local inner_xt = x0 + xt0 * innerRadius
        local inner_yt = y0 + yt0 * innerRadius
        local outer_xt = x0 + xt0 * r
        local outer_yt = y0 + yt0 * r
        insert(inner, {
            x = inner_xt,
            y = inner_yt,
            u = (inner_xt - x0) / r + 0.5,
            v = (inner_yt - y0) / r + 0.5
        })

        insert(outer, {
            x = outer_xt,
            y = outer_yt,
            u = (outer_xt - x0) / r + 0.5,
            v = (outer_yt - y0) / r + 0.5
        })
    end

    triangles = AZN_RadialMenu.utils.math.triangulate(inner, outer)
    return triangles
end

-- Main function to actually draw arcs (using draw.DrawPoly)
function AZN_RadialMenu.utils.drawArc(polygons)
    for k, polygon in ipairs(polygons) do
        drawPoly(polygon)
    end
end

AZN_RadialMenu.emoteNames = {"sent_foundation", "sent_ceiling", "sent_wall", "sent_doorway", "sent_door"}
AZN_RadialMenu.emotes = {AZN_RadialMenu.emoteNames[1], AZN_RadialMenu.emoteNames[2], AZN_RadialMenu.emoteNames[3], AZN_RadialMenu.emoteNames[4], AZN_RadialMenu.emoteNames[5]}
AZN_RadialMenu.emoteNames2 = {
    "Wood", --, "Stone", "Metal"
    "Rotate"
}

AZN_RadialMenu.emotes2 = {
    AZN_RadialMenu.emoteNames2[1], --, AZN_RadialMenu.emoteNames2[2], AZN_RadialMenu.emoteNames2[3]
    AZN_RadialMenu.emoteNames2[2]
}

local innerCircle = AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 125, 0, 360, 125, 0.5)
local arcs = {}
local angFrac = 360 / #AZN_RadialMenu.emotes
local start = rad(angFrac) / 2
local gap = 2
for i = 1, #AZN_RadialMenu.emotes do
    insert(arcs, AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 300, (i - 1) * angFrac + gap, i * angFrac - gap, 150, 0.5))
end

local centers = {}
for i = 1, #arcs do
    local p = AZN_RadialMenu.utils.math.centroid(arcs[i])
    insert(centers, {p.x, p.y})
end

local innerCircle2 = AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 125, 0, 360, 125, 0.5)
local arcs2 = {}
local angFrac2 = 360 / #AZN_RadialMenu.emotes2
local start = rad(angFrac2) / 2
local gap = 2
for i = 1, #AZN_RadialMenu.emotes2 do
    insert(arcs2, AZN_RadialMenu.utils.cacheArc(ScrW() / 2, ScrH() / 2, 300, (i - 1) * angFrac + gap, i * angFrac - gap, 150, 0.5))
end

local centers2 = {}
for i = 1, #arcs2 do
    local p = AZN_RadialMenu.utils.math.centroid(arcs2[i])
    insert(centers2, {p.x, p.y})
end

surface.CreateFont("RadialMenu_Big", {
    font = "Roboto Condensed Light",
    size = 42
})

surface.CreateFont("RadialMenu_Normal", {
    font = "Roboto Condensed Light",
    size = 28
})

local fontHeight = 14
local animStart = SysTime()
local animTime = 0.25
local mouseEnabled
local showMenu = false
local foundation = Material("icons/build/foundation.png", "noclamp smooth")
local wall = Material("icons/build/wall.png", "noclamp smooth")
local ceiling = Material("icons/build/roof.png", "noclamp smooth")
local doorway = Material("icons/build/doorframe.png", "noclamp smooth")
local door = Material("icons/open_door.png", "noclamp smooth")
concommand.Add("+azrm_showmenu", function() showMenu = true end)
concommand.Add("-azrm_showmenu", function() showMenu = false end)
hook.Add("HUDPaint", "AZRM::Render2D", function()
    if not LocalPlayer():Alive() then return end
    local wep = LocalPlayer():GetActiveWeapon()
    if IsValid(wep) then
        if wep:GetClass() == "hands_hammer" then
            if showMenu then
                if not mouseEnabled then
                    gui.EnableScreenClicker(true)
                    mouseEnabled = true
                end

                noTexture()
                for i = 1, #arcs2 do
                    local withinPoly = AZN_RadialMenu.utils.math.inPolygon(arcs[i], gui.MouseX(), gui.MouseY())
                    if withinPoly and input.IsMouseDown(MOUSE_LEFT) then
                        Map.Str2 = AZN_RadialMenu.emotes2[i]
                        net.Start("gRust_ServerModel_new")
                        net.WriteString(AZN_RadialMenu.emotes2[i])
                        net.SendToServer()
                        showMenu = false
                        return
                    end

                    if withinPoly then
                        setDrawColor(AZN_RadialMenu.utils.math.easedLerpColor((SysTime() - animStart) / animTime, Color(255, 255, 255, 255), Color(103, 112, 218, 200)))
                        drawText(AZN_RadialMenu.emotes2[i], "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    else
                        setDrawColor(64, 64, 64, 255)
                    end

                    AZN_RadialMenu.utils.drawArc(arcs2[i])
                end

                setDrawColor(64, 64, 64, 255)
                AZN_RadialMenu.utils.drawArc(innerCircle2)
                -- drawText( "Selection", "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
                for i = 1, #centers2 do
                    if i > 1 then
                        drawText(tostring(AZN_RadialMenu.emotes2[i]), "RadialMenu_Normal", centers2[i][1], centers2[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    else
                        drawText(tostring(AZN_RadialMenu.emotes2[i]), "RadialMenu_Normal", centers2[i][1], centers2[i][2] - fontHeight, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                    end
                end
            else
                if mouseEnabled then
                    gui.EnableScreenClicker(false)
                    mouseEnabled = false
                end
            end
            return
        end

        if showMenu then
            if not mouseEnabled then
                gui.EnableScreenClicker(true)
                mouseEnabled = true
            end

            noTexture()
            for i = 1, #arcs do
                local withinPoly = AZN_RadialMenu.utils.math.inPolygon(arcs[i], gui.MouseX(), gui.MouseY())
                if withinPoly and input.IsMouseDown(MOUSE_LEFT) then
                    Map.Str = AZN_RadialMenu.emotes[i]
                    net.Start("gRust_ServerModel")
                    net.WriteString(AZN_RadialMenu.emotes[i])
                    net.SendToServer()
                    if Rust.GhostEntity then Rust.GhostEntity = nil end
                    Rust.Selected = AZN_RadialMenu.emotes[i]
                    showMenu = false
                    return
                end

                if withinPoly then
                    setDrawColor(AZN_RadialMenu.utils.math.easedLerpColor((SysTime() - animStart) / animTime, Color(255, 255, 255, 255), Color(255, 0, 0, 255)))
                    --drawText(AZN_RadialMenu.emotes[i], "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
                else
                    setDrawColor(255, 255, 255, 255)
                end

                AZN_RadialMenu.utils.drawArc(arcs[i])
            end

            setDrawColor(255, 255, 255, 255)
            AZN_RadialMenu.utils.drawArc(innerCircle)
            -- drawText("Selection", "RadialMenu_Big", ScrW() / 2, ScrH() / 2 - 21, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
            for i = 1, #centers do
                local withinPoly = AZN_RadialMenu.utils.math.inPolygon(arcs[i], gui.MouseX(), gui.MouseY())
                if scripted_ents.Get(AZN_RadialMenu.emotes[i]) then
                    if AZN_RadialMenu.emotes[i] == "sent_foundation" then
                        local txt = scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName .. "\n"
                        local txt2 = "This is a foundation\n to build before placing a wall!\n\n\n\n\n"
                        local txt3 = "25 x Wood (" .. LocalPlayer():GetWood() .. ")"
                        local txt_n = txt .. txt2 .. txt3
                        if withinPoly then drawText(txt_n, "Default", ScrW() / 2, ScrH() / 2 - 21, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER) end
                        surface.SetMaterial(foundation)
                        surface.SetDrawColor(0, 0, 0, 255)
                        surface.DrawTexturedRect(centers[i][1], centers[i][2] - fontHeight, 50, 50)
                        Rust.GhostEntity = nil
                    end

                    if AZN_RadialMenu.emotes[i] == "sent_wall" then
                        local txt = scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName .. "\n"
                        local txt2 = "This is a Wall\nto build after placing a foundation!\n\n\n\n\n"
                        local txt3 = "25 x Wood (" .. LocalPlayer():GetWood() .. ")"
                        local txt_n = txt .. txt2 .. txt3
                        if withinPoly then drawText(txt_n, "Default", ScrW() / 2, ScrH() / 2 - 21, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER) end
                        surface.SetMaterial(wall)
                        surface.SetDrawColor(0, 0, 0, 255)
                        surface.DrawTexturedRect(centers[i][1], centers[i][2] - fontHeight, 50, 50)
                    end

                    if AZN_RadialMenu.emotes[i] == "sent_ceiling" then
                        local txt = scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName .. "\n"
                        local txt2 = "This is a Ceiling\nto build after placing a foundation!\n\n\n\n\n"
                        local txt3 = "25 x Wood (" .. LocalPlayer():GetWood() .. ")"
                        local txt_n = txt .. txt2 .. txt3
                        if withinPoly then drawText(txt_n, "Default", ScrW() / 2, ScrH() / 2 - 21, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER) end
                        surface.SetMaterial(ceiling)
                        surface.SetDrawColor(0, 0, 0, 255)
                        surface.DrawTexturedRect(centers[i][1], centers[i][2] - fontHeight, 50, 50)
                    end

                    if AZN_RadialMenu.emotes[i] == "sent_doorway" then
                        local txt = scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName .. "\n"
                        local txt2 = "This is a Doorway\nto build after placing a foundation!\n\n\n\n\n"
                        local txt3 = "25 x Wood (" .. LocalPlayer():GetWood() .. ")"
                        local txt_n = txt .. txt2 .. txt3
                        if withinPoly then drawText(txt_n, "Default", ScrW() / 2, ScrH() / 2 - 21, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER) end
                        surface.SetMaterial(doorway)
                        surface.SetDrawColor(0, 0, 0, 255)
                        surface.DrawTexturedRect(centers[i][1], centers[i][2] - fontHeight, 50, 50)
                    end

                    if AZN_RadialMenu.emotes[i] == "sent_door" then
                        local txt = scripted_ents.Get(AZN_RadialMenu.emotes[i]).PrintName .. "\n"
                        local txt2 = "This is a Door\nto build after placing a doorway!\n\n\n\n\n"
                        local txt3 = "25 x Wood (" .. LocalPlayer():GetWood() .. ")"
                        local txt_n = txt .. txt2 .. txt3
                        if withinPoly then drawText(txt_n, "Default", ScrW() / 2, ScrH() / 2 - 21, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER) end
                        surface.SetMaterial(door)
                        surface.SetDrawColor(0, 0, 0, 255)
                        surface.DrawTexturedRect(centers[i][1], centers[i][2] - fontHeight, 50, 50)
                    end
                end
            end
        else
            if mouseEnabled then
                gui.EnableScreenClicker(false)
                mouseEnabled = false
            end
        end
    end
end)