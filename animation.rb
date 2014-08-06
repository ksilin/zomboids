class Animation

  def initialize(images, length = 500)
    @images = images
    @animation_length = length
    @current_animation_pos = 0
  end

  def update(delta)
    @current_animation_pos += delta
    if @current_animation_pos > @animation_length
      @current_animation_pos = 0
    end
  end

  def draw(location)
    idx = ([@images.size - 1, (@images.size) * @current_animation_pos/@animation_length].min)
    img_to_draw = @images[idx]
    img_to_draw.draw(location.x, location.y, 0, 1, 1, Gosu::Color::GREEN)
  end

end