return {
    difficulties = {"easy","medium","hard","impossible"},
    PR = "child",
    keys = {"arrows"},
	maxDuration = 15,
    makeGameInstance = function(self, info)
		self.score = 1
		self.done = false
		self.speed = 40
		self.speedFactor = ({easy=5, medium=4, hard=3, impossible=1})[info.difficulty]
		self.inequality = ({easy=2.2, medium=2, hard=1.8, impossible=1.5})[info.difficulty]
		self.playing = false
		
        self.getReady = function(self,basePath)
            self.f = {x=love.graphics.getWidth()/2,y=0}
			self.b = {x=0,y=0}
			self.finger = love.graphics.newImage(basePath.."finger.png")
			self.copy = love.graphics.newImage(basePath.."copy.png")
			local back1 = love.graphics.newImage(basePath.."back.png")
			local back2 = love.graphics.newImage(basePath.."back2.png")
			local back3 = love.graphics.newImage(basePath.."back3.png")
			self.sound = love.audio.newSource(basePath.."back.mp3")
			self.back= {back1, back2, back3, back2}
			self.elapsed = 0
			print(self.inequality)
        end
        
        self.update = function(self, dt)
			self.elapsed = self.elapsed+dt
			
			if not self.playing then
				self.playing = true
				love.audio.play(self.sound)
				
			end
			
			if love.keyboard.isDown("up") then
				self.f.y = self.f.y - dt*self.speed
			end
			if love.keyboard.isDown("down") then
				self.f.y = self.f.y + dt*self.speed
			end
			if love.keyboard.isDown("left") then
				self.f.x = self.f.x - dt*self.speed
			end
			if love.keyboard.isDown("right") then
				self.f.x = self.f.x + dt*self.speed
			end
			
			local dx = self.f.x-self.b.x
			local dy = self.f.y-self.b.y
			
			local sx = (dx>0) and self.speed/self.inequality or -self.speed/self.inequality
			local sy = (dy>0) and self.speed/self.inequality or -self.speed/self.inequality
			
			self.b.x = self.b.x+sx*dt
			self.b.y = self.b.y+sy*dt
			
			if self.f.x > love.graphics.getWidth()/2 then
				self.f.x = love.graphics.getWidth()/2
			end
			if self.f.x < -love.graphics.getWidth()/2 then
				self.f.x = -love.graphics.getWidth()/2
			end
			if self.f.y > love.graphics.getHeight()/2 then
				self.f.y = love.graphics.getHeight()/2
			end
			if self.f.y < -love.graphics.getHeight()/2 then
				self.f.y = -love.graphics.getHeight()/2
			end
			
			if math.abs(dx)<self.copy:getWidth()/2 and math.abs(dy)<self.copy:getHeight()/2 then
				self.score = -1
				self.done = true
			end
			
        end

        self.draw = function(self)
			self.speed = love.graphics.getWidth()/self.speedFactor
			local cx = love.graphics.getWidth()/2
			local cy = love.graphics.getHeight()/2
			
			love.graphics.setColor(255,255,255)
			
			local backIndex = (math.floor(self.elapsed*4) % 4)+1
			love.graphics.draw(self.back[backIndex],cx,cy,0,1,1,517/2,318/2)
			
			love.graphics.draw(self.copy,cx+self.b.x,cy+self.b.y,0,1,1,64/2,26/2)
			
			love.graphics.draw(self.finger,cx+self.f.x,cy+self.f.y,0,1,1,20,20)

        end

        
        self.getScore = function(self, key)
            return self.score
        end

        self.isDone = function(self,key)
            return self.done
        end
        
    end
}
