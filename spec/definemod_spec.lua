---@diagnostic disable: undefined-global
local helper = require("spec.helper")
local update = helper.update

describe("definemod", function()
	before_each(function()
		helper.reset()
		helper.init()
	end)

	after_each(function()
		xero = nil
	end)

	it("should support the fancy syntax", function()
		xero.definemod {"a", 100, "b", 100, "c"}
		update(1)
	end)

	it("shouldn't break if the user eases a dependent value first", function()
		xero.defineMod {"a", 100, "b"}
		xero.defineMod {"b", "c", function(b, c) return b + c end, "invert"}
		xero.set {1, 100, "c"}
		update(2)
	end)

end)
