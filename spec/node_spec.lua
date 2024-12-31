---@diagnostic disable: undefined-global
local helper = require("spec.helper")

describe("node", function()
	before_each(function()
		helper.reset()
		helper.init()
	end)

	after_each(function()
		xero = nil
	end)

	it("changes things on start, even without an ease", function()
		local f = nil
		xero.node {"f", function(_f) f = _f end}
		helper.update(0)
		assert.equals(0, f, "f didn't run")
	end)
end)
