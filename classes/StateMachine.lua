StateMachine = Class{}

function StateMachine:init(states)
	self.empty = {
		enter = function() end,
		exit = function() end,
		render = function() end,
		update = function() end,
	}

	self.states = states or {}
	self.current = self.empty
	self.currentStateName = nil
end

function StateMachine:is(stateName)
	return stateName == self.currentStateName
end

function StateMachine:change(stateName, params)
	assert(self.states[stateName])

	self.current:exit()

	self.currentStateName = stateName
	self.current = self.states[stateName]()
	self.current:enter(params)
end

function StateMachine:update(dt)
	self.current:update(dt)
end

function StateMachine:render()
	self.current:render()
end