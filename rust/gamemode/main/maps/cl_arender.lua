Curry = {}
do
    -- our own implementation of DrawTexturedRectRotated
    -- that allows us to use floating-point coordinates.
    -- Original implementation from Starfall can be found at:
    -- https://github.com/thegrb93/StarfallEx/blob/master/lua/starfall/libs_cl/render.lua

    local v1, v2, v3, v4 = Vector(), Vector(), Vector(), Vector()
    local m_rad, m_sin, m_cos = math.rad, math.sin, math.cos
    local DrawQuad = render.DrawQuad

    local function MakeQuad( x, y, w, h )
        v1.x, v1.y = x, y
        v2.x, v2.y = x + w, y
        v3.x, v3.y = x + w, y + h
        v4.x, v4.y = x, y + h
    end

    local function RotateVector( v, x, y, c, s )
        x = v.x * c - v.y * s + x
        y = v.x * s + v.y * c + y
        v.x = x
        v.y = y
    end

    function Curry.DrawTexturedRectRotated( x, y, w, h, angle, color )
        MakeQuad( w * -0.5, h * -0.5, w, h )

        local r = m_rad( -angle )
        local c, s = m_cos( r ), m_sin( r )

        RotateVector( v1, x, y, c, s )
        RotateVector( v2, x, y, c, s )
        RotateVector( v3, x, y, c, s )
        RotateVector( v4, x, y, c, s )

        DrawQuad( v1, v2, v3, v4, color )
    end
end
