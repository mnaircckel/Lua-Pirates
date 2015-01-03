require "collisions"

function Player(x,y,sprite,rotation,speed,turn_speed,drag,velocity,max_velocity)
	local self = {}

	self.x = x
	self.y = y
	self.sprite = sprite
	self.rotation = rotation
	self.speed = speed
	self.turn_speed = turn_speed
	self.drag = drag
	self.velocity = velocity
	self.max_velocity = max_velocity

	function self.get_position()
		return self.x,self.y
	end

	function self.get_rotation()
		return self.rotation
	end

	function self.get_sprite()
		return self.sprite
	end

	function self.get_tile_location()
		local tile_x = math.floor(self.x/TILE_SIZE)
		local tile_y = math.floor(self.y/TILE_SIZE)
		return tile_x,tile_y
	end

	function self.update(dt)
		self.move(dt)
	end

	function self.move(dt)

		local before_move_x = self.x
		local before_move_y = self.y
		local before_move_velocity = self.velocity

		if KEYBOARD_STATE.get_direction() == "forward" then
			self.velocity = self.velocity+self.speed
		elseif KEYBOARD_STATE.get_direction() == "backward" then
			self.velocity = self.velocity-self.speed
		end

		if KEYBOARD_STATE.get_direction() ~= nil then
			if KEYBOARD_STATE.get_rotation() == "clockwise" then
				self.rotation = self.rotation + (self.turn_speed*dt)/RADIANS
			elseif KEYBOARD_STATE.get_rotation() == "counterclockwise" then
				self.rotation = self.rotation - (self.turn_speed*dt)/RADIANS
			end
		else
			if KEYBOARD_STATE.get_rotation() == "clockwise" then
				self.rotation = self.rotation + (self.turn_speed*dt)/RADIANS
				self.velocity = self.velocity+self.speed
			elseif KEYBOARD_STATE.get_rotation() == "counterclockwise" then
				self.rotation = self.rotation - (self.turn_speed*dt)/RADIANS
				self.velocity = self.velocity+self.speed
			end

		end

		self.velocity = self.velocity - self.velocity*drag
		if math.abs(self.velocity) > self.max_velocity then
			self.velocity = before_move_velocity
		end

		self.x = self.x + math.cos(self.rotation)*(self.velocity*dt)
		self.y = self.y + math.sin(self.rotation)*(self.velocity*dt)

		self.handle_collisions(before_move_x,before_move_y)

	end


	function self.handle_collisions(before_move_x,before_move_y)

		local player_x,player_y = self.get_position()
		local tile_x,tile_y = self.get_tile_location()

		if collision_point(player_x,player_y,tile_x,tile_y) then
			self.x = before_move_x
			self.y = before_move_y
		end

	end



	return self
end