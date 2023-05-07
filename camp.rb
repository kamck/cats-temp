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
        style { File.read(__FILE__).gsub(/.*__END__/m, "") }
        title "Donna's Temp"
      end

      body do
        self << yield
      end
    end
  end

  def index
    div.far! { "#{@f.round(1)}&deg;F" }
    div.cel! { "#{@c.round(1)}&deg;C" }
  end
end

__END__
body {
  background-color: black;
  color: white;
  text-align: right;
  font-family: sans-serif;
}

#far {
  font-size: 5.5em;
}

#cel {
  font-size: 3em;
}
