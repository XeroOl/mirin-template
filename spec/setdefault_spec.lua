---@diagnostic disable: undefined-global
local helper = require("spec.helper")
local update = helper.update

describe("setdefault", function()
	before_each(function()
		helper.reset()
		helper.init()
	end)

	after_each(function()
		xero = nil
	end)

	it("works", function()
		xero.setDefault {100, "invert"}
		xero.set {4, 0, "invert"}
		xero.reset {8}
		helper.update(0)
		assert.equals('100', helper.get_mod("invert", 1), "mod wasn't set")
		helper.update(5)
		assert.equals('0', helper.get_mod("invert", 1), "mod wasn't unset")
		helper.update(5)
		assert.equals('100', helper.get_mod("invert", 1), "mod wasn't reset")
	end)
end)
