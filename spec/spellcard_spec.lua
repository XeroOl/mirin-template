---@diagnostic disable: undefined-global
local helper = require("spec.helper")
local update = helper.update

describe("spellcard plugin", function()
	before_each(function()
		helper.reset()
		helper.init()
	end)

	after_each(function()
		xero = nil
	end)

	it("doesn't crash", function()
		local spellcards = xero.require('spellcards')
		spellcards.insert {0, 10, "my cool card of spelling", 1000, "#fcf"}
		helper.update(0)
	end)
end)
