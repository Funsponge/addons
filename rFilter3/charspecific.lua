
  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...
  local cfg = ns.cfg

  -----------------------------
  -- CHARSPECIFIC REWRITES
  -----------------------------

  local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -- this file allows you to override default class settings with special settings for your own character
  -- ATTENTION: if you character name contains UTF-8 characters like âôû and such. Make sure this files is saved in UTF-8 file format

  if player_class == "PALADIN" then
    --PALADIN Buff List
    cfg.rf3_BuffList = {
      [1] = {
        spellid = 84963, --Inquisition
        spec = nil,
        size = 32,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 0, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 0.8,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
      [2] = {
        spellid = 86698, --Guardian of Ancient Kings
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 118 },
        unit            = "player",
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
      [3] = {
        spellid = 86700, --Ancient Power
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -100, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
      [4] = {
        spellid = 90174, --Divine Purpose
        spec = nil,
        size = 26,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 38, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
      [5] = {
        spellid = 31884, --Avenging Wrath
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 118 },
        unit            = "player",
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
      [6] = {
        spellid = 65148, --Sacred Shield
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -130, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
	  [7] = {
        spellid = 32182, --Heroism
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
	  [8] = {
        spellid = 80353, --Time Warp
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
	  	  [9] = {
        spellid = 90355, --Ancient Hysteria
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
	  [10] = {
        spellid = 31868, --Supplication
        spec = nil,
        size = 22,
        pos = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 70, y = 118 },
        unit = "player",
        validate_unit   = true,
        ismine          = true,
        desaturate      = true,
        match_spellid   = false,
        move_ingame     = false,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
	  
    }

    --Paladin Debuff List
    cfg.rf3_DebuffList = {
      [1] = {
        spellid         = 31803, --censure
        spec            = nil,
        pos             = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -70, y = 118 },
        size            = 22,
        unit            = "target",
        desaturate      = true,
        ismine          = true,
        move_ingame     = false,
        hide_ooc        = false,
        validate_unit   = true,
        alpha = {
          found = {
            frame = 1,
            icon = 1,
          },
          not_found = {
            frame = 0,
            icon = 0,
          },
        },
      },
    }

  --Paladin Cooldown List
    cfg.rf3_CooldownList = {
      [1] = {
        spellid           = 879, --exorcism
        spec              = nil,
        pos               = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = -38, y = 118 },
        size              = 26,
        desaturate        = false,
        move_ingame       = false,
		hide_ooc		  = true,
        alpha = {
          cooldown = {
            frame = 0,
            icon = 0,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,
          },
        },
      },
      [2] = {
        spellid           = 31884, --Avenging Wrath
        spec              = nil,
        pos               = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 100, y = 118 },
        size              = 22,
        desaturate        = false,
        move_ingame       = false,
		hide_ooc		  = true,
        alpha = {
          cooldown = {
            frame = 0,
            icon = 0,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,
          },
        },
      },
      [3] = {
        spellid           = 86698, --Guardian of Ancient Kings
        spec              = nil,
        pos               = { a1 = "BOTTOM", a2 = "BOTTOM", af = "UIParent", x = 130, y = 118 },
        size              = 22,
        desaturate        = false,
        move_ingame       = false,
		hide_ooc		  = true,
        alpha = {
          cooldown = {
            frame = 0,
            icon = 0,
          },
          no_cooldown = {
            frame = 1,
            icon = 1,


          },
        },
      },
    }
  end
