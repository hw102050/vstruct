local cursor = {}

function cursor:seek(whence, offset)
	whence = whence or "cur"
	offset = offset or 0
	
	if whence == "set" then
		self.pos = offset
	elseif whence == "cur" then
		self.pos = self.pos + offset
	elseif whence == "end" then
		self.pos = #self.str
	end
	
	return self.pos
end

function cursor:read(n)
	local buf = self.str:sub(self.pos + 1, self.pos + n)
	self.pos = math.min(self.pos + n, #self.str)
	return buf
end

function cursor:write(buf)
	self.str = self.str:sub(1, self.pos)
		.. buf
		.. self.str:sub(self.pos + #buf + 1, -1)
	self.pos = self.pos + #buf
	return self
end	

function cursor:__call(source)
	return setmetatable(
		{ str = source, pos = 0 },
		cursor)
end

cursor.__index = cursor

setmetatable(cursor, cursor)

return cursor