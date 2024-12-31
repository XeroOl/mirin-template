---@diagnostic disable: undefined-global
local helper = require("spec.helper")

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
		spellcards.insert {20, 30, "my cool card of spelling", 999, {1,0.75, 1}}
		helper.update(0)
	end)

	-- any more testing is really testing our mock more than the functionality
end)
