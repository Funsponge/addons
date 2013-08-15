
  -- // rFilter3
  -- // zork - 2012

  --get the addon namespace
  local addon, ns = ...

  --object container
  local cfg = CreateFrame("Frame")
  ns.cfg = cfg

  cfg.rf3_BuffList, cfg.rf3_DebuffList, cfg.rf3_CooldownList = {}, {}, {}

  --local player_name, _ = UnitName("player")
  local _, player_class = UnitClass("player")

  -----------------------------
  -- DEFAULT CONFIG
  -----------------------------

  cfg.highlightPlayerSpells = true  --player spells will have a blue border
  cfg.updatetime            = 0.3   --how fast should the timer update itself
  cfg.timeFontSize          = 16
  cfg.countFontSize         = 18

  --paladin defaults
  if player_class == "PALADIN" then
    --default paladin buffs
    cfg.rf3_BuffList = {}
    --default paladin debuffs
    cfg.rf3_DebuffList = {}
    --default paladin cooldowns
    cfg.rf3_CooldownList = {}
  end

  --rogue defaults
  if player_class == "ROGUE" then
    --default rogue buffs
    cfg.rf3_BuffList = {}
    --default rogue debuffs
    cfg.rf3_DebuffList = {}
    --default rogue cooldowns
    cfg.rf3_CooldownList = {}
  end
