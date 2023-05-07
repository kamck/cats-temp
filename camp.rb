require "camping"

Camping.goes :CatsTemp

module CatsTemp::Controllers
  class Index
    def get
      read_temp
      render :index
    end

    private

    def read_temp
      5.times do |i|
        f = File.read "/sys/bus/w1/devices/28-000005b41d2c/w1_slave"
        temperature = /t=(\d+)/.match(f)
        if temperature
          @c = temperature[1].to_f / 1000
          @f = (@c * 9 / 5) + 32
          break
        end
      end
    end
  end
end

module CatsTemp::Views
  def layout
    html do
      head do
        title "Donna's Temp"
      end

      body do
        self << yield
      end
    end
  end

  def index
    div { "#{@f.round(1)}&deg;F" }
    div { "#{@c.round(1)}&deg;C" }
  end
end
