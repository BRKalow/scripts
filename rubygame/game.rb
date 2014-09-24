class Entity
  attr_accessor :life, :power, :enemy, :xp, :level, :foods

  def initialize(life,power,xp,level)
    self.life = life
    self.power = power
    self.xp = xp
    self.level = level
    self.foods = 3
  end

  def change_state(state)
    self.state = state
  end

  def action(action)
    self.send action
  end

  def take_life(amount)
    self.life -= amount

    if self.life < 0
      self.life = 0
    end
  end

  def enemy_death
    puts "You killed an enemy for #{self.enemy.xp} XP."
    self.xp += self.enemy.xp
    self.levelup
    self.foods += Random.rand(2)
    self.enemy = nil
  end

  protected
    def rest
      if self.enemy.is_a? Entity
        puts "You rest and restore life"
        self.life += 5
        self.enemy.power += 5
      else
        puts "While you are resting an enemy appears!"
        self.life += 5
        self.spawn_enemy
      end
    end

    def fight
      unless self.enemy.is_a? Entity
          self.enemy = self.spawn_enemy
      end
      puts "You attack your enemy"
      self.enemy.take_life(Random.rand(self.power))
      self.take_life(Random.rand(self.enemy.power))
      puts "Current life: #{self.life}"
      puts "Enemy life: #{self.enemy.life}"
    end

    def run
      puts "You run from the fight, but give up half of your XP and some power"
      self.xp /= 2
      self.power -= Random.rand(4)
      self.enemy = nil
    end

    def train
      puts "You increase your power, but lose some life"
      self.power += 5
      self.take_life(Random.rand(5))
      if self.enemy.is_a? Entity
        self.enemy.life += 5
      end
    end

    def levelup
      if (self.xp - ((self.level + 1) * 10)) >= 0
        self.xp -= ((self.level + 1) * 10)
        self.level += 1
        self.power += Random.rand(3)
        self.life  += 10 + Random.rand(5)
        puts "You level up to level #{self.level}"
      end
    end

    def eat
      if self.foods > 0
        self.foods -= 1
        self.life += Random.rand(5)
        puts "You eat a food and now have #{self.life} life"
      else
        puts "You don't have any food to eat"
      end
    end

    def godmode
      self.power = 9000
      self.life = 9000
    end

    def stats
      puts "Your Stats:"
      puts "Current life: #{self.life}"
      puts "Current power: #{self.power}"
      puts "Current XP: #{self.xp}"
      puts "Current Level: #{self.level}"
      puts "Current foods: #{self.foods}"
    end

    def quit
      puts "Thanks for playing"
      exit
    end

    def spawn_enemy
      level = self.level
      xp = level*Random.rand(10)
      power = Random.rand(level + 1) + 5
      life = 10 + Random.rand(level)

      Entity.new(life,power,xp,level)
    end

    def method_missing(method, *args, &block)
      puts "You do nothing"
    end
end

def game
  puts "What would you like to do?"
  puts "You can fight, run, train, rest, stats, or eat"

  action = gets.chomp

  @e.action(action)

  if @e.life == 0
    puts "You lose!"
  else
    if @e.enemy && @e.enemy.life == 0
      @e.enemy_death
    end
    game()
  end
end

puts "Welcome to my terrible game."

@e = Entity.new(20,5,0,1)

game()
