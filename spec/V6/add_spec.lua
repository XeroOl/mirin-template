---@diagnostic disable: undefined-global
local helper = require('spec.helper')
local update = helper.update

describe('add', function()

	before_each(function()
		helper.reset()
		helper.init(false, true)
	end)

	after_each(function()
		xero = nil
	end)

	it('should add mod values', function()
		xero.add(0, 1, xero.outCirc, {bumpy = 100})
		xero.add(1, 1, xero.outCirc, {bumpy = 100})
		xero.add(2, 1, xero.outCirc, {bumpy = 100})
		xero.add(3, 1, xero.outCirc, {bumpy = 100})
		update(4)
		assert.equal('400', helper.get_mod('bumpy'))
	end)

	it('should use options', function()
		xero.add(0, 1, xero.outCirc, {bumpy = 100}, {plr = 1})
		update(1)
		assert.equal('100', helper.get_mod('bumpy', 1))
		assert.equal(nil, helper.get_mod('bumpy', 2))
	end)

	it('should throw errors', function()
		assert.errors(function() xero.add() end)
	end)
	
end)