defmodule BudgetdWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use BudgetdWeb, :html

  embed_templates "page_html/*"

  def carousel(assigns) do
    ~H"""
    <div class="mb-auto carousel rounded-box mt-8 w-full">
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1559703248-dcaaec9fab78.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1565098772267-60af42b81ef2.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1572635148818-ef6fd45eb394.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1494253109108-2e30c049369b.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1550258987-190a2d41a8ba.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1559181567-c3190ca9959b.webp"
          alt="Pizza"
        />
      </div>
      <div class="carousel-item">
        <img
          src="https://img.daisyui.com/images/stock/photo-1601004890684-d8cbf643f5f2.webp"
          alt="Pizza"
        />
      </div>
    </div>
    """
  end
end
